use crate::bridge_generated::{new_list_value_2_0, wire_list_value_2, Wire2Api};
use crate::config::*;
use crate::types::*;
use anyhow::{Ok, Result};
use flutter_rust_bridge::{
    support::new_leak_box_ptr, DartAbi, IntoDart, RustOpaque, StreamSink, SyncReturn,
};
use once_cell::sync::Lazy;
use std::io::Write;
use std::{
    collections::HashMap,
    ffi::c_void,
    fs,
    sync::{Arc, RwLock},
};
use wasi_common::{file::FileCaps, pipe::WritePipe};
use wasmi::core::Trap;
pub use wasmi::{core::Pages, Func, Global, GlobalType, Memory, Module, Mutability, Table};
use wasmi::{core::ValueType, *};

static ARRAY: Lazy<RwLock<GlobalState>> = Lazy::new(|| RwLock::new(Default::default()));
// TODO: make it module independent
static CALLER_STACK: Lazy<RwLock<Vec<RwLock<Caller<StoreState>>>>> =
    Lazy::new(|| RwLock::new(Default::default()));

#[derive(Default)]
struct GlobalState {
    map: HashMap<u32, WasmiModuleImpl>,
    last_id: u32,
}

struct WasmiModuleImpl {
    module: Arc<std::sync::Mutex<Module>>,
    linker: Linker<StoreState>,
    store: Store<StoreState>,
    instance: Option<Instance>,
    stdout: Option<StreamSink<Vec<u8>>>,
    stderr: Option<StreamSink<Vec<u8>>>,
}

// impl Debug for WasmiModuleImpl {
//     fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
//         f.debug_struct("WasmiModuleImpl").finish()
//     }
// }

struct StoreState {
    wasi_ctx: Option<wasmi_wasi::WasiCtx>,
}

#[derive(Debug, Clone, Copy)]
pub struct WasmiModuleId(pub u32);

#[derive(Debug, Clone, Copy)]
pub struct WasmiInstanceId(pub u32);

pub fn create_shared_memory(_module: CompiledModule) -> Result<SyncReturn<RustOpaque<Memory>>> {
    Err(anyhow::Error::msg(
        "shared_memory is not supported for wasmi",
    ))
}

