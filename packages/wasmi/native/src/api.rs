use crate::bridge_generated::{
    new_list_value_2_0, wire_ExternalValue, wire_list_value_2, NewWithNullPtr, Wire2Api,
};
use anyhow::{Ok, Result};
use flutter_rust_bridge::{
    frb, opaque_dyn, support::new_leak_box_ptr, DartAbi, DartSafe, IntoDart, RustOpaque,
    StreamSink, SyncReturn,
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
pub use wasmi::{core::Pages, Func, Global, Memory, Mutability, Table};
use wasmi::{errors::MemoryError, *};

// TODO: use Map
static ARRAY: Lazy<RwLock<GlobalState>> = Lazy::new(|| RwLock::new(Default::default()));

#[derive(Debug, Default)]
struct GlobalState {
    map: HashMap<u32, WasmiModuleImpl>,
    instances: HashMap<u32, Instance>,
    last_id: u32,
}

#[derive(Debug)]
struct WasmiModuleImpl {
    module: Module,
    instance: Instance,
    linker: Linker<u32>,
    store: Store<u32>,
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
    FuncRef(u32), // NonZeroU32
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
            Value2::FuncRef(i) => Value::FuncRef(
                Func::wrap(ctx, |caller: Caller<'_, T>, param: i32| {
                    // println!("Got {param} from WebAssembly");
                    // println!("My host state is: {}", caller.data());
                })
                .into(),
            ),
            Value2::ExternRef(i) => Value::ExternRef(ExternRef::null()),
        }
    }

    fn from_value(value: &Value) -> Self {
        match value {
            Value::I32(i) => Value2::I32(*i),
            Value::I64(i) => Value2::I64(*i),
            Value::F32(i) => Value2::F32(i.to_float()),
            Value::F64(i) => Value2::F64(i.to_float()),
            Value::FuncRef(i) => Value2::FuncRef(0), // NonZeroU32::new(1).unwrap()),
            Value::ExternRef(i) => Value2::ExternRef(0), // NonZeroU32::new(1).unwrap()),
        }
    }
}

impl From<Value> for Value2 {
    fn from(value: Value) -> Self {
        Value2::from_value(&value)
    }
}

// #[frb(mirror(FuncRef))]
// pub struct _FuncRef {
//     inner: Option<Func>,
// }

// #[frb(mirror(F32))]
// struct _F32(f32); // u32 as

// #[frb(mirror(F32))]
// struct _F32(f32); // u32 as

// #[frb(mirror(F64))]
// struct _F64(f64); // u64 as

pub trait WasmiModule {
    fn call_function(&mut self, name: String) -> Result<Vec<Value2>>;
    fn call_function_with_args(&mut self, name: String, args: Vec<Value2>) -> Result<Vec<Value2>>;
    fn get_exports(&self) -> Vec<String>;
    fn get_module_exports(&self) -> Vec<String>;
}

impl WasmiModuleId {
    pub fn instantiate(&self) -> Result<WasmiInstanceId> {
        let mut state = ARRAY.write().unwrap();
        if state.instances.contains_key(&self.0) {
            return Err(anyhow::anyhow!("Instance already exists"));
        }
        let module = state.map.get_mut(&self.0).unwrap();
        let instance = module
            .linker
            .instantiate(&mut module.store, &module.module)?
            .start(&mut module.store)?;

        state.instances.insert(self.0, instance);
        Ok(WasmiInstanceId(self.0))
    }

