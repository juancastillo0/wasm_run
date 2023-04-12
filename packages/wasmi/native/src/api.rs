use crate::bridge_generated::{
    new_list_value_2_0, wire_ExternalValue, wire_list_value_2, NewWithNullPtr, Wire2Api,
};
use anyhow::{Ok, Result};
use flutter_rust_bridge::{
    frb, opaque_dyn, support::new_leak_box_ptr, DartAbi, DartOpaque, DartSafe, IntoDart,
    RustOpaque, StreamSink, SyncReturn,
};
use once_cell::sync::Lazy;
use std::{
    collections::HashMap,
    convert::TryInto,
    default,
    ffi::c_void,
    fmt::{Debug, Display},
    sync::RwLock,
};
pub use wasmi::{core::Pages, Func, Global, GlobalType, Memory, Mutability, Table};
use wasmi::{core::ValueType, *};

static ARRAY: Lazy<RwLock<GlobalState>> = Lazy::new(|| RwLock::new(Default::default()));

#[derive(Debug, Default)]
struct GlobalState {
    map: HashMap<u32, WasmiModuleImpl>,
    last_id: u32,
}

#[derive(Debug)]
struct WasmiModuleImpl {
    module: Module,
    linker: Linker<u32>,
    store: Store<u32>,
    instance: Option<Instance>,
    builder: Option<WasmiModuleBuilder>,
}

// impl std::panic::RefUnwindSafe for WasmiModuleImpl {}
// impl std::panic::UnwindSafe for WasmiModuleImpl {}

pub struct WasmiModuleId(pub u32);
pub struct WasmiInstanceId(pub u32);

struct WasmiModuleBuilder {
    sink: StreamSink<i32>,
}

impl Debug for WasmiModuleBuilder {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("WasmiModuleBuilder").finish()
    }
}

impl WasmiInstanceId {
    pub fn call_function(&self, name: String) -> Result<Vec<Value2>> {
        self.call_function_with_args(name, vec![])
    }
    pub fn call_function_with_args_sync(
        &self,
        name: String,
        args: Vec<Value2>,
    ) -> Result<SyncReturn<Vec<Value2>>> {
        self.call_function_with_args(name, args).map(SyncReturn)
    }
    pub fn call_function_with_args(&self, name: String, args: Vec<Value2>) -> Result<Vec<Value2>> {
        let mut arr = ARRAY.write().unwrap();
        let value = arr.map.get_mut(&self.0).unwrap();

        let func = value
            .instance
            .unwrap()
            .get_func(&value.store, &name)
            .unwrap();
        WasmiModuleId::call_function_handle_with_args(value, func, args)
    }

    pub fn exports(&self) -> SyncReturn<Vec<ModuleExportValue>> {
        let value = &ARRAY.read().unwrap().map[&self.0];
        SyncReturn(
            value
                .instance
                .unwrap()
                .exports(&value.store)
                .map(|e| ModuleExportValue::from_export(e, &value.store))
                .collect(),
        )
    }
}

// #[frb(mirror(Value))]
#[derive(Debug)]
pub enum Value2 {
    /// Value of 32-bit signed or unsigned integer.
    I32(i32),
    /// Value of 64-bit signed or unsigned integer.
    I64(i64),
    /// Value of 32-bit IEEE 754-2008 floating point number.
    F32(f32),
    /// Value of 64-bit IEEE 754-2008 floating point number.
    F64(f64),
    /// A nullable [`Func`][`crate::Func`] reference, a.k.a. [`FuncRef`].
    FuncRef(Option<RustOpaque<Func>>), // NonZeroU32
    /// A nullable external object reference, a.k.a. [`ExternRef`].
    ExternRef(u32), // NonZeroU32
}

impl Value2 {
    fn to_value<T>(&self, ctx: &mut Store<T>) -> Value {
        match self {
            Value2::I32(i) => Value::I32(*i),
            Value2::I64(i) => Value::I64(*i),
            Value2::F32(i) => Value::F32(i.to_bits().into()),
            Value2::F64(i) => Value::F64(i.to_bits().into()),
            Value2::FuncRef(i) => {
                let inner = i.as_ref().map(|f| f.clone().try_unwrap().unwrap());
                Value::FuncRef(FuncRef::new(inner))
            }
            Value2::ExternRef(i) => Value::ExternRef(ExternRef::new::<u32>(ctx, Some(*i))),
        }
    }