pub fn module_builder(
    module: CompiledModule,
    wasi_config: Option<WasiConfig>,
) -> Result<SyncReturn<WasmiModuleId>> {
    let guard = module.0.lock().unwrap();
    let engine = guard.engine();
    let mut linker = <Linker<StoreState>>::new(engine);

    let mut arr = ARRAY.write().unwrap();
    arr.last_id += 1;

    let id = arr.last_id;
    let mut wasi_ctx = None;
    if let Some(wasi_config) = wasi_config {
        wasmi_wasi::add_to_linker(&mut linker, |ctx| ctx.wasi_ctx.as_mut().unwrap())?;

        // add wasi to linker
        let mut wasi_builder = wasmi_wasi::WasiCtxBuilder::new();
        if wasi_config.inherit_args {
            wasi_builder = wasi_builder.inherit_args()?;
        }
        if wasi_config.inherit_env {
            wasi_builder = wasi_builder.inherit_env()?;
        }
        if wasi_config.inherit_stdin {
            wasi_builder = wasi_builder.inherit_stdin();
        }
        if !wasi_config.capture_stdout {
            wasi_builder = wasi_builder.inherit_stdout();
        }
        if !wasi_config.capture_stderr {
            wasi_builder = wasi_builder.inherit_stderr();
        }
        if !wasi_config.args.is_empty() {
            for value in wasi_config.args {
                wasi_builder = wasi_builder.arg(&value)?;
            }
        }
        if !wasi_config.env.is_empty() {
            for EnvVariable { name, value } in wasi_config.env {
                wasi_builder = wasi_builder.env(&name, &value)?;
            }
        }
        if !wasi_config.preopened_dirs.is_empty() {
            for PreopenedDir {
                wasm_guest_path,
                host_path,
            } in wasi_config.preopened_dirs
            {
                let dir =
                    wasmi_wasi::Dir::open_ambient_dir(host_path, wasmi_wasi::ambient_authority())?;
                wasi_builder = wasi_builder.preopened_dir(dir, wasm_guest_path)?;
            }
        }

        let mut wasi = wasi_builder.build();

        if !wasi_config.preopened_files.is_empty() {
            for value in wasi_config.preopened_files {
                let file = fs::File::open(value)?;
                // let vv = file.as_fd().as_raw_fd();
                let wasm_file =
                    wasmi_wasi::file::File::from_cap_std(cap_std::fs::File::from_std(file));
                let caps = FileCaps::all();
                // let mut caps = FileCaps::empty();
                // caps.extend([
                //     FileCaps::READ,
                //     FileCaps::FILESTAT_SET_SIZE,
                //     FileCaps::FILESTAT_GET,
                // ]);

                // vv.try_into().unwrap()
                let table_size = wasi.table().push(Box::new(false)).unwrap();
                // TODO: not sure if this is correct
                wasi.insert_file(table_size, Box::new(wasm_file), caps);
            }
        }

        // let std_dir = fs::File::open("test.txt").unwrap();
        // let fd = std_dir.as_fd().as_raw_fd();
        // let directory = wasmi_wasi::sync::Dir::from_std_file(std_dir);
        // wasi.insert_dir(fd, directory, directory, caps, file_caps);

        // wasmi_wasi::sync::Dir::open_ambient_dir(path, wasmi_wasi::sync::ambient_authority());
        // wasmi_wasi::sync::Dir::reopen_dir(dir);

        // use std::io::{self, BufRead, Read};

        if wasi_config.capture_stdout {
            let stdout_handler = ModuleIOWriter {
                id,
                is_stdout: true,
            };
            wasi.set_stdout(Box::new(WritePipe::new(stdout_handler)));
        }
        if wasi_config.capture_stderr {
            let stderr_handler = ModuleIOWriter {
                id,
                is_stdout: false,
            };
            wasi.set_stderr(Box::new(WritePipe::new(stderr_handler)));
        }
        wasi_ctx = Some(wasi);
    }

    // if wasi_config.capture_stdout {
    //     let mut stdout = io::sink();
    //     let v = wasi_common::pipe::WritePipe::new_in_memory();
    //     let mut stdout_reader = io::BufReader::new(v);
    //     let stdout_lines = stdout_reader.lines();
    //     v.sync();

    //     // Define a closure that will be called whenever new data is available on the stdout stream.

    //     wasi.set_stdout(Box::new(wasi_common::pipe::WritePipe::new(stdout_handler)));

    //     // s.set_stdin(Box::new(crate::pipe::ReadPipe::new(std::io::empty())));

    //     // s.set_stderr(Box::new(crate::pipe::WritePipe::new(std::io::sink())));
    //     // wasi.set_stdout(stdout);
    //     spawn(move || {
    //         for line in stdout_lines {
    //             let oo = v.try_into_inner().unwrap();
    //             println!("line: {:?}", line);
    //             if let Some(sink) = builder.stdout {
    //                 sink.add(value)
    //             }
    //         }
    //     });
    // }

    let store = Store::new(engine, StoreState { wasi_ctx });
    let module_builder = WasmiModuleImpl {
        module: Arc::clone(&module.0),
        linker,
        store,
        stdout: None,
        stderr: None,
        instance: None,
    };
    arr.map.insert(id, module_builder);

    Ok(SyncReturn(WasmiModuleId(id)))
}

// TODO: save it in the store state so we can access it later with caller
struct ModuleIOWriter {
    id: u32,
    is_stdout: bool,
}

impl Write for ModuleIOWriter {
    fn write(&mut self, buf: &[u8]) -> std::io::Result<usize> {
        let arr = ARRAY.read().unwrap();

        let sink = if self.is_stdout {
            arr.map[&self.id].stdout.as_ref()
        } else {
            arr.map[&self.id].stderr.as_ref()
        };
        let mut bytes_written = 0;
        if let Some(stream) = sink {
            if stream.add(buf.to_owned()) {
                bytes_written = buf.len();
            }
        }
        std::io::Result::Ok(bytes_written)
    }

