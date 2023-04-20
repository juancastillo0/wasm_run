use crate::bridge_generated::{wire_list_wasm_val, Wire2Api};
use crate::config::*;
pub use crate::external::*;
use crate::types::*;
use anyhow::{Ok, Result};
use flutter_rust_bridge::{
    support::new_leak_box_ptr, DartAbi, IntoDart, RustOpaque, StreamSink, SyncReturn,
};
use once_cell::sync::Lazy;
use std::io::Write;
use std::{
    collections::HashMap,
    fs,
    sync::{Arc, RwLock},
};
use wasi_common::{file::FileCaps, pipe::WritePipe};
use wasmtime::*;
pub use wasmtime::{Func, Global, GlobalType, Memory, Module, Table};

type Value = wasmtime::Val;
type ValueType = wasmtime::ValType;

static ARRAY: Lazy<RwLock<GlobalState>> = Lazy::new(|| RwLock::new(Default::default()));
// TODO: make it module independent
static CALLER_STACK: Lazy<RwLock<Vec<RwLock<StoreContextMut<'_, StoreState>>>>> =
    Lazy::new(|| RwLock::new(Default::default()));

#[derive(Default)]
struct GlobalState {
    map: HashMap<u32, WasmiModuleImpl>,
    last_id: u32,
}

fn default_val(ty: &ValueType) -> Value {
    match ty {
        ValueType::I32 => Value::I32(0),
        ValueType::I64 => Value::I64(0),
        ValueType::F32 => Value::F32(0),
        ValueType::F64 => Value::F64(0),
        ValueType::V128 => Value::V128(0),
        ValueType::ExternRef => Value::ExternRef(None),
        ValueType::FuncRef => Value::FuncRef(None),
    }
}

struct WasmiModuleImpl {
    module: Arc<std::sync::Mutex<Module>>,
    linker: Linker<StoreState>,
    store: Store<StoreState>,
    instance: Option<Instance>,
}

// impl Debug for WasmiModuleImpl {
//     fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
//         f.debug_struct("WasmiModuleImpl").finish()
//     }
// }

struct StoreState {
    wasi_ctx: Option<wasi_common::WasiCtx>,
    stdout: Option<StreamSink<Vec<u8>>>,
    stderr: Option<StreamSink<Vec<u8>>>,
    // TODO: add to stdin?
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
        wasmtime_wasi::add_to_linker(&mut linker, |ctx| ctx.wasi_ctx.as_mut().unwrap())?;

        let wasi = wasi_config.to_wasi_ctx()?;

        if !wasi_config.preopened_files.is_empty() {
            for value in wasi_config.preopened_files {
                let file = fs::File::open(value)?;
                // let vv = file.as_fd().as_raw_fd();
                let wasm_file =
                    wasmtime_wasi::file::File::from_cap_std(cap_std::fs::File::from_std(file));
                let caps = FileCaps::all();
                // let mut caps = FileCaps::empty();
                // caps.extend([
                //     FileCaps::READ,
                //     FileCaps::FILESTAT_SET_SIZE,
                //     FileCaps::FILESTAT_GET,
                // ]);

                // vv.try_into().unwrap()
                let table_size = wasi.table().push(Arc::new(false)).unwrap();
                // TODO: not sure if this is correct
                wasi.insert_file(table_size, Box::new(wasm_file), caps);
            }
        }

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

    let store = Store::new(
        engine,
        StoreState {
            wasi_ctx,
            stdout: None,
            stderr: None,
        },
    );
    let module_builder = WasmiModuleImpl {
        module: Arc::clone(&module.0),
        linker,
        store,
        instance: None,
    };
    arr.map.insert(id, module_builder);

    Ok(SyncReturn(WasmiModuleId(id)))
}

struct ModuleIOWriter {
    id: u32,
    is_stdout: bool,
}

impl Write for ModuleIOWriter {
    fn write(&mut self, buf: &[u8]) -> std::io::Result<usize> {
        WasmiModuleId(self.id).with_module(|store| {
            let data = store.data();

            let sink = if self.is_stdout {
                data.stdout.as_ref()
            } else {
                data.stderr.as_ref()
            };
            let mut bytes_written = buf.len();
            if let Some(stream) = sink {
                if !stream.add(buf.to_owned()) {
                    bytes_written = 0;
                }
            }
            std::io::Result::Ok(bytes_written)
        })
    }

    fn flush(&mut self) -> std::io::Result<()> {
        std::io::Result::Ok(())
    }
}