    fn from_value<'a, T: 'a>(value: &Value, ctx: impl Into<StoreContext<'a, T>>) -> Self {
        match value {
            Value::I32(i) => Value2::I32(*i),
            Value::I64(i) => Value2::I64(*i),
            Value::F32(i) => Value2::F32(i.to_float()),
            Value::F64(i) => Value2::F64(i.to_float()),
            Value::FuncRef(i) => Value2::FuncRef(i.func().map(|f| RustOpaque::new(*f))), // NonZeroU32::new(1).unwrap()),
            Value::ExternRef(i) => {
                Value2::ExternRef(*(i.data(ctx).unwrap().downcast_ref::<u32>().unwrap()))
            } // NonZeroU32::new(1).unwrap()),
        }
    }
}

#[derive(Debug)]
pub struct GlobalTy {
    /// The value type of the global variable.
    pub content: ValueTy,
    /// The mutability of the global variable.
    pub mutability: Mutability,
}

impl From<&GlobalType> for GlobalTy {
    fn from(value: &GlobalType) -> Self {
        GlobalTy {
            content: (&value.content()).into(),
            mutability: value.mutability(),
        }
    }
}

#[derive(Debug)]
pub struct TableTy {
    /// The type of values stored in the [`Table`].
    pub element: ValueTy,
    /// The minimum number of elements the [`Table`] must have.
    pub min: u32,
    /// The optional maximum number of elements the [`Table`] can have.
    ///
    /// If this is `None` then the [`Table`] is not limited in size.
    pub max: Option<u32>,
}

impl From<&TableType> for TableTy {
    fn from(value: &TableType) -> Self {
        TableTy {
            element: (&value.element()).into(),
            min: value.minimum(),
            max: value.maximum(),
        }
    }
}

#[derive(Debug)]
pub enum ValueTy {
    /// 32-bit signed or unsigned integer.
    I32,
    /// 64-bit signed or unsigned integer.
    I64,
    /// 32-bit IEEE 754-2008 floating point number.
    F32,
    /// 64-bit IEEE 754-2008 floating point number.
    F64,
    /// A nullable function reference.
    FuncRef,
    /// A nullable external reference.
    ExternRef,
}

impl From<&ValueType> for ValueTy {
    fn from(value: &ValueType) -> Self {
        match value {
            ValueType::I32 => ValueTy::I32,
            ValueType::I64 => ValueTy::I64,
            ValueType::F32 => ValueTy::F32,
            ValueType::F64 => ValueTy::F64,
            ValueType::FuncRef => ValueTy::FuncRef,
            ValueType::ExternRef => ValueTy::ExternRef,
        }
    }
}

impl From<ValueTy> for ValueType {
    fn from(value: ValueTy) -> Self {
        match value {
            ValueTy::I32 => ValueType::I32,
            ValueTy::I64 => ValueType::I64,
            ValueTy::F32 => ValueType::F32,
            ValueTy::F64 => ValueType::F64,
            ValueTy::FuncRef => ValueType::FuncRef,
            ValueTy::ExternRef => ValueType::ExternRef,
        }
    }
}

impl WasmiModuleId {
    pub fn instantiate_sync(&self) -> Result<SyncReturn<WasmiInstanceId>> {
        Ok(SyncReturn(self.instantiate()?))
    }
    pub fn instantiate(&self) -> Result<WasmiInstanceId> {
        let mut state = ARRAY.write().unwrap();
        let mut module = state.map.get_mut(&self.0).unwrap();
        if module.instance.is_some() {
            return Err(anyhow::anyhow!("Instance already exists"));
        }
        let instance = module
            .linker
            .instantiate(&mut module.store, &module.module)?
            .start(&mut module.store)?;

        module.instance = Some(instance);
        Ok(WasmiInstanceId(self.0))
    }

    pub fn get_module_imports(&self) -> SyncReturn<Vec<ModuleImportDesc>> {
        SyncReturn(self.with_module(|m| m.module.imports().map(|i| (&i).into()).collect()))
    }

    pub fn get_module_exports(&self) -> SyncReturn<Vec<ModuleExportDesc>> {
        SyncReturn(self.with_module(|m| m.module.exports().map(|i| (&i).into()).collect()))
    }