    fn flush(&mut self) -> std::io::Result<()> {
        std::io::Result::Ok(())
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
        let mut arr = ARRAY.write().unwrap();
        let m = arr.map.get_mut(&self.0).unwrap();
        for import in imports {
            m.linker
                .define(&import.module, &import.name, &import.value)?;
        }
        Ok(SyncReturn(()))
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

    fn with_module_mut<T>(&self, f: impl FnOnce(StoreContextMut<'_, StoreState>) -> T) -> T {
        {
            let stack = CALLER_STACK.read().unwrap();
            if let Some(caller) = stack.last() {
                return f(caller.write().unwrap().as_context_mut());
            }
        }
        let mut arr = ARRAY.write().unwrap();
        let value = arr.map.get_mut(&self.0).unwrap();
        f(value.store.as_context_mut())
    }

    fn with_module<T>(&self, f: impl FnOnce(&StoreContext<'_, StoreState>) -> T) -> T {
        {
            let stack = CALLER_STACK.read().unwrap();
            if let Some(caller) = stack.last() {
                return f(&caller.read().unwrap().as_context());
            }
        }
        let arr = ARRAY.read().unwrap();
        let value = &arr.map[&self.0];
        f(&value.store.as_context())
    }

    pub fn get_function_type(&self, func: RustOpaque<Func>) -> SyncReturn<FuncTy> {
        SyncReturn(self.with_module(|store| (&func.ty(store)).into()))
    }

    pub fn create_function(
        &self,
        function_pointer: usize,
        function_id: u32,
        param_types: Vec<ValueTy>,
        result_types: Vec<ValueTy>,
    ) -> Result<SyncReturn<RustOpaque<Func>>> {
        self.with_module_mut(|store| {
            let f: WasmFunction = unsafe { std::mem::transmute(function_pointer) };
            let func = Func::new(
                store,
                FuncType::new(
                    param_types.into_iter().map(ValueType::from),
                    result_types.into_iter().map(ValueType::from),
                ),
                move |caller, params, results| {
                    let mapped: Vec<Value2> = params
                        .iter()
                        .map(|a| Value2::from_value(a, &caller))
                        .collect();
                    let inputs = vec![mapped].into_dart();
                    {
                        let v = RwLock::new(unsafe { std::mem::transmute(caller) });
                        CALLER_STACK.write().unwrap().push(v);
                    }
                    let output: Vec<Value2> = unsafe {
                        let pointer = new_leak_box_ptr(inputs);
                        let result = f(function_id, pointer);
                        pointer.drop_in_place();
                        result.wire2api()
                    };
                    let last_caller = CALLER_STACK.write().unwrap().pop();

                    if output.len() != results.len() {
                        return std::result::Result::Err(Trap::new("Invalid output length"));
                    } else if last_caller.is_none() {
                        return std::result::Result::Err(Trap::new("CALLER_STACK is empty"));
                    } else if output.is_empty() {
                        return std::result::Result::Ok(());
                    }
                    let last_caller = last_caller.unwrap();
                    let mut caller = last_caller.write().unwrap();
                    let mut outputs = output.into_iter();
                    for value in results {
                        *value = outputs.next().unwrap().to_value(caller.as_context_mut());
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
        self.with_module_mut(|store| {
            let mem_type = memory_type.to_memory_type()?;
            let memory = Memory::new(store, mem_type).map_err(to_anyhow)?;
            Ok(SyncReturn(RustOpaque::new(memory)))
        })
    }

    pub fn create_global(
        &self,
        value: Value2,
        mutability: Mutability,
    ) -> Result<SyncReturn<RustOpaque<Global>>> {
        self.with_module_mut(|mut store| {
            let mapped = value.to_value(&mut store);
            let global = Global::new(&mut store, mapped, mutability);
            Ok(SyncReturn(RustOpaque::new(global)))
        })
    }

    pub fn create_table(
        &self,
        value: Value2,
        table_type: TableType2,
    ) -> Result<SyncReturn<RustOpaque<Table>>> {
        self.with_module_mut(|mut store| {
            let mapped_value = value.to_value(&mut store);
            let table = Table::new(
                &mut store,
                TableType::new(mapped_value.ty(), table_type.min, table_type.max),
                mapped_value,
            )
            .map_err(to_anyhow)?;
            Ok(SyncReturn(RustOpaque::new(table)))
        })
    }

    // GLOBAL

    pub fn get_global_type(&self, global: RustOpaque<Global>) -> SyncReturn<GlobalTy> {
        SyncReturn(self.with_module(|store| (&global.ty(store)).into()))
    }

    pub fn get_global_value(&self, global: RustOpaque<Global>) -> SyncReturn<Value2> {
        SyncReturn(self.with_module(|store| Value2::from_value(&global.get(store), store)))
    }

    pub fn set_global_value(
        &self,
        global: RustOpaque<Global>,
        value: Value2,
    ) -> Result<SyncReturn<()>> {
        self.with_module_mut(|mut store| {
            let mapped = value.to_value(&mut store);
            global
                .set(&mut store, mapped)
                .map(|_| SyncReturn(()))
                .map_err(to_anyhow)
        })
    }

    // MEMORY

    pub fn get_memory_type(&self, memory: RustOpaque<Memory>) -> SyncReturn<WasmMemoryType> {
        SyncReturn(self.with_module(|store| (&memory.ty(store)).into()))
    }
    pub fn get_memory_data(&self, memory: RustOpaque<Memory>) -> SyncReturn<Vec<u8>> {
        SyncReturn(self.with_module(|store| memory.data(store).to_owned()))
    }
    pub fn read_memory(
        &self,
        memory: RustOpaque<Memory>,
        offset: usize,
        bytes: usize,
    ) -> Result<SyncReturn<Vec<u8>>> {
        self.with_module(|store| {
            let mut buffer = Vec::with_capacity(bytes);
            unsafe { buffer.set_len(bytes) };
            memory
                .read(store, offset, &mut buffer)
                .map(|_| SyncReturn(buffer))
                .map_err(to_anyhow)
        })
    }
    pub fn get_memory_pages(&self, memory: RustOpaque<Memory>) -> SyncReturn<u32> {
        SyncReturn(self.with_module(|store| memory.current_pages(store).into()))
    }

    pub fn write_memory(
        &self,
        memory: RustOpaque<Memory>,
        offset: usize,
        buffer: Vec<u8>,
    ) -> Result<SyncReturn<()>> {
        self.with_module_mut(|store| {
            memory
                .write(store, offset, &buffer)
                .map(SyncReturn)
                .map_err(to_anyhow)
        })
    }
    pub fn grow_memory(&self, memory: RustOpaque<Memory>, pages: u32) -> Result<SyncReturn<u32>> {
        self.with_module_mut(|store| {
            memory
                .grow(
                    store,
                    Pages::new(pages).ok_or(anyhow::anyhow!("Invalid pages"))?,
                )
                .map(|p| SyncReturn(p.into()))
                .map_err(to_anyhow)
        })
    }

    // TABLE

    pub fn get_table_size(&self, table: RustOpaque<Table>) -> SyncReturn<u32> {
        SyncReturn(self.with_module(|store| table.size(store)))
    }
    pub fn get_table_type(&self, table: RustOpaque<Table>) -> SyncReturn<TableTy> {
        SyncReturn(self.with_module(|store| (&table.ty(store)).into()))
    }

    pub fn grow_table(
        &self,
        table: RustOpaque<Table>,
        delta: u32,
        value: Value2,
    ) -> Result<SyncReturn<u32>> {
        self.with_module_mut(|mut store| {
            let mapped = value.to_value(&mut store);
            table
                .grow(&mut store, delta, mapped)
                .map(SyncReturn)
                .map_err(to_anyhow)
        })
    }

    pub fn get_table(&self, table: RustOpaque<Table>, index: u32) -> SyncReturn<Option<Value2>> {
        SyncReturn(self.with_module(|store| {
            table
                .get(store, index)
                .map(|v| Value2::from_value(&v, store))
        }))
    }

    pub fn set_table(
        &self,
        table: RustOpaque<Table>,
        index: u32,
        value: Value2,
    ) -> Result<SyncReturn<()>> {
        self.with_module_mut(|mut store| {
            let mapped = value.to_value(&mut store);
            table
                .set(&mut store, index, mapped)
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
        self.with_module_mut(|mut store| {
            let mapped = value.to_value(&mut store);
            table
                .fill(&mut store, index, mapped, len)
                .map(|_| SyncReturn(()))
                .map_err(to_anyhow)
        })
    }
}

pub fn parse_wat_format(wat: String) -> Result<Vec<u8>> {
    Ok(wat::parse_str(wat)?)
}

type DartMapInt = unsafe extern "C" fn(args: i64) -> i64;

pub fn run_function(pointer: usize) -> SyncReturn<Vec<Value2>> {
    let f: DartMapInt = unsafe { std::mem::transmute(pointer) };
    let result = unsafe { f(1) };
    SyncReturn(vec![Value2::I64(result)])
}

type WasmFunction =
    unsafe extern "C" fn(function_id: u32, args: *mut DartAbi) -> *mut wire_list_value_2;

type WasmFuncT = unsafe extern "C" fn(args: *mut DartAbi) -> *mut wire_list_value_2;
type WasmFuncMutT = unsafe extern "C" fn(args: *mut DartAbi, output: *mut wire_list_value_2) -> i64;
type WasmFuncVoidT = unsafe extern "C" fn(args: *mut DartAbi) -> c_void;

pub fn run_wasm_func(pointer: usize, params: Vec<Value2>) -> SyncReturn<Vec<Value2>> {
    let f: WasmFuncT = unsafe { std::mem::transmute(pointer) };

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
    let f: WasmFuncMutT = unsafe { std::mem::transmute(pointer) };

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
    let f: WasmFuncVoidT = unsafe { std::mem::transmute(pointer) };
    println!("inputs: {:?}", params);
    let inputs = vec![params].into_dart();
    println!("after inputs: {:?}", inputs.ty);
    let pointer = new_leak_box_ptr(inputs);
    println!("pointer: {:?}", pointer);
    unsafe { f(pointer) };
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