impl WasmiInstanceId {
    pub fn exports(&self) -> SyncReturn<Vec<ModuleExportValue>> {
        let mut v = ARRAY.write().unwrap();
        let value = v.map.get_mut(&self.0).unwrap();
        let instance = value.instance.unwrap();
        let l = instance
            .exports(&mut value.store)
            .map(|e| (e.name().to_owned(), e.into_extern()))
            .collect::<Vec<(String, wasmtime::Extern)>>();
        SyncReturn(
            l.into_iter()
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
            .instantiate(&mut module.store, &module.module.lock().unwrap())?;

        module.instance = Some(instance);
        Ok(WasmiInstanceId(self.0))
    }
    pub fn link_imports(&self, imports: Vec<ModuleImport>) -> Result<SyncReturn<()>> {
        let mut arr = ARRAY.write().unwrap();
        let m = arr.map.get_mut(&self.0).unwrap();
        for import in imports {
            m.linker
                .define(&mut m.store, &import.module, &import.name, &import.value)?;
        }
        Ok(SyncReturn(()))
    }

    pub fn stdio_stream(&self, sink: StreamSink<Vec<u8>>, kind: StdIOKind) -> Result<()> {
        self.with_module_mut(|mut store| {
            let store_state = store.data_mut();
            {
                let value = match kind {
                    StdIOKind::stdout => &store_state.stdout,
                    StdIOKind::stderr => &store_state.stderr,
                };
                if value.is_some() {
                    return Err(anyhow::anyhow!("Stream sink already set"));
                }
            }
            match kind {
                StdIOKind::stdout => store_state.stdout = Some(sink),
                StdIOKind::stderr => store_state.stderr = Some(sink),
            };
            Ok(())
        })
    }

    pub fn dispose(&self) -> Result<()> {
        let mut arr = ARRAY.write().unwrap();
        arr.map.remove(&self.0);
        Ok(())
    }

    pub fn call_function_handle_sync(
        &self,
        func: RustOpaque<WFunc>,
        args: Vec<WasmVal>,
    ) -> Result<SyncReturn<Vec<WasmVal>>> {
        self.call_function_handle(func, args).map(SyncReturn)
    }
    pub fn call_function_handle(
        &self,
        func: RustOpaque<WFunc>,
        args: Vec<WasmVal>,
    ) -> Result<Vec<WasmVal>> {
        let func: Func = func.func_wasmtime;
        self.with_module_mut(|mut store| {
            let mut outputs: Vec<Value> =
                func.ty(&store).results().map(|t| default_val(&t)).collect();
            let inputs: Vec<Value> = args.into_iter().map(|v| v.to_val()).collect();
            func.call(&mut store, inputs.as_slice(), &mut outputs)?;
            Ok(outputs.into_iter().map(WasmVal::from_val).collect())
        })
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

        let mut ctx = value.store.as_context_mut();
        {
            let v = RwLock::new(unsafe { std::mem::transmute(ctx.as_context_mut()) });
            CALLER_STACK.write().unwrap().push(v);
        }
        let result = f(ctx);
        CALLER_STACK.write().unwrap().pop();
        result
    }

    fn with_module<T>(&self, f: impl FnOnce(&StoreContext<'_, StoreState>) -> T) -> T {
        // TODO: Only read
        // {
        //     let stack = CALLER_STACK.read().unwrap();
        //     if let Some(caller) = stack.last() {
        //         return f(&caller.read().unwrap().as_context());
        //     }
        // }
        // let arr = ARRAY.read().unwrap();
        // let value = &arr.map[&self.0];
        // f(&value.store.as_context())
        self.with_module_mut(|ctx| f(&ctx.as_context()))
    }

    pub fn get_function_type(&self, func: RustOpaque<WFunc>) -> SyncReturn<FuncTy> {
        SyncReturn(self.with_module(|store| (&func.func_wasmtime.ty(store)).into()))
    }

    pub fn create_function(
        &self,
        function_pointer: usize,
        function_id: u32,
        param_types: Vec<ValueTy>,
        result_types: Vec<ValueTy>,
    ) -> Result<SyncReturn<RustOpaque<WFunc>>> {
        self.with_module_mut(|store| {
            let f: WasmFunction = unsafe { std::mem::transmute(function_pointer) };
            let func = Func::new(
                store,
                FuncType::new(
                    param_types.into_iter().map(ValueType::from),
                    result_types.into_iter().map(ValueType::from),
                ),
                move |mut caller, params, results| {
                    let mapped: Vec<WasmVal> = params
                        .iter()
                        .map(|a| WasmVal::from_val(a.clone()))
                        .collect();
                    let inputs = vec![mapped].into_dart();
                    {
                        let v =
                            RwLock::new(unsafe { std::mem::transmute(caller.as_context_mut()) });
                        CALLER_STACK.write().unwrap().push(v);
                    }
                    let output: Vec<WasmVal> = unsafe {
                        let pointer = new_leak_box_ptr(inputs);
                        let result = f(function_id, pointer);
                        pointer.drop_in_place();
                        result.wire2api()
                    };
                    let last_caller = CALLER_STACK.write().unwrap().pop();

                    if output.len() != results.len() {
                        return Err(anyhow::anyhow!("Invalid output length"));
                    } else if last_caller.is_none() {
                        return Err(anyhow::anyhow!("CALLER_STACK is empty"));
                    } else if output.is_empty() {
                        return std::result::Result::Ok(());
                    }
                    // let last_caller = last_caller.unwrap();
                    // let mut caller = last_caller.write().unwrap();
                    let mut outputs = output.into_iter();
                    for value in results {
                        *value = outputs.next().unwrap().to_val();
                    }
                    std::result::Result::Ok(())
                },
            );
            Ok(SyncReturn(RustOpaque::new(func.into())))
        })
    }

    pub fn create_memory(&self, memory_type: MemoryTy) -> Result<SyncReturn<RustOpaque<Memory>>> {
        self.with_module_mut(|store| {
            let mem_type = memory_type.to_memory_type()?;
            let memory = Memory::new(store, mem_type).map_err(to_anyhow)?;
            Ok(SyncReturn(RustOpaque::new(memory)))
        })
    }

    pub fn create_global(
        &self,
        value: WasmVal,
        mutability: GlobalMutability,
    ) -> Result<SyncReturn<RustOpaque<Global>>> {
        self.with_module_mut(|mut store| {
            let mapped = value.to_val();
            let global = Global::new(
                &mut store,
                GlobalType::new(mapped.ty(), mutability.into()),
                mapped,
            )?;
            Ok(SyncReturn(RustOpaque::new(global)))
        })
    }

    pub fn create_table(
        &self,

        value: WasmVal,
        table_type: TableArgs,
    ) -> Result<SyncReturn<RustOpaque<Table>>> {
        self.with_module_mut(|mut store| {
            let mapped_value = value.to_val();
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

    pub fn get_global_value(&self, global: RustOpaque<Global>) -> SyncReturn<WasmVal> {
        SyncReturn(self.with_module_mut(|store| WasmVal::from_val(global.get(store))))
    }

    pub fn set_global_value(
        &self,
        global: RustOpaque<Global>,
        value: WasmVal,
    ) -> Result<SyncReturn<()>> {
        self.with_module_mut(|mut store| {
            let mapped = value.to_val();
            global
                .set(&mut store, mapped)
                .map(|_| SyncReturn(()))
                .map_err(to_anyhow)
        })
    }

    // MEMORY

    pub fn get_memory_type(&self, memory: RustOpaque<Memory>) -> SyncReturn<MemoryTy> {
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
            #[allow(clippy::uninit_vec)]
            unsafe {
                buffer.set_len(bytes)
            };
            memory
                .read(store, offset, &mut buffer)
                .map(|_| SyncReturn(buffer))
                .map_err(to_anyhow)
        })
    }
    pub fn get_memory_pages(&self, memory: RustOpaque<Memory>) -> SyncReturn<u32> {
        SyncReturn(self.with_module(|store| memory.size(store).try_into().unwrap()))
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
                .grow(store, pages.into())
                .map(|p| SyncReturn(p.try_into().unwrap()))
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
        value: WasmVal,
    ) -> Result<SyncReturn<u32>> {
        self.with_module_mut(|mut store| {
            let mapped = value.to_val();
            table
                .grow(&mut store, delta, mapped)
                .map(SyncReturn)
                .map_err(to_anyhow)
        })
    }

    pub fn get_table(&self, table: RustOpaque<Table>, index: u32) -> SyncReturn<Option<WasmVal>> {
        SyncReturn(self.with_module_mut(|store| table.get(store, index).map(WasmVal::from_val)))
    }

    pub fn set_table(
        &self,
        table: RustOpaque<Table>,
        index: u32,
        value: WasmVal,
    ) -> Result<SyncReturn<()>> {
        self.with_module_mut(|mut store| {
            let mapped = value.to_val();
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
        value: WasmVal,
        len: u32,
    ) -> Result<SyncReturn<()>> {
        self.with_module_mut(|mut store| {
            let mapped = value.to_val();
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

type WasmFunction =
    unsafe extern "C" fn(function_id: u32, args: *mut DartAbi) -> *mut wire_list_wasm_val;

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
    let engine = Engine::new(&config)?;
    let module = Module::new(&engine, &module_wasm[..])?;
    Ok(module.into())
}

pub fn compile_wasm_sync(
    module_wasm: Vec<u8>,
    config: ModuleConfig,
) -> Result<SyncReturn<CompiledModule>> {
    compile_wasm(module_wasm, config).map(SyncReturn)
}