    pub fn executions(&self, sink: StreamSink<i32>) -> Result<()> {
        let mut arr = ARRAY.write().unwrap();
        let value = &mut arr.map.get_mut(&self.0).unwrap();
        if value.builder.is_some() {
            return Err(anyhow::anyhow!("Stream sink already set"));
        }
        value.builder = Some(WasmiModuleBuilder { sink });
        Ok(())
    }

    pub fn dispose(&self) -> Result<()> {
        let mut arr = ARRAY.write().unwrap();
        arr.map.remove(&self.0);
        Ok(())
    }

    pub fn call_function_handle_sync(
        &self,
        func: RustOpaque<Func>,
        args: Vec<Value2>,
    ) -> Result<SyncReturn<Vec<Value2>>> {
        self.call_function_handle(func, args).map(SyncReturn)
    }
    pub fn call_function_handle(
        &self,
        func: RustOpaque<Func>,
        args: Vec<Value2>,
    ) -> Result<Vec<Value2>> {
        let mut arr = ARRAY.write().unwrap();
        let value = arr.map.get_mut(&self.0).unwrap();
        WasmiModuleId::call_function_handle_with_args(value, *func, args)
    }

    fn call_function_handle_with_args(
        value: &mut WasmiModuleImpl,
        func: Func,
        args: Vec<Value2>,
    ) -> Result<Vec<Value2>> {
        let mut outputs: Vec<Value> = func
            .ty(&value.store)
            .results()
            .iter()
            .map(|t| Value::default(*t))
            .collect();
        let inputs: Vec<Value> = args
            .into_iter()
            .map(|v| v.to_value(&mut value.store))
            .collect();
        func.call(&mut value.store, inputs.as_slice(), &mut outputs)?;
        Ok(outputs
            .into_iter()
            .map(|a| Value2::from_value(&a, &value.store))
            .collect())
    }

    fn with_module_mut<T>(&self, f: impl FnOnce(&mut WasmiModuleImpl) -> T) -> T {
        let mut arr = ARRAY.write().unwrap();
        let value = arr.map.get_mut(&self.0).unwrap();
        f(value)
    }

    fn with_module<T>(&self, f: impl FnOnce(&WasmiModuleImpl) -> T) -> T {
        let arr = ARRAY.read().unwrap();
        let value = &arr.map[&self.0];
        f(value)
    }

    pub fn get_function_type(&self, func: RustOpaque<Func>) -> SyncReturn<FuncTy> {
        SyncReturn(self.with_module(|m| (&func.ty(&m.store)).into()))
    }

    pub fn create_function(
        &self,
        function_pointer: usize,
        function_id: u32,
        param_types: Vec<ValueTy>,
    ) -> Result<SyncReturn<RustOpaque<Func>>> {
        self.with_module_mut(|module| {
            let f: WasmFunction = unsafe { std::mem::transmute(function_pointer) };
            let func = Func::new(
                &mut module.store,
                // TODO: support results
                FuncType::new(param_types.into_iter().map(ValueType::from), []),
                move |caller, params, _results| {
                    let mapped: Vec<Value2> = params
                        .iter()
                        .map(|a| Value2::from_value(a, &caller))
                        .collect();
                    let inputs = vec![mapped].into_dart();
                    let pointer = new_leak_box_ptr(inputs);
                    unsafe {
                        f(function_id, pointer);
                    }
                    std::result::Result::Ok(())
                },
            );
            Ok(SyncReturn(RustOpaque::new(func)))
        })
    }

    pub fn create_memory(
        &self,
        memory_type: WasmMemoryType,
    ) -> Result<SyncReturn<RustOpaque<Memory>>> {
        self.with_module_mut(|module| {
            let mem_type = memory_type.to_memory_type()?;
            let memory = Memory::new(&mut module.store, mem_type).map_err(to_anyhow)?;
            Ok(SyncReturn(RustOpaque::new(memory)))
        })
    }

    pub fn create_global(
        &self,
        value: Value2,
        mutability: Mutability,
    ) -> Result<SyncReturn<RustOpaque<Global>>> {
        self.with_module_mut(|module| {
            let mapped = value.to_value(&mut module.store);
            let global = Global::new(&mut module.store, mapped, mutability);
            Ok(SyncReturn(RustOpaque::new(global)))
        })
    }

    pub fn create_table(
        &self,
        value: Value2,
        table_type: TableType2,
    ) -> Result<SyncReturn<RustOpaque<Table>>> {
        self.with_module_mut(|module| {
            let mapped_value = value.to_value(&mut module.store);
            let table = Table::new(
                &mut module.store,
                TableType::new(mapped_value.ty(), table_type.min, table_type.max),
                mapped_value,
            )
            .map_err(to_anyhow)?;
            Ok(SyncReturn(RustOpaque::new(table)))
        })
    }

