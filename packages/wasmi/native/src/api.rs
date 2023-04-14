use crate::bridge_generated::{
    new_list_value_2_0, wire_ExternalValue, wire_list_value_2, NewWithNullPtr, Wire2Api,
};
use crate::types::*;
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
            .instantiate(&mut module.store, &module.module.lock().unwrap())?
            .start(&mut module.store)?;

        module.instance = Some(instance);
        Ok(WasmiInstanceId(self.0))
    }
    pub fn link_imports(&self, imports: Vec<ModuleImport>) -> Result<SyncReturn<()>> {
        self.with_module_mut(|m| {
            for import in imports {
                m.linker
                    .define(&import.module, &import.name, &import.value)?;
            }
            Ok(SyncReturn(()))
        })
    }

    // pub fn executions(&self, sink: StreamSink<i32>) -> Result<()> {
    //     let mut arr = ARRAY.write().unwrap();
    //     let value = &mut arr.map.get_mut(&self.0).unwrap();
    //     if value.builder.is_some() {
    //         return Err(anyhow::anyhow!("Stream sink already set"));
    //     }
    //     value.builder = Some(WasmiModuleBuilder { sink });
    //     Ok(())
    // }

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
}

pub fn parse_wat_format(wat: String) -> Result<Vec<u8>> {
    Ok(wat::parse_str(wat)?)
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

pub struct CompiledModule(pub RustOpaque<Arc<std::sync::Mutex<Module>>>);

impl CompiledModule {
    pub fn get_module_imports(&self) -> SyncReturn<Vec<ModuleImportDesc>> {
        SyncReturn(
            self.0
                .lock()
                .unwrap()
                .imports()
                .map(|i| (&i).into())
                .collect(),
        )
    }

    pub fn get_module_exports(&self) -> SyncReturn<Vec<ModuleExportDesc>> {
        SyncReturn(
            self.0
                .lock()
                .unwrap()
                .exports()
                .map(|i| (&i).into())
                .collect(),
        )
    }
}

impl From<Module> for CompiledModule {
    fn from(module: Module) -> Self {
        CompiledModule(RustOpaque::new(Arc::new(std::sync::Mutex::new(module))))
    }
}

pub fn compile_wasm(module_wasm: Vec<u8>, config: ModuleConfig) -> Result<CompiledModule> {
    let config: Config = config.into();
    let engine = Engine::new(&config);
    let module = Module::new(&engine, &mut &module_wasm[..])?;
    Ok(module.into())
}

pub fn compile_wasm_sync(
    module_wasm: Vec<u8>,
    config: ModuleConfig,
) -> Result<SyncReturn<CompiledModule>> {
    compile_wasm(module_wasm, config).map(SyncReturn)
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
