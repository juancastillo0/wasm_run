pub use crate::atomics::*;
use crate::bridge_generated::{wire_list_wasm_val, Wire2Api};
use crate::config::*;
pub use crate::external::WFunc;
use crate::types::*;
use anyhow::{Ok, Result};
use flutter_rust_bridge::{
    support::new_leak_box_ptr, DartAbi, IntoDart, RustOpaque, StreamSink, SyncReturn,
};
use once_cell::sync::Lazy;
use std::io::Write;
pub use std::sync::RwLock;
use std::{collections::HashMap, sync::Arc};
#[cfg(feature = "wasi")]
use wasi_common::pipe::WritePipe;
use wasmi::core::Trap;
pub use wasmi::{core::Pages, Func, Global, Memory, Module, Table};
use wasmi::{core::ValueType, *};

static ARRAY: Lazy<RwLock<GlobalState>> = Lazy::new(|| RwLock::new(Default::default()));

static CALLER_STACK2: Lazy<RwLock<Vec<RwLock<&mut Store<StoreState>>>>> =
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
}

struct StoreState {
    #[cfg(feature = "wasi")]
    wasi_ctx: Option<wasi_common::WasiCtx>,
    stdout: Option<StreamSink<Vec<u8>>>,
    stderr: Option<StreamSink<Vec<u8>>>,
    stack: CallStack,
    // TODO: add to stdin?
}

#[derive(Debug)]
pub struct WasmRunSharedMemory(pub RustOpaque<Arc<RwLock<SharedMemory>>>);

#[derive(Debug)]
pub struct SharedMemory;

#[derive(Clone)]
pub struct WasmRunModuleId(pub u32, pub RustOpaque<CallStack>);