    // GLOBAL

    pub fn get_global_type(&self, global: RustOpaque<Global>) -> SyncReturn<GlobalTy> {
        SyncReturn(self.with_module(|m| (&global.ty(&m.store)).into()))
    }

    pub fn get_global_value(&self, global: RustOpaque<Global>) -> SyncReturn<Value2> {
        SyncReturn(self.with_module(|m| Value2::from_value(&global.get(&m.store), &m.store)))
    }

    pub fn set_global_value(
        &self,
        global: RustOpaque<Global>,
        value: Value2,
    ) -> Result<SyncReturn<()>> {
        self.with_module_mut(|m| {
            let mapped = value.to_value(&mut m.store);
            global
                .set(&mut m.store, mapped)
                .map(|_| SyncReturn(()))
                .map_err(to_anyhow)
        })
    }

    // MEMORY

    pub fn get_memory_type(&self, memory: RustOpaque<Memory>) -> SyncReturn<WasmMemoryType> {
        SyncReturn(self.with_module(|m| (&memory.ty(&m.store)).into()))
    }
    pub fn get_memory_data(&self, memory: RustOpaque<Memory>) -> SyncReturn<Vec<u8>> {
        SyncReturn(self.with_module(|m| memory.data(&m.store).to_owned()))
    }
    pub fn read_memory(
        &self,
        memory: RustOpaque<Memory>,
        offset: usize,
        mut buffer: Vec<u8>,
    ) -> Result<SyncReturn<Vec<u8>>> {
        self.with_module(|m| {
            memory
                .read(&m.store, offset, &mut buffer)
                .map(|_| SyncReturn(buffer))
                .map_err(to_anyhow)
        })
    }
    pub fn get_memory_pages(&self, memory: RustOpaque<Memory>) -> SyncReturn<u32> {
        SyncReturn(self.with_module(|m| memory.current_pages(&m.store).into()))
    }

    pub fn write_memory(
        &self,
        memory: RustOpaque<Memory>,
        offset: usize,
        buffer: Vec<u8>,
    ) -> Result<SyncReturn<()>> {
        self.with_module_mut(|m| {
            memory
                .write(&mut m.store, offset, &buffer)
                .map(SyncReturn)
                .map_err(to_anyhow)
        })
    }
    pub fn grow_memory(&self, memory: RustOpaque<Memory>, pages: u32) -> Result<SyncReturn<u32>> {
        self.with_module_mut(|m| {
            memory
                .grow(
                    &mut m.store,
                    Pages::new(pages).ok_or(anyhow::anyhow!("Invalid pages"))?,
                )
                .map(|p| SyncReturn(p.into()))
                .map_err(to_anyhow)
        })
    }

    // TABLE

    pub fn get_table_size(&self, table: RustOpaque<Table>) -> SyncReturn<u32> {
        SyncReturn(self.with_module(|m| table.size(&m.store)))
    }
    pub fn get_table_type(&self, table: RustOpaque<Table>) -> SyncReturn<TableTy> {
        SyncReturn(self.with_module(|m| (&table.ty(&m.store)).into()))
    }

    pub fn grow_table(
        &self,
        table: RustOpaque<Table>,
        delta: u32,
        value: Value2,
    ) -> Result<SyncReturn<u32>> {
        self.with_module_mut(|m| {
            let mapped = value.to_value(&mut m.store);
            table
                .grow(&mut m.store, delta, mapped)
                .map(SyncReturn)
                .map_err(to_anyhow)
        })
    }

    pub fn get_table(&self, table: RustOpaque<Table>, index: u32) -> SyncReturn<Option<Value2>> {
        SyncReturn(self.with_module(|m| {
            table
                .get(&m.store, index)
                .map(|v| Value2::from_value(&v, &m.store))
        }))
    }

    pub fn set_table(
        &self,
        table: RustOpaque<Table>,
        index: u32,
        value: Value2,
    ) -> Result<SyncReturn<()>> {
        self.with_module_mut(|m| {
            let mapped = value.to_value(&mut m.store);
            table
                .set(&mut m.store, index, mapped)
                .map(SyncReturn)
                .map_err(to_anyhow)
        })
    }