    pub fn call_function(&self, name: String) -> Result<Vec<Value2>> {
        ARRAY
            .write()
            .unwrap()
            .map
            .get_mut(&self.0)
            .unwrap()
            .call_function(name)
    }
    pub fn call_function_with_args(&self, name: String, args: Vec<Value2>) -> Result<Vec<Value2>> {
        ARRAY
            .write()
            .unwrap()
            .map
            .get_mut(&self.0)
            .unwrap()
            .call_function_with_args(name, args)
    }
    pub fn get_exports(&self) -> Vec<String> {
        ARRAY.read().unwrap().map[&self.0].get_exports()
    }
    pub fn get_module_exports(&self) -> Vec<String> {
        ARRAY.read().unwrap().map[&self.0].get_module_exports()
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

    pub fn call_function_with_args_sync(
        &self,
        name: String,
        args: Vec<Value2>,
    ) -> Result<SyncReturn<Vec<Value2>>> {
        let mut arr = ARRAY.write().unwrap();
        let value = &mut arr.map.get_mut(&self.0).unwrap();

        let func = value.instance.get_func(&value.store, &name).unwrap();
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
        Ok(SyncReturn(outputs.into_iter().map(|a| a.into()).collect()))
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

    // GLOBAL

    pub fn get_global_value(&self, global: RustOpaque<Global>) -> SyncReturn<Value2> {
        SyncReturn(self.with_module(|m| global.get(&m.store).into()))
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
    // TODO: type

    // MEMORY

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
        SyncReturn(self.with_module(|m| table.get(&m.store, index).map(|v| v.into())))
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

    pub fn link_imports(&self, imports: Vec<ModuleImport>) -> Result<()> {
        self.with_module_mut(|m| {
            for import in imports {
                m.linker
                    .define(&import.module, &import.name, import.value.to_extern())?;
            }
            Ok(())
        })
    }

    // TODO: ty
}

fn to_anyhow<T: Display>(value: T) -> anyhow::Error {
    anyhow::anyhow!(value.to_string())
}

// pub fn call_function(self:  &mutRustOpaque<Box<dyn WasmiModule>>, name: String) -> Result<Vec<Value2>> {
//     self.call_function(name)
// }
// pub fn call_function_with_args(
//     self: &mut RustOpaque<Box<dyn WasmiModule>>,
//     name: String,
//     args: Vec<Value2>,
// ) -> Result<Vec<Value2>> {
//     self.call_function_with_args(name, args)
// }
// pub fn get_exports(d: RustOpaque<Box<dyn WasmiModule>>) -> Vec<String> {
//     d.get_exports()
// }
// pub fn get_module_exports(d: RustOpaque<Box<dyn WasmiModule>>) -> Vec<String> {
//     d.get_module_exports()
// }

impl WasmiModule for WasmiModuleImpl {
    fn call_function(&mut self, name: String) -> Result<Vec<Value2>> {
        let func = self.instance.get_func(&self.store, &name).unwrap();
        let mut outputs: Vec<Value> = vec![];
        func.call(&mut self.store, &[], &mut outputs)?;
        Ok(outputs.into_iter().map(|a| a.into()).collect())
    }

    fn call_function_with_args(&mut self, name: String, args: Vec<Value2>) -> Result<Vec<Value2>> {
        let func = self.instance.get_func(&self.store, &name).unwrap();
        let mut outputs: Vec<Value> = func
            .ty(&self.store)
            .results()
            .iter()
            .map(|t| Value::default(*t))
            .collect();
        let inputs: Vec<Value> = args
            .into_iter()
            .map(|v| v.to_value(&mut self.store))
            .collect();
        func.call(&mut self.store, inputs.as_slice(), &mut outputs)?;
        Ok(outputs.into_iter().map(|a| a.into()).collect())
    }

    // fn executions(&mut self, sink: StreamSink<int64>) -> Result<()> {
    //     if self.stream_sink.is_some() {
    //         return Err(anyhow::anyhow!("Stream sink already set"));
    //     }
    //     self.stream_sink = Some(sink);
    //     Ok(())
    // }

    fn get_exports(&self) -> Vec<String> {
        // self.module.exports();
        let exports = self.instance.exports(&self.store);
        let mut names = vec![];
        for export in exports {
            names.push(export.name().to_string());
        }
        names
    }

    fn get_module_exports(&self) -> Vec<String> {
        let exports = self.module.exports();
        let mut names = vec![];
        for export in exports {
            let value = format!("{} {:?}", export.name(), export.ty());
            names.push(value);
        }
        names
    }
}

pub fn parse_wat_format(wat: String) -> Result<Vec<u8>> {
    Ok(wat::parse_str(wat)?)
}

// pub fn executions(sink: StreamSink<i32>) -> RustOpaque<WasmiModuleBuilder> {
//     RustOpaque::new(WasmiModuleBuilder { stream_sink: sink })
// }

// #[frb(mirror(Extern))]
// pub enum _Extern {
//     /// A WebAssembly global which acts like a [`Cell<T>`] of sorts, supporting `get` and `set` operations.
//     ///
//     /// [`Cell<T>`]: https://doc.rust-lang.org/core/cell/struct.Cell.html
//     Global(Global),
//     /// A WebAssembly table which is an array of funtion references.
//     Table(Table),
//     /// A WebAssembly linear memory.
//     Memory(Memory),
//     /// A WebAssembly function which can be called.
//     Func(Func),
// }

pub struct ModuleImport {
    pub module: String,
    pub name: String,
    pub value: ExternalValue,
}

type ffF = unsafe extern "C" fn(args: i64) -> i64;

pub fn run_function(pointer: i64) -> SyncReturn<Vec<Value2>> {
    let f: ffF = unsafe { std::mem::transmute(pointer) };
    let result = unsafe { f(1) };
    SyncReturn(vec![Value2::I64(result)])
}

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

pub fn create_memory(memory_type: WasmMemoryType) -> Result<RustOpaque<Memory>> {
    let engine = Engine::default();
    let index = 1;
    let mut store = Store::new(&engine, index);
    let mem_type = memory_type.to_memory_type()?;
    let memory = Memory::new(&mut store, mem_type).map_err(to_anyhow)?;
    Ok(RustOpaque::new(memory))
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

pub fn create_global(value: Value2, mutability: Mutability) -> Result<RustOpaque<Global>> {
    let engine = Engine::default();
    let index = 1;
    let mut store = Store::new(&engine, index);
    let mapped = value.to_value(&mut store);
    let global = Global::new(&mut store, mapped, mutability);
    Ok(RustOpaque::new(global))
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

pub fn create_table(value: Value2, table_type: TableType2) -> Result<RustOpaque<Table>> {
    let engine = Engine::default();
    let index = 1;
    let mut store = Store::new(&engine, index);
    let mapped_value = value.to_value(&mut store);
    let table = Table::new(
        &mut store,
        TableType::new(mapped_value.ty(), table_type.min, table_type.max),
        mapped_value,
    )
    .map_err(|err| anyhow::anyhow!(err.to_string()))?;
    Ok(RustOpaque::new(table))
}

pub fn compile_wasm(
    module_wasm: Vec<u8>,
    imports: Vec<ModuleImport>,
    // sink: StreamSink<i32>
    // builder: WasmiModuleBuilder, // sink: StreamSink<int64>,
    // definitions: Map<Map<String, int64>>,
) -> Result<WasmiModuleId> {
    let engine = Engine::default();
    let module = Module::new(&engine, &mut &module_wasm[..])?;
    let mut linker = <Linker<HostState>>::new(&engine);

    // module.imports().for_each(|import| {
    //     import.ty();
    //     println!("Import: {:?}", import);
    // });
    // linker.define(module, name, item);

    type HostState = u32;
    let mut store = Store::new(&engine, 42);
    // let host_hello = Func::wrap(&mut store, |caller: Caller<'_, HostState>, param: i32| {
    //     println!("Got {param} from WebAssembly");
    //     println!("My host state is: {}", caller.data());
    // });

    // for import in imports {
    //     linker.define(
    //         &import.module,
    //         &import.name,
    //         import.value.to_extern(&mut store)?,
    //     )?;
    // }
    // linker.define("host", "hello", host_hello)?;
    let instance = linker.instantiate(&mut store, &module)?.start(&mut store)?;
    let inner = WasmiModuleImpl {
        instance,
        module,
        store,
        builder: None,
        linker,
    };
    let mut arr = ARRAY.write().unwrap();
    arr.last_id += 1;
    let id = arr.last_id;
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