#[derive(Clone, Default)]
pub struct CallStack(Arc<RwLock<Vec<RwLock<StoreContextMut<'static, StoreState>>>>>);

#[derive(Debug, Clone, Copy)]
pub struct WasmRunInstanceId(pub u32);

fn make_wasi_ctx(
    id: &WasmRunModuleId,
    wasi_config: &Option<WasiConfigNative>,
) -> Result<Option<wasi_common::WasiCtx>> {
    let mut wasi_ctx = None;
    if let Some(wasi_config) = wasi_config {
        let mut wasi = wasi_config.to_wasi_ctx()?;

        if wasi_config.capture_stdout {
            let stdout_handler = ModuleIOWriter {
                id: id.clone(),
                is_stdout: true,
            };
            wasi.set_stdout(Box::new(WritePipe::new(stdout_handler)));
        }
        if wasi_config.capture_stderr {
            let stderr_handler = ModuleIOWriter {
                id: id.clone(),
                is_stdout: false,
            };
            wasi.set_stderr(Box::new(WritePipe::new(stderr_handler)));
        }
        wasi_ctx = Some(wasi);
    }

    Ok(wasi_ctx)
}

pub fn module_builder(
    module: CompiledModule,
    num_threads: Option<usize>,
    wasi_config: Option<WasiConfigNative>,
) -> Result<SyncReturn<WasmRunModuleId>> {
    if wasi_config.is_some() && !cfg!(feature = "wasi") {
        return Err(anyhow::Error::msg(
            "WASI feature is not enabled. Please enable it by adding `--features wasi` when building.",
        ));
    }
    if num_threads.is_some() {
        return Err(anyhow::Error::msg(
            "Multi-threading is not supported for the wasmi runtime.",
        ));
    }

    let guard = module.0.lock().unwrap();
    let engine = guard.engine();
    let mut linker = <Linker<StoreState>>::new(engine);

    let mut arr = ARRAY.write().unwrap();
    arr.last_id += 1;

    let id = arr.last_id;

    let stack: CallStack = Default::default();
    let module_id = WasmRunModuleId(id, RustOpaque::new(stack.clone()));

    #[cfg(feature = "wasi")]
    let wasi_ctx = make_wasi_ctx(&module_id, &wasi_config)?;
    #[cfg(feature = "wasi")]
    if wasi_ctx.is_some() {
        wasmi_wasi::add_to_linker(&mut linker, |ctx| ctx.wasi_ctx.as_mut().unwrap())?;
    }

    let store = Store::new(
        engine,
        StoreState {
            #[cfg(feature = "wasi")]
            wasi_ctx,
            stdout: None,
            stderr: None,
            stack,
        },
    );
    let module_builder = WasmiModuleImpl {
        module: Arc::clone(&module.0),
        linker,
        store,
        instance: None,
    };
    arr.map.insert(id, module_builder);

    Ok(SyncReturn(module_id))
}

struct ModuleIOWriter {
    id: WasmRunModuleId,
    is_stdout: bool,
}

impl Write for ModuleIOWriter {
    fn write(&mut self, buf: &[u8]) -> std::io::Result<usize> {
        self.id.with_module(|store| {
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

impl WasmRunInstanceId {
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

impl WasmRunModuleId {
    pub fn instantiate_sync(&self) -> Result<SyncReturn<WasmRunInstanceId>> {
        Ok(SyncReturn(self.instantiate()?))
    }
    pub fn instantiate(&self) -> Result<WasmRunInstanceId> {
        let mut state = ARRAY.write().unwrap();
        let module = state.map.get_mut(&self.0).unwrap();
        if module.instance.is_some() {
            return Err(anyhow::anyhow!("Instance already exists"));
        }
        let instance = module
            .linker
            .instantiate(&mut module.store, &module.module.lock().unwrap())?
            .start(&mut module.store)?;

        module.instance = Some(instance);
        Ok(WasmRunInstanceId(self.0))
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

    pub fn stdio_stream(&self, sink: StreamSink<Vec<u8>>, kind: StdIOKind) -> Result<()> {
        if !cfg!(feature = "wasi") {
            return Err(anyhow::anyhow!(
                "Stdio is not supported without the 'wasi' feature"
            ));
        }
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
        let func = func.func_wasmi;
        self.with_module_mut(|mut store| {
            let mut outputs: Vec<Value> = func
                .ty(&store)
                .results()
                .iter()
                .map(|t| Value::default(*t))
                .collect();
            let inputs: Vec<Value> = args.into_iter().map(|v| v.to_value(&mut store)).collect();
            func.call(&mut store, inputs.as_slice(), &mut outputs)?;
            Ok(outputs
                .into_iter()
                .map(|a| WasmVal::from_value(&a, &store))
                .collect())
        })
    }

    #[allow(unused_variables)]
    pub fn call_function_handle_parallel(
        &self,
        func_name: String,
        args: Vec<WasmVal>,
        num_tasks: usize,
        function_stream: StreamSink<ParallelExec>,
    ) {
        function_stream.add(ParallelExec::Err(
            "Parallel execution is not supported for wasmit.".to_string(),
        ));
    }

    #[allow(unused_variables)]
    pub fn worker_execution(
        &self,
        worker_index: usize,
        results: Vec<WasmVal>,
    ) -> Result<SyncReturn<()>> {
        Err(anyhow::anyhow!(
            "Parallel execution is not supported for wasmit."
        ))
    }

    fn with_module_mut<T>(&self, f: impl FnOnce(StoreContextMut<'_, StoreState>) -> T) -> T {
        {
            let stack = self.1 .0.read().unwrap();
            if let Some(caller) = stack.last() {
                return f(caller.write().unwrap().as_context_mut());
            }
        }
        let mut arr = ARRAY.write().unwrap();
        let value = arr.map.get_mut(&self.0).unwrap();

        let mut ctx = value.store.as_context_mut();
        {
            let v = RwLock::new(unsafe { std::mem::transmute(ctx.as_context_mut()) });
            self.1 .0.write().unwrap().push(v);
        }
        let result = f(ctx);
        self.1 .0.write().unwrap().pop();
        result
    }

    fn with_module_mut2<T>(&self, f: impl FnOnce(&mut Store<StoreState>) -> T) -> T {
        {
            let stack = CALLER_STACK2.read().unwrap();
            if let Some(caller) = stack.last() {
                return f(&mut caller.write().unwrap());
            }
        }
        let mut arr = ARRAY.write().unwrap();
        let value = arr.map.get_mut(&self.0).unwrap();

        let ctx = &mut value.store;
        {
            let v = RwLock::new(unsafe { std::mem::transmute(&mut *ctx) });
            CALLER_STACK2.write().unwrap().push(v);
        }
        let result = f(ctx);
        CALLER_STACK2.write().unwrap().pop();
        result
    }

    fn with_module<T>(&self, f: impl FnOnce(&StoreContext<'_, StoreState>) -> T) -> T {
        {
            let stack = self.1 .0.read().unwrap();
            if let Some(caller) = stack.last() {
                return f(&caller.read().unwrap().as_context());
            }
        }
        let arr = ARRAY.read().unwrap();
        let value = arr.map.get(&self.0).unwrap();
        f(&value.store.as_context())
    }

    pub fn get_function_type(&self, func: RustOpaque<WFunc>) -> SyncReturn<FuncTy> {
        SyncReturn(self.with_module(|store| (&func.func_wasmi.ty(store)).into()))
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
                        .map(|a| WasmVal::from_value(a, &caller))
                        .collect();
                    let inputs = vec![mapped].into_dart();
                    let stack = {
                        let stack = caller.data().stack.clone();
                        let v =
                            RwLock::new(unsafe { std::mem::transmute(caller.as_context_mut()) });
                        stack.0.write().unwrap().push(v);
                        stack
                    };
                    let output: Vec<WasmVal> = unsafe {
                        let pointer = new_leak_box_ptr(inputs);
                        let result = f(function_id, pointer);
                        pointer.drop_in_place();
                        result.wire2api()
                    };
                    let last_caller = stack.0.write().unwrap().pop();

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
        mutable: bool,
    ) -> Result<SyncReturn<RustOpaque<Global>>> {
        self.with_module_mut(|mut store| {
            let mapped = value.to_value(&mut store);
            let global = Global::new(
                &mut store,
                mapped,
                if mutable {
                    Mutability::Var
                } else {
                    Mutability::Const
                },
            );
            Ok(SyncReturn(RustOpaque::new(global)))
        })
    }

    pub fn create_table(
        &self,
        value: WasmVal,
        table_type: TableArgs,
    ) -> Result<SyncReturn<RustOpaque<Table>>> {
        self.with_module_mut(|mut store| {
            let mapped_value = value.to_value(&mut store);
            let table = Table::new(
                &mut store,
                TableType::new(mapped_value.ty(), table_type.minimum, table_type.maximum),
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
        SyncReturn(self.with_module(|store| WasmVal::from_value(&global.get(store), store)))
    }

    pub fn set_global_value(
        &self,
        global: RustOpaque<Global>,
        value: WasmVal,
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

    pub fn get_memory_type(&self, memory: RustOpaque<Memory>) -> SyncReturn<MemoryTy> {
        SyncReturn(self.with_module(|store| (&memory.ty(store)).into()))
    }
    pub fn get_memory_data(&self, memory: RustOpaque<Memory>) -> SyncReturn<Vec<u8>> {
        SyncReturn(self.with_module(|store| memory.data(store).to_owned()))
    }
    pub fn get_memory_data_pointer(&self, memory: RustOpaque<Memory>) -> SyncReturn<usize> {
        SyncReturn(self.with_module_mut(|store| memory.data_mut(store).as_mut_ptr() as usize))
    }
    pub fn get_memory_data_pointer_and_length(
        &self,
        memory: RustOpaque<Memory>,
    ) -> SyncReturn<PointerAndLength> {
        SyncReturn(self.with_module(|store| {
            let data = memory.data(store);
            PointerAndLength {
                pointer: data.as_ptr() as usize,
                length: data.len(),
            }
        }))
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
        value: WasmVal,
    ) -> Result<SyncReturn<u32>> {
        self.with_module_mut(|mut store| {
            let mapped = value.to_value(&mut store);
            table
                .grow(&mut store, delta, mapped)
                .map(SyncReturn)
                .map_err(to_anyhow)
        })
    }

    pub fn get_table(&self, table: RustOpaque<Table>, index: u32) -> SyncReturn<Option<WasmVal>> {
        SyncReturn(self.with_module(|store| {
            table
                .get(store, index)
                .map(|v| WasmVal::from_value(&v, store))
        }))
    }

    pub fn set_table(
        &self,
        table: RustOpaque<Table>,
        index: u32,
        value: WasmVal,
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
        value: WasmVal,
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

    // FUEL
    //

    pub fn add_fuel(&self, delta: u64) -> Result<SyncReturn<()>> {
        self.with_module_mut2(|store| store.add_fuel(delta).map(SyncReturn).map_err(to_anyhow))
    }
    pub fn fuel_consumed(&self) -> SyncReturn<Option<u64>> {
        self.with_module_mut2(|store| SyncReturn(store.fuel_consumed()))
    }
    pub fn consume_fuel(&self, delta: u64) -> Result<SyncReturn<u64>> {
        self.with_module_mut2(|store| store.consume_fuel(delta).map(SyncReturn).map_err(to_anyhow))
    }
}

pub fn parse_wat_format(wat: String) -> Result<Vec<u8>> {
    Ok(wat::parse_str(wat)?)
}

type WasmFunction =
    unsafe extern "C" fn(function_id: u32, args: *mut DartAbi) -> *mut wire_list_wasm_val;

pub struct CompiledModule(pub RustOpaque<Arc<std::sync::Mutex<Module>>>);

impl CompiledModule {
    #[allow(unused)]
    pub fn create_shared_memory(
        &self,
        memory_type: MemoryTy,
    ) -> Result<SyncReturn<WasmRunSharedMemory>> {
        Err(anyhow::Error::msg(
            "shared_memory is not supported for wasmi",
        ))
    }

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

pub fn wasm_features_for_config(config: ModuleConfig) -> SyncReturn<WasmFeatures> {
    SyncReturn(config.wasm_features())
}

pub fn wasm_runtime_features() -> SyncReturn<WasmRuntimeFeatures> {
    SyncReturn(WasmRuntimeFeatures::default())
}

#[allow(unused)]
impl WasmRunSharedMemory {
    pub fn ty(&self) -> SyncReturn<MemoryTy> {
        unreachable!()
    }
    pub fn size(&self) -> SyncReturn<u64> {
        unreachable!()
    }
    pub fn data_size(&self) -> SyncReturn<usize> {
        unreachable!()
    }
    pub fn data_pointer(&self) -> SyncReturn<usize> {
        unreachable!()
    }
    pub fn grow(&self, delta: u64) -> Result<SyncReturn<u64>> {
        unreachable!()
    }
    // pub fn atomic_i8(&self) -> crate::atomics::Ati8 {
    //     crate::atomics::Ati8(self.0.read().unwrap().data().as_ptr() as usize)
    // }

    pub fn atomics(&self) -> Atomics {
        unreachable!()
    }
    pub fn atomic_notify(&self, addr: u64, count: u32) -> Result<SyncReturn<u32>> {
        unreachable!()
    }

    /// Equivalent of the WebAssembly `memory.atomic.wait32` instruction for
    /// this shared memory.
    ///
    /// This method allows embedders to block the current thread until notified
    /// via the `memory.atomic.notify` instruction or the
    /// [`SharedMemory::atomic_notify`] method, enabling synchronization with
    /// the wasm guest as desired.
    ///
    /// The `expected` argument is the expected 32-bit value to be stored at
    /// the byte address `addr` specified. The `addr` specified is an index
    /// into this linear memory.
    ///
    /// The optional `timeout` argument is the point in time after which the
    /// calling thread is guaranteed to be woken up. Blocking will not occur
    /// past this point.
    ///
    /// This function returns one of three possible values:
    ///
    /// * `WaitResult::Ok` - this function, loaded the value at `addr`, found
    ///   it was equal to `expected`, and then blocked (all as one atomic
    ///   operation). The thread was then awoken with a `memory.atomic.notify`
    ///   instruction or the [`SharedMemory::atomic_notify`] method.
    /// * `WaitResult::Mismatch` - the value at `addr` was loaded but was not
    ///   equal to `expected` so the thread did not block and immediately
    ///   returned.
    /// * `WaitResult::TimedOut` - all the steps of `Ok` happened, except this
    ///   thread was woken up due to a timeout.
    ///
    /// This function will not return due to spurious wakeups.
    ///
    /// # Errors
    ///
    /// This function will return an error if `addr` is not within bounds or
    /// not aligned to a 4-byte boundary.
    pub fn atomic_wait32(
        &self,
        addr: u64,
        expected: u32,
        // TODO: timeout: Option<Instant>,
    ) -> Result<SyncReturn<SharedMemoryWaitResult>> {
        unreachable!()
    }

    /// Equivalent of the WebAssembly `memory.atomic.wait64` instruction for
    /// this shared memory.
    ///
    /// For more information see [`SharedMemory::atomic_wait32`].
    ///
    /// # Errors
    ///
    /// Returns the same error as [`SharedMemory::atomic_wait32`] except that
    /// the specified address must be 8-byte aligned instead of 4-byte aligned.
    pub fn atomic_wait64(
        &self,
        addr: u64,
        expected: u64,
        // TODO: timeout: Option<Instant>,
    ) -> Result<SyncReturn<SharedMemoryWaitResult>> {
        unreachable!()
    }
}

#[allow(unused)]
impl Atomics {
    /// Adds the provided value to the existing value at the specified index of the array. Returns the old value at that index.
    pub fn add(&self, offset: usize, kind: AtomicKind, val: i64, order: AtomicOrdering) -> i64 {
        unreachable!()
    }

    /// Returns the value at the specified index of the array.
    pub fn load(&self, offset: usize, kind: AtomicKind, order: AtomicOrdering) -> i64 {
        unreachable!()
    }

    /// Stores a value at the specified index of the array. Returns the value.
    pub fn store(&self, offset: usize, kind: AtomicKind, val: i64, order: AtomicOrdering) {
        unreachable!()
    }

    /// Stores a value at the specified index of the array. Returns the old value.
    pub fn swap(&self, offset: usize, kind: AtomicKind, val: i64, order: AtomicOrdering) -> i64 {
        unreachable!()
    }

    /// Stores a value at the specified index of the array, if it equals a value. Returns the old value.
    pub fn compare_exchange(
        &self,
        offset: usize,
        kind: AtomicKind,
        current: i64,
        new_value: i64,
        success: AtomicOrdering,
        failure: AtomicOrdering,
    ) -> CompareExchangeResult {
        unreachable!()
    }

    /// Subtracts a value at the specified index of the array. Returns the old value at that index.
    pub fn sub(&self, offset: usize, kind: AtomicKind, val: i64, order: AtomicOrdering) -> i64 {
        unreachable!()
    }

    /// Computes a bitwise AND on the value at the specified index of the array with the provided value. Returns the old value at that index.
    pub fn and(&self, offset: usize, kind: AtomicKind, val: i64, order: AtomicOrdering) -> i64 {
        unreachable!()
    }

    /// Computes a bitwise OR on the value at the specified index of the array with the provided value. Returns the old value at that index.
    pub fn or(&self, offset: usize, kind: AtomicKind, val: i64, order: AtomicOrdering) -> i64 {
        unreachable!()
    }

    /// Computes a bitwise XOR on the value at the specified index of the array with the provided value. Returns the old value at that index.
    pub fn xor(&self, offset: usize, kind: AtomicKind, val: i64, order: AtomicOrdering) -> i64 {
        unreachable!()
    }
}