    pub fn fill_table(
        &self,
        table: RustOpaque<Table>,
        index: u32,
        value: Value2,
        len: u32,
    ) -> Result<SyncReturn<()>> {
        self.with_module_mut(|m| {
            let mapped = value.to_value(&mut m.store);
            table
                .fill(&mut m.store, index, mapped, len)
                .map(|_| SyncReturn(()))
                .map_err(to_anyhow)
        })
    }

    pub fn link_imports(&self, imports: Vec<ModuleImport>) -> Result<SyncReturn<()>> {
        self.with_module_mut(|m| {
            for import in imports {
                m.linker
                    .define(&import.module, &import.name, import.value.to_extern())?;
            }
            Ok(SyncReturn(()))
        })
    }
}

fn to_anyhow<T: Display>(value: T) -> anyhow::Error {
    anyhow::anyhow!(value.to_string())
}

pub fn parse_wat_format(wat: String) -> Result<Vec<u8>> {
    Ok(wat::parse_str(wat)?)
}

pub struct ModuleImport {
    pub module: String,
    pub name: String,
    pub value: ExternalValue,
}

type ffF = unsafe extern "C" fn(args: i64) -> i64;

pub fn run_function(pointer: usize) -> SyncReturn<Vec<Value2>> {
    let f: ffF = unsafe { std::mem::transmute(pointer) };
    let result = unsafe { f(1) };
    SyncReturn(vec![Value2::I64(result)])
}

// TODO: Support return values
type WasmFunction = unsafe extern "C" fn(function_id: u32, args: *mut DartAbi) -> c_void;

type wasm_func = unsafe extern "C" fn(args: *mut DartAbi) -> *mut wire_list_value_2;
type wasm_func_mut =
    unsafe extern "C" fn(args: *mut DartAbi, output: *mut wire_list_value_2) -> i64;
type wasm_func_void = unsafe extern "C" fn(args: *mut DartAbi) -> c_void;

pub fn run_wasm_func(pointer: usize, params: Vec<Value2>) -> SyncReturn<Vec<Value2>> {
    let f: wasm_func = unsafe { std::mem::transmute(pointer) };

    // let pp = new_list_value_2_0(params.len().try_into().unwrap());
    // pp.write(val);
    // let vv = wire_list_value_2 {
    //     ptr: params.into_iter().map(|v| v.into()).collect(),
    //     len: params.len().try_into().unwrap(),
    // };

    println!("inputs: {:?}", params);
    let inputs = vec![params].into_dart();
    println!("after inputs: {:?}", inputs.ty);
    let pointer = new_leak_box_ptr(inputs);
    println!("pointer: {:?}", pointer);
    // TODO: maybe pass the result as argument to the function
    let result = unsafe { f(pointer) };
    println!("result pointer: {:?}", result);
    let output = result.wire2api();
    println!("output: {:?}", output);
    SyncReturn(output)
    // vec![Value2::Int(result as i64)]
}

pub fn run_wasm_func_mut(pointer: usize, params: Vec<Value2>) -> SyncReturn<Vec<Value2>> {
    let f: wasm_func_mut = unsafe { std::mem::transmute(pointer) };

    println!("inputs: {:?}", params);
    let inputs = vec![params].into_dart();
    println!("after inputs: {:?}", inputs.ty);
    let pointer = new_leak_box_ptr(inputs);
    println!("pointer: {:?}", pointer);

    let out = new_list_value_2_0(1);
    println!("result pointer before: {:?}", out);

    let int_out = unsafe { f(pointer, out) };
    println!("result pointer: {:?} {:?}", out, int_out);
    let output = out.wire2api();
    println!("output: {:?}", output);
    SyncReturn(output)
}

pub fn run_wasm_func_void(pointer: usize, params: Vec<Value2>) -> SyncReturn<bool> {
    let f: wasm_func_void = unsafe { std::mem::transmute(pointer) };
    println!("inputs: {:?}", params);
    let inputs = vec![params].into_dart();
    println!("after inputs: {:?}", inputs.ty);
    let pointer = new_leak_box_ptr(inputs);
    println!("pointer: {:?}", pointer);
    let result = unsafe { f(pointer) };
    SyncReturn(true)
}

#[derive(Debug)]
pub struct WasmMemoryType {
    pub initial_pages: u32,
    pub maximum_pages: Option<u32>,
}

impl WasmMemoryType {
    fn to_memory_type(&self) -> Result<MemoryType> {
        MemoryType::new(self.initial_pages, self.maximum_pages).map_err(to_anyhow)
    }
}

impl From<&MemoryType> for WasmMemoryType {
    fn from(memory_type: &MemoryType) -> Self {
        WasmMemoryType {
            initial_pages: memory_type.initial_pages().into(),
            maximum_pages: memory_type.maximum_pages().map(|v| v.into()),
        }
    }
}

#[frb(mirror(Mutability))]
pub enum _Mutability {
    /// The value of the global variable is a constant.
    Const,
    /// The value of the global variable is mutable.
    Var,
}

// #[derive(Debug)]
// pub enum ExternalValue {
//     // TODO: no support for empty enums
//     Func {
//         pointer: usize,
//     },
//     Global {
//         value: Value2,
//         mutability: Mutability,
//     },
//     Table {
//         value: Value2,
//         ty: TableType2,
//     },
//     Memory {
//         ty: WasmMemoryType,
//     },
// }

#[derive(Debug)]
pub enum ExternalType {
    Func(FuncTy),
    Global(GlobalTy),
    Table(TableTy),
    Memory(WasmMemoryType),
}

impl From<&ExternType> for ExternalType {
    fn from(import: &ExternType) -> Self {
        match import {
            ExternType::Func(f) => ExternalType::Func(f.into()),
            ExternType::Global(f) => ExternalType::Global(f.into()),
            ExternType::Table(f) => ExternalType::Table(f.into()),
            ExternType::Memory(f) => ExternalType::Memory(f.into()),
        }
    }
}

#[derive(Debug)]
pub struct ModuleImportDesc {
    pub module: String,
    pub name: String,
    pub ty: ExternalType,
}

impl From<&ImportType<'_>> for ModuleImportDesc {
    fn from(import: &ImportType) -> Self {
        ModuleImportDesc {
            module: import.module().to_string(),
            name: import.name().to_string(),
            ty: import.ty().into(),
        }
    }
}

#[derive(Debug)]
pub struct FuncTy {
    /// The number of function parameters.
    pub params: Vec<ValueTy>,
    /// The ordered and merged parameter and result types of the function type.]
    pub results: Vec<ValueTy>,
}

impl From<&FuncType> for FuncTy {
    fn from(func: &FuncType) -> Self {
        FuncTy {
            params: func.params().iter().map(ValueTy::from).collect(),
            results: func.results().iter().map(ValueTy::from).collect(),
        }
    }
}

#[derive(Debug)]
pub struct ModuleExportDesc {
    pub name: String,
    pub ty: ExternalType,
}

impl From<&ExportType<'_>> for ModuleExportDesc {
    fn from(export: &ExportType) -> Self {
        ModuleExportDesc {
            name: export.name().to_string(),
            ty: export.ty().into(),
        }
    }
}

#[derive(Debug)]
pub struct ModuleExportValue {
    pub desc: ModuleExportDesc,
    pub value: ExternalValue,
}

impl ModuleExportValue {
    fn from_export<T>(export: Export, store: &Store<T>) -> Self {
        ModuleExportValue {
            desc: ModuleExportDesc {
                name: export.name().to_string(),
                ty: (&export.ty(store)).into(),
            },
            value: export.into_extern().into(),
        }
    }
}

#[derive(Debug)]
pub enum ExternalValue {
    Func(RustOpaque<Func>),
    Global(RustOpaque<Global>),
    Table(RustOpaque<Table>),
    Memory(RustOpaque<Memory>),
}

// impl Default for ExternalValue {
//     fn default() -> Self {
//         ExternalValue::Global {
//             value: Value2::I32(0),
//             mutability: Mutability::Const,
//         }
//     }
// }

impl Default for wire_ExternalValue {
    fn default() -> Self {
        wire_ExternalValue::new_with_null_ptr()
    }
}

impl From<Extern> for ExternalValue {
    fn from(extern_: Extern) -> Self {
        match extern_ {
            Extern::Func(f) => ExternalValue::Func(RustOpaque::new(f)),
            Extern::Global(g) => ExternalValue::Global(RustOpaque::new(g)),
            Extern::Table(t) => ExternalValue::Table(RustOpaque::new(t)),
            Extern::Memory(m) => ExternalValue::Memory(RustOpaque::new(m)),
        }
    }
}

impl ExternalValue {
    fn to_extern(&self) -> Extern {
        match self {
            ExternalValue::Func(f) => Extern::Func(**f),
            ExternalValue::Global(g) => Extern::Global(**g),
            ExternalValue::Table(t) => Extern::Table(**t),
            ExternalValue::Memory(m) => Extern::Memory(**m),
        }
    }
    // fn to_extern<T>(&self, store: &mut Store<T>) -> Result<Extern> {
    //     match self {
    //         ExternalValue::Global { value, mutability } => {
    //             let mapped = value.to_value(store);
    //             let global = Global::new(store, mapped, *mutability);
    //             Ok(Extern::Global(global))
    //         }
    //         ExternalValue::Table { value, ty } => {
    //             let mapped_value = value.to_value(store);
    //             let table = Table::new(
    //                 store,
    //                 TableType::new(mapped_value.ty(), ty.min, ty.max),
    //                 mapped_value,
    //             )
    //             .map_err(to_anyhow)?;
    //             Ok(Extern::Table(table))
    //         }
    //         ExternalValue::Memory { ty } => {
    //             let memory = Memory::new(store, ty.to_memory_type()?).map_err(to_anyhow)?;
    //             Ok(Extern::Memory(memory))
    //         }
    //         ExternalValue::Func { pointer } => {
    //             let f: wasm_func = unsafe { std::mem::transmute(*pointer) };
    //             // TODO: let func = Func::wrap(store, f);
    //             let func = Func::wrap(store, || {});
    //             Ok(Extern::Func(func))
    //         }
    //     }
    // }
}

#[derive(Debug)]
pub struct TableType2 {
    /// The minimum number of elements the [`Table`] must have.
    pub min: u32,
    /// The optional maximum number of elements the [`Table`] can have.
    ///
    /// If this is `None` then the [`Table`] is not limited in size.
    pub max: Option<u32>,
}

pub fn compile_wasm_sync(module_wasm: Vec<u8>) -> Result<SyncReturn<WasmiModuleId>> {
    compile_wasm(module_wasm).map(SyncReturn)
}

pub fn compile_wasm(module_wasm: Vec<u8>) -> Result<WasmiModuleId> {
    let engine = Engine::default();
    let module = Module::new(&engine, &mut &module_wasm[..])?;
    let linker = <Linker<HostState>>::new(&engine);

    type HostState = u32;

    let mut arr = ARRAY.write().unwrap();
    arr.last_id += 1;
    let id = arr.last_id;
    let store = Store::new(&engine, id);
    let inner = WasmiModuleImpl {
        module,
        store,
        builder: None,
        linker,
        instance: None,
    };
    arr.map.insert(id, inner);

    Ok(WasmiModuleId(id))
}

pub fn call_wasm() -> Result<()> {
    // First step is to create the Wasm execution engine with some config.
    // In this example we are using the default configuration.
    let engine = Engine::default();
    let wat = r#"
        (module
            (import "host" "hello" (func $host_hello (param i32)))
            (func (export "hello")
                (call $host_hello (i32.const 3))
            )
        )
    "#;
    // Wasmi does not yet support parsing `.wat` so we have to convert
    // out `.wat` into `.wasm` before we compile and validate it.
    let wasm = wat::parse_str(wat)?;
    let module = Module::new(&engine, &mut &wasm[..])?;

    // All Wasm objects operate within the context of a `Store`.
    // Each `Store` has a type parameter to store host-specific data,
    // which in this case we are using `42` for.
    type HostState = u32;
    let mut store = Store::new(&engine, 42);
    let host_hello = Func::wrap(&mut store, |caller: Caller<'_, HostState>, param: i32| {
        println!("Got {param} from WebAssembly");
        println!("My host state is: {}", caller.data());
    });

    // In order to create Wasm module instances and link their imports
    // and exports we require a `Linker`.
    let mut linker = <Linker<HostState>>::new(&engine);
    // Instantiation of a Wasm module requires defining its imports and then
    // afterwards we can fetch exports by name, as well as asserting the
    // type signature of the function with `get_typed_func`.
    //
    // Also before using an instance created this way we need to start it.
    linker.define("host", "hello", host_hello)?;
    let instance = linker.instantiate(&mut store, &module)?.start(&mut store)?;
    let hello = instance.get_typed_func::<(), ()>(&store, "hello")?;

    // And finally we can call the wasm!
    hello.call(&mut store, ())?;

    Ok(())
}

pub fn add(a: i64, b: i64) -> i64 {
    a + b
}
