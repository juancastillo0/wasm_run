pub use crate::atomics::*;
use crate::config::{ModuleConfig, StdIOKind, WasiConfigNative, WasmRuntimeFeatures};
pub use crate::external::*;
use crate::types::*;
use anyhow::{Ok, Result};
use flutter_rust_bridge::frb;
// FRB v2: RustOpaque and StreamSink come from generated code
pub use crate::frb_generated::{RustOpaque, StreamSink};
use once_cell::sync::Lazy;
use std::io::Write;
use std::sync::mpsc::{self, Receiver, Sender};
pub use std::sync::{Mutex, RwLock};
use std::{cell::RefCell, collections::HashMap, sync::Arc};
use wasmtime::*;
// Note: Import wasmtime types but don't re-export them publicly to avoid conflicting FRB codegen impls
use wasmtime::{Func, Global, GlobalType, Memory, Module, SharedMemory, Table};

// Component Model support (for Preview2)
use wasmtime::component::ResourceTable;
// Re-export Component for FFI
pub use wasmtime::component::Component;
// Note: ComponentLinker will be used when we add full component instantiation support
// use wasmtime::component::Linker as ComponentLinker;
// WASI Preview1 support (for core modules)
use wasmtime_wasi::p1::WasiP1Ctx;
// WASI Preview2 support (for components)
use wasmtime_wasi::{WasiCtx, WasiCtxBuilder, WasiCtxView, WasiView};

/// State for WASI Preview2 (used with components)
/// This implements the WasiView trait required by wasmtime_wasi::p2
/// Note: Not exposed to Dart FFI - internal use only
#[allow(dead_code)]
#[frb(ignore)]
struct WasiP2State {
    ctx: WasiCtx,
    table: ResourceTable,
}

#[allow(dead_code)]
impl WasiP2State {
    fn new(ctx: WasiCtx, table: ResourceTable) -> WasiP2State {
        WasiP2State { ctx, table }
    }
}

impl WasiView for WasiP2State {
    fn ctx(&mut self) -> WasiCtxView<'_> {
        WasiCtxView {
            ctx: &mut self.ctx,
            table: &mut self.table,
        }
    }
}

type Value = wasmtime::Val;
type ValueType = wasmtime::ValType;

// Use Mutex instead of RwLock because WasiP1Ctx is not Sync (only Send)
static ARRAY: Lazy<Mutex<GlobalState>> = Lazy::new(|| Mutex::new(Default::default()));

thread_local!(static STORE: RefCell<Option<WasmiModuleImpl>> = RefCell::new(None));

/// Internal state - not exposed to FFI
#[frb(ignore)]
#[derive(Default)]
struct GlobalState {
    map: HashMap<u32, WasmiModuleImpl>,
    last_id: u32,
}

fn default_val(ty: &ValueType) -> Option<Value> {
    // Use wasmtime's built-in default_for_ty which handles ref types correctly
    Value::default_for_ty(ty)
}

/// Internal implementation - not exposed to FFI
#[frb(ignore)]
struct WasmiModuleImpl {
    module: Arc<Mutex<WModule>>,
    linker: Linker<StoreState>,
    store: Store<StoreState>,
    instance: Option<Instance>,
    threads: Option<Arc<Mutex<Vec<Option<WasmiModuleImpl>>>>>,
    pool: Option<Arc<rayon::ThreadPool>>,
    channels: Option<Arc<Mutex<FunctionChannels>>>,
}

/// Store state that supports both WASI Preview1 (core modules) and Preview2 (components)
#[frb(ignore)]
struct StoreState {
    /// WASI Preview1 context (for core modules)
    wasi_p1_ctx: Option<WasiP1Ctx>,
    /// WASI Preview2 context (for components) - wrapped in Option because not all modules need it
    wasi_p2_ctx: Option<WasiP2State>,
    stdout: Option<StreamSink<Vec<u8>>>,
    stderr: Option<StreamSink<Vec<u8>>>,
    functions: HashMap<usize, HostFunction>,
    stack: CallStack,
    // TODO: add to stdin?
}

/// Implement WasiView for StoreState to support Preview2 when needed
impl WasiView for StoreState {
    fn ctx(&mut self) -> WasiCtxView<'_> {
        self.wasi_p2_ctx.as_mut().expect("WASI Preview2 context not initialized").ctx()
    }
}

#[derive(Clone)]
#[frb(ignore)]
struct HostFunction {
    function_pointer: usize,
    function_id: u32,
    param_types: Vec<ValueTy>,
    result_types: Vec<ValueTy>,
}

#[derive(Clone)]
pub struct WasmRunModuleId(pub u32, pub RustOpaque<CallStack>);

#[frb(ignore)]
#[derive(Clone, Default)]
pub struct CallStack(Arc<RwLock<Vec<RwLock<StoreContextMut<'static, StoreState>>>>>);

// SAFETY: CallStack is only accessed from the thread that created the Store.
// The StoreContextMut references are transmuted to 'static lifetime for FFI callbacks
// but are only accessed within the same call frame that created them.
// This pattern is necessary for the Dart FFI callback mechanism.
unsafe impl Sync for CallStack {}
unsafe impl Send for CallStack {}

#[derive(Debug, Clone, Copy)]
pub struct WasmRunInstanceId(pub u32);

/// Build a WasiCtxBuilder from configuration (shared between P1 and P2)
fn build_wasi_ctx_builder(wasi_config: &WasiConfigNative) -> Result<WasiCtxBuilder> {
    let mut builder = WasiCtxBuilder::new();

    // Inherit arguments
    if wasi_config.inherit_args {
        builder.inherit_args();
    }
    for arg in &wasi_config.args {
        builder.arg(arg);
    }

    // Inherit environment
    if wasi_config.inherit_env {
        builder.inherit_env();
    }
    for env in &wasi_config.env {
        builder.env(&env.name, &env.value);
    }

    // Handle stdin
    if wasi_config.inherit_stdin {
        builder.inherit_stdin();
    }

    // Handle stdout capture
    // Note: Custom stdout capture via StreamSink is not directly supported
    // in the new WASI API. For now, we inherit stdout/stderr when not capturing.
    // TODO: Implement custom StdoutStream for capture support
    if !wasi_config.capture_stdout {
        builder.inherit_stdout();
    }

    // Handle stderr capture
    if !wasi_config.capture_stderr {
        builder.inherit_stderr();
    }

    // Preopened directories
    for preopen in &wasi_config.preopened_dirs {
        builder.preopened_dir(
            &preopen.host_path,
            &preopen.wasm_guest_path,
            wasmtime_wasi::DirPerms::all(),
            wasmtime_wasi::FilePerms::all(),
        )?;
    }

    // Note: preopened_files handling changed - files need to be opened differently
    // in the new API. For now, we skip individual file preopening.
    // TODO: Implement file preopening with new API if needed

    Ok(builder)
}

/// Create WASI Preview1 context (for core modules)
fn make_wasi_p1_ctx(
    _id: &WasmRunModuleId,
    wasi_config: &Option<WasiConfigNative>,
) -> Result<Option<WasiP1Ctx>> {
    let wasi_ctx = if let Some(wasi_config) = wasi_config {
        Some(build_wasi_ctx_builder(wasi_config)?.build_p1())
    } else {
        None
    };
    Ok(wasi_ctx)
}

/// Create WASI Preview2 context (for components)
#[allow(dead_code)]
fn make_wasi_p2_ctx(
    _id: &WasmRunModuleId,
    wasi_config: &Option<WasiConfigNative>,
) -> Result<Option<WasiP2State>> {
    let wasi_ctx = if let Some(wasi_config) = wasi_config {
        let ctx = build_wasi_ctx_builder(wasi_config)?.build();
        let table = ResourceTable::new();
        Some(WasiP2State::new(ctx, table))
    } else {
        None
    };
    Ok(wasi_ctx)
}

pub fn module_builder(
    module: CompiledModule,
    num_threads: Option<usize>,
    wasi_config: Option<WasiConfigNative>,
) -> Result<WasmRunModuleId> {
    let guard = module.0.lock().unwrap();
    let engine = guard.inner.engine();

    let mut arr = ARRAY.lock().unwrap();
    arr.last_id += 1;

    let id = arr.last_id;

    let stack: CallStack = Default::default();
    let module_id = WasmRunModuleId(id, RustOpaque::new(stack.clone()));

    let mut linker = <Linker<StoreState>>::new(engine);
    let wasi_p1_ctx = make_wasi_p1_ctx(&module_id, &wasi_config)?;
    if wasi_p1_ctx.is_some() {
        wasmtime_wasi::p1::add_to_linker_sync(&mut linker, |ctx| ctx.wasi_p1_ctx.as_mut().unwrap())?;
    }

    let store = Store::new(
        engine,
        StoreState {
            wasi_p1_ctx,  // Move instead of clone (WasiP1Ctx doesn't implement Clone)
            wasi_p2_ctx: None,  // Preview2 is not used for core modules
            stdout: None,
            stderr: None,
            functions: Default::default(),
            stack,
        },
    );
    let wasm_module = Arc::clone(&module.0);
    let threads = if let Some(num_threads) = num_threads {
        if num_threads <= 1 {
            return Err(anyhow::anyhow!(format!(
                "num_threads must be greater than 1. received: {num_threads}"
            )));
        }
        let threads_vec = (0..num_threads)
            .map(|_index| {
                let mut linker = <Linker<StoreState>>::new(engine);
                // Create a new WASI context for each thread (WasiP1Ctx doesn't Clone)
                let thread_wasi_p1_ctx = if wasi_config.is_some() {
                    wasmtime_wasi::p1::add_to_linker_sync(&mut linker, |ctx| {
                        ctx.wasi_p1_ctx.as_mut().unwrap()
                    })?;
                    // Create a fresh WASI context for this thread
                    make_wasi_p1_ctx(&module_id, &wasi_config)?
                } else {
                    None
                };
                Ok(Some(WasmiModuleImpl {
                    module: wasm_module.clone(),
                    linker,
                    store: Store::new(
                        engine,
                        StoreState {
                            wasi_p1_ctx: thread_wasi_p1_ctx,
                            wasi_p2_ctx: None,
                            stdout: None,
                            stderr: None,
                            functions: Default::default(),
                            stack: Default::default(),
                        },
                    ),
                    instance: None,
                    threads: None,
                    pool: None,
                    channels: None,
                }))
            })
            .collect::<Result<Vec<Option<WasmiModuleImpl>>>>()?;

        Some(Arc::new(Mutex::new(threads_vec)))
    } else {
        None
    };

    let module_builder = WasmiModuleImpl {
        module: wasm_module,
        linker: linker.clone(),
        store,
        instance: None,
        pool: None,
        threads,
        channels: num_threads
            .map(|num_threads| Arc::new(Mutex::new(FunctionChannels::new(num_threads)))),
    };
    arr.map.insert(id, module_builder);

    Ok(module_id)
}

#[allow(dead_code)]
#[frb(ignore)]
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
                if stream.add(buf.to_owned()).is_err() {
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

type WorkerSendRecv = Arc<Mutex<(usize, Sender<FunctionCall>, Receiver<Vec<Val>>)>>;

#[frb(ignore)]
struct FunctionChannels {
    main_send: Sender<FunctionCall>,
    main_recv: Arc<Mutex<Receiver<FunctionCall>>>,
    workers_out: Vec<Sender<Vec<Val>>>,
    workers: Vec<WorkerSendRecv>,
}

impl FunctionChannels {
    fn new(num_workers: usize) -> Self {
        let (main_send, main_recv) = mpsc::channel::<FunctionCall>();
        let mut workers_out = vec![];
        let mut workers = vec![];
        (0..num_workers).for_each(|index| {
            let (send_out, recv_out) = mpsc::channel::<Vec<Val>>();
            workers_out.push(send_out);
            workers.push(Arc::new(Mutex::new((index, main_send.clone(), recv_out))));
        });

        Self {
            main_send,
            main_recv: Arc::new(Mutex::new(main_recv)),
            workers_out,
            workers,
        }
    }
}

impl WasmRunInstanceId {
    #[frb(sync)]
    pub fn exports(&self) -> Vec<ModuleExportValue> {
        let mut v = ARRAY.lock().unwrap();
        let value = v.map.get_mut(&self.0).unwrap();
        let instance = value.instance.unwrap();
        let l = instance
            .exports(&mut value.store)
            .map(|e| (e.name().to_owned(), e.into_extern()))
            .collect::<Vec<(String, wasmtime::Extern)>>();
        l.into_iter()
            .map(|e| ModuleExportValue::from_export(e, &value.store))
            .collect()
    }
}

impl WasmRunModuleId {
    #[frb(sync)]
    pub fn instantiate_sync(&self) -> Result<WasmRunInstanceId> {
        Ok(self.instantiate()?)
    }
    pub fn instantiate(&self) -> Result<WasmRunInstanceId> {
        let mut state = ARRAY.lock().unwrap();
        let module = state.map.get_mut(&self.0).unwrap();
        if module.instance.is_some() {
            return Err(anyhow::anyhow!("Instance already exists"));
        }
        let instance = module
            .linker
            .instantiate(&mut module.store, &module.module.lock().unwrap().inner)?;

        module.instance = Some(instance);
        let threads = module.threads.take();
        if let Some(threads) = threads {
            let len = {
                let mut threads_i = threads.lock().unwrap();
                for thread in threads_i.iter_mut() {
                    let thread = thread.as_mut().unwrap();
                    let thread_instance = thread
                        .linker
                        .instantiate(&mut thread.store, &thread.module.lock().unwrap().inner)?;
                    thread.instance = Some(thread_instance);
                }
                threads_i.len()
            };

            let pool = rayon::ThreadPoolBuilder::new()
                .num_threads(len)
                .start_handler(move |index| {
                    STORE.with(|cell| {
                        let t = threads.clone();
                        let mut threads = t.lock().unwrap();
                        let mut local_store = cell.borrow_mut();
                        *local_store = Some(threads[index].take().unwrap());
                    })
                })
                .build()
                .unwrap();
            module.pool = Some(Arc::new(pool));
            // let channels = module.channels.take().unwrap();
            // let module_id = self.0;
            // let runtime = tokio::runtime::Builder::new_current_thread()
            //     .max_blocking_threads(1)
            //     .worker_threads(1)
            //     .enable_all()
            //     .build()
            //     .unwrap();

            // runtime.block_on(async move {
            //     // module.runtime = Some(runtime);
            //     // TODO: only do this when using runParallel, use select for waiting a finish signal

            //     // runtime.block_on(async move {
            //     let c = channels.lock().unwrap();
            //     c.main_recv.iter().for_each(|req| {
            //         let worker = &c.workers_out[req.worker_index];

            //         let mut results = (0..req.num_results)
            //             .map(|_| default_val(&ValType::I32))
            //             .collect::<Vec<_>>();

            //         // TODO: use same module instance
            //         WasmRunModuleId(module_id)
            //             .with_module_mut(|ctx| {
            //                 let f: WasmFunction =
            //                     unsafe { std::mem::transmute(req.function_pointer) };
            //                 Self::execute_function(ctx, req.args, f, req.function_id, &mut results)
            //             })
            //             .unwrap();
            //         worker.send(results).unwrap();
            //     })
            //     // });
            // });
        }

        Ok(WasmRunInstanceId(self.0))
    }

    fn map_function(
        m: &mut WasmiModuleImpl,
        func: &Func,
        thread_index: usize,
        new_context: StoreContextMut<'_, StoreState>,
    ) -> RustOpaque<WFunc> {
        let raw_id = func.to_raw(&mut m.store) as usize;
        let hf = m.store.data().functions.get(&raw_id).unwrap();
        Self::_create_function(
            new_context,
            hf.clone(),
            Some(m.channels.as_ref().unwrap().lock().unwrap().workers[thread_index].clone()),
        )
        .unwrap()
    }

    #[frb(sync)]
    pub fn link_imports(&self, imports: Vec<ModuleImport>) -> Result<()> {
        let mut arr = ARRAY.lock().unwrap();
        let m = arr.map.get_mut(&self.0).unwrap();
        if m.instance.is_some() {
            return Err(anyhow::anyhow!("Instance already exists"));
        }
        for import in imports.iter() {
            m.linker
                .define(&mut m.store, &import.module, &import.name, &import.value)?;
        }
        if let Some(threads) = m.threads.clone().as_ref() {
            for (thread_index, thread) in &mut threads.lock().unwrap().iter_mut().enumerate() {
                let thread = thread.as_mut().unwrap();
                for import in imports.iter() {
                    let mapped_value = match &import.value {
                        ExternalValue::Func(f) => {
                            let ff = Self::map_function(
                                m,
                                &f.func_wasmtime,
                                thread_index,
                                thread.store.as_context_mut(),
                            );
                            ExternalValue::Func(ff)
                        }
                        ExternalValue::SharedMemory(sm) => ExternalValue::SharedMemory(sm.clone()),
                        ExternalValue::Global(g) => {
                            let ty = g.inner.ty(&m.store);
                            let v = match g.inner.get(&mut m.store) {
                                Val::FuncRef(Some(v)) => {
                                    let ff = Self::map_function(
                                        m,
                                        &v,
                                        thread_index,
                                        thread.store.as_context_mut(),
                                    );
                                    Val::FuncRef(Some(ff.func_wasmtime))
                                }
                                v => v,
                            };
                            let global = Global::new(&mut thread.store, ty, v)?;
                            ExternalValue::Global(RustOpaque::new(WGlobal::from(global)))
                        }
                        ExternalValue::Memory(mem) => {
                            let ty = mem.inner.ty(&m.store);
                            // TODO: should we copy the memory contents?
                            let memory = Memory::new(&mut thread.store, ty)?;
                            ExternalValue::Memory(RustOpaque::new(WMemory::from(memory)))
                        }
                        ExternalValue::Table(t) => {
                            let ty = t.inner.ty(&m.store);
                            let fill_value: Option<Ref> = if t.inner.size(&m.store) > 0 {
                                let v = t.inner.get(&mut m.store, 0);
                                if let Some(r) = v {
                                    // Check if it's a func ref that needs mapping
                                    if let Some(f) = r.as_func().flatten() {
                                        let ff = Self::map_function(
                                            m,
                                            f,
                                            thread_index,
                                            thread.store.as_context_mut(),
                                        );
                                        Some(Ref::Func(Some(ff.func_wasmtime)))
                                    } else {
                                        Some(r)
                                    }
                                } else {
                                    None
                                }
                            } else {
                                None
                            };
                            // Get the null ref for the element type as default
                            let v = fill_value.unwrap_or_else(|| Ref::Func(None));
                            let table = Table::new(&mut thread.store, ty, v)?;
                            ExternalValue::Table(RustOpaque::new(WTable::from(table)))
                        }
                    };

                    thread.linker.define(
                        &mut thread.store,
                        &import.module,
                        &import.name,
                        &mapped_value,
                    )?;
                }
            }
        }
        Ok(())
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
        let mut arr = ARRAY.lock().unwrap();
        arr.map.remove(&self.0);
        Ok(())
    }

    pub fn call_function_handle_sync(
        &self,
        func: RustOpaque<WFunc>,
        args: Vec<WasmVal>,
    ) -> Result<Vec<WasmVal>> {
        self.call_function_handle(func, args)
    }
    pub fn call_function_handle(
        &self,
        func: RustOpaque<WFunc>,
        args: Vec<WasmVal>,
    ) -> Result<Vec<WasmVal>> {
        let func: Func = func.func_wasmtime;
        self.with_module_mut(|mut store| {
            let mut outputs: Vec<Value> = func
                .ty(&store)
                .results()
                .filter_map(|t| default_val(&t))
                .collect();
            let inputs: Vec<Value> = args
                .into_iter()
                .map(|v| v.to_val(&mut store))
                .collect::<Result<Vec<_>>>()?;
            func.call(&mut store, inputs.as_slice(), &mut outputs)?;
            outputs
                .into_iter()
                .map(|v| WasmVal::from_val(v, &store))
                .collect::<Result<Vec<_>>>()
        })
    }

    pub fn call_function_handle_parallel(
        &self,
        func_name: String,
        args: Vec<WasmVal>,
        num_tasks: usize,
        function_stream: StreamSink<ParallelExec>,
    ) {
        use rayon::prelude::*;

        let (num_params, result_types, pool, channels) = {
            let mut m = ARRAY.lock().unwrap();
            let module = m.map.get_mut(&self.0).unwrap();

            let func: Func = module
                .instance
                .unwrap()
                .get_func(&mut module.store, &func_name)
                .unwrap();
            let num_params = func.ty(&module.store).params().count();
            if (num_params == 0 && !args.is_empty())
                || (num_params != 0 && args.len() % num_params != 0)
                || num_params * num_tasks != args.len()
            {
                let _ = function_stream.add(ParallelExec::Err(format!(
                    "Number of arguments must be a multiple of {num_params}"
                )));
                return;
            }
            let result_types: Vec<ValType> = func.ty(&module.store).results().collect();

            (
                num_params,
                result_types,
                module.pool.clone(),
                module.channels.clone(),
            )
        };

        if let (Some(pool), Some(channels)) = (pool, channels) {
            // Use to_val_simple for parallel execution (no store context available here)
            // This works for simple types; GC types will error
            let args: Vec<Value> = match args
                .into_iter()
                .map(|v| v.to_val_simple())
                .collect::<Result<Vec<_>>>()
            {
                std::result::Result::Ok(a) => a,
                Err(e) => {
                    let _ = function_stream.add(ParallelExec::Err(e.to_string()));
                    return;
                }
            };

            let main_send = channels.lock().unwrap().main_send.clone();
            // TODO: try with tokio
            std::thread::spawn(move || {
                let value: std::result::Result<Vec<WasmVal>, Error> = pool.install(|| {
                    let iter: Vec<&[Val]> = if args.is_empty() {
                        (0..num_tasks).map(|_| [].as_slice()).collect()
                    } else {
                        args.chunks_exact(num_params).collect()
                    };

                    let v = iter
                        .par_iter()
                        .map(|inputs| {
                            STORE.with(|cell| {
                                let mut c = cell.borrow_mut();
                                let m = c.as_mut().unwrap();

                                let mut outputs: Vec<Value> = result_types
                                    .iter()
                                    .filter_map(default_val)
                                    .collect();
                                let func = m
                                    .instance
                                    .unwrap()
                                    .get_func(&mut m.store, &func_name)
                                    .unwrap();
                                func.call(&mut m.store, inputs, &mut outputs)?;
                                outputs
                                    .into_iter()
                                    .map(|v| WasmVal::from_val(v, &m.store))
                                    .collect::<Result<Vec<WasmVal>>>()
                            })
                        })
                        .collect::<Result<Vec<Vec<WasmVal>>>>()?
                        .into_iter()
                        .flatten()
                        .collect::<Vec<WasmVal>>();
                    Ok(v)
                });
                // TODO: don't unwrap
                main_send
                    .send(FunctionCall {
                        // TODO: don't unwrap
                        args: value.unwrap(),
                        function_id: 0,
                        function_pointer: 0,
                        num_results: 0,
                        worker_index: 0,
                    })
                    .unwrap();
            });
            let main_recv = channels.lock().unwrap().main_recv.clone();
            let main_recv_c = main_recv.lock().unwrap();
            loop {
                let req = main_recv_c.recv().unwrap();
                if req.function_pointer == 0 {
                    let _ = function_stream.add(ParallelExec::Ok(req.args));
                    return;
                }
                let _ = function_stream.add(ParallelExec::Call(req));
                // TODO: try this code with sync function
                // let worker = &c.workers_out[req.worker_index];

                // let mut results = (0..req.num_results)
                //     .map(|_| default_val(&ValType::I32))
                //     .collect::<Vec<_>>();

                // // TODO: use same module instance
                // self.with_module_mut(|ctx| {
                //     let f: WasmFunction = unsafe { std::mem::transmute(req.function_pointer) };
                //     Self::execute_function(ctx, req.args, f, req.function_id, &mut results)
                // })
                // .unwrap();
                // worker.send(results).unwrap();
            }
        } else {
            let _ = function_stream.add(ParallelExec::Err(
                "Instance has no thread pool configured".to_string(),
            ));
        }
    }

    pub fn worker_execution(
        &self,
        worker_index: usize,
        results: Vec<WasmVal>,
    ) -> Result<()> {
        let m = ARRAY.lock().unwrap();
        let module = m.map.get(&self.0).unwrap();
        let worker = &module
            .channels
            .as_ref()
            .unwrap()
            .lock()
            .unwrap()
            .workers_out[worker_index];

        // Use to_val_simple since we don't have store context here
        let converted: Vec<Value> = results
            .into_iter()
            .map(|v| v.to_val_simple())
            .collect::<Result<Vec<_>>>()?;
        worker.send(converted)?;
        Ok(())
    }

    fn with_module_mut<T>(&self, f: impl FnOnce(StoreContextMut<'_, StoreState>) -> T) -> T {
        {
            let stack = self.1 .0.read().unwrap();
            if let Some(caller) = stack.last() {
                return f(caller.write().unwrap().as_context_mut());
            }
        }
        let mut arr = ARRAY.lock().unwrap();
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

    fn with_module<T>(&self, f: impl FnOnce(&StoreContext<'_, StoreState>) -> T) -> T {
        {
            let stack = self.1 .0.read().unwrap();
            if let Some(caller) = stack.last() {
                return f(&caller.read().unwrap().as_context());
            }
        }
        let arr = ARRAY.lock().unwrap();
        let value = arr.map.get(&self.0).unwrap();
        f(&value.store.as_context())
    }

    #[frb(sync)]
    pub fn get_function_type(&self, func: RustOpaque<WFunc>) -> FuncTy {
        self.with_module(|store| (&func.func_wasmtime.ty(store)).into())
    }

    pub fn create_function(
        &self,
        function_pointer: usize,
        function_id: u32,
        param_types: Vec<ValueTy>,
        result_types: Vec<ValueTy>,
    ) -> Result<RustOpaque<WFunc>> {
        self.with_module_mut(|store| {
            Self::_create_function(
                store,
                HostFunction {
                    function_pointer,
                    function_id,
                    param_types,
                    result_types,
                },
                None,
            )
        })
    }

    fn _create_function(
        mut store: StoreContextMut<'_, StoreState>,
        hf: HostFunction,
        worker_channel: Option<WorkerSendRecv>,
    ) -> Result<RustOpaque<WFunc>> {
        // TODO: FRB v2 migration - need to redesign callback mechanism
        // In v1, function_pointer was a raw C FFI function pointer
        // In v2, we need to use DartFn<...> or closure-based callbacks
        let _f: WasmFunction = |_id, args| args; // Placeholder
        let engine = store.engine().clone();
        let func = Func::new(
            store.as_context_mut(),
            FuncType::new(
                &engine,
                hf.param_types.iter().cloned().map(ValueType::from),
                hf.result_types.iter().cloned().map(ValueType::from),
            ),
            move |mut caller, params, results| {
                let mapped: Vec<WasmVal> = params
                    .iter()
                    .map(|a| WasmVal::from_val(a.clone(), &caller))
                    .collect::<Result<Vec<_>>>()?;
                if let Some(worker_channel) = worker_channel.clone() {
                    let guard = worker_channel.lock().unwrap();
                    // TODO: use StreamSink directly
                    guard.1.send(FunctionCall {
                        args: mapped,
                        function_id: hf.function_id,
                        function_pointer: hf.function_pointer,
                        num_results: results.len(),
                        worker_index: guard.0,
                    })?;
                    let output = guard.2.recv()?;
                    let mut outputs = output.into_iter();
                    for value in results {
                        *value = outputs.next().unwrap();
                    }
                    return Ok(());
                }

                Self::execute_function(
                    caller.as_context_mut(),
                    mapped,
                    _f,
                    hf.function_id,
                    results,
                )?;
                Ok(())
            },
        );
        let raw_id = func.to_raw(&mut store) as usize;
        store.data_mut().functions.insert(raw_id, hf);
        Ok(RustOpaque::new(func.into()))
    }

    fn execute_function(
        caller: StoreContextMut<'_, StoreState>,
        mapped: Vec<WasmVal>,
        f: WasmFunction,
        function_id: u32,
        results: &mut [Val],
    ) -> Result<()> {
        // TODO: FRB v2 migration - The callback mechanism needs redesigning
        // In v1, this used raw FFI (new_leak_box_ptr, into_dart, wire2api)
        // In v2, we need to use DartFn<...> or a different callback pattern
        let stack = {
            let stack = caller.data().stack.clone();
            let v = RwLock::new(unsafe { std::mem::transmute(caller) });
            stack.0.write().unwrap().push(v);
            stack
        };

        // Call the function directly (simplified for v2 migration)
        let output: Vec<WasmVal> = f(function_id, mapped);

        // TODO: use Drop for this
        let last_caller = stack.0.write().unwrap().pop();

        if output.len() != results.len() {
            return Err(anyhow::anyhow!("Invalid output length"));
        } else if last_caller.is_none() {
            return Err(anyhow::anyhow!("CALLER_STACK is empty"));
        } else if output.is_empty() {
            return Ok(());
        }
        let mut outputs = output.into_iter();
        for value in results {
            // Use to_val_simple since we don't have store context here
            *value = outputs.next().unwrap().to_val_simple()?;
        }
        Ok(())
    }

    #[frb(sync)]
    pub fn create_memory(&self, memory_type: MemoryTy) -> Result<RustOpaque<WMemory>> {
        self.with_module_mut(|store| {
            let mem_type = memory_type.to_memory_type()?;
            let memory = Memory::new(store, mem_type).map_err(to_anyhow)?;
            Ok(RustOpaque::new(WMemory::from(memory)))
        })
    }

    pub fn create_global(
        &self,
        value: WasmVal,
        mutable: bool,
    ) -> Result<RustOpaque<WGlobal>> {
        self.with_module_mut(|mut store| {
            let mapped = value.to_val(&mut store)?;
            let ty = mapped.ty(&store)?;
            let global = Global::new(
                &mut store,
                GlobalType::new(
                    ty,
                    if mutable {
                        Mutability::Var
                    } else {
                        Mutability::Const
                    },
                ),
                mapped,
            )?;
            Ok(RustOpaque::new(WGlobal::from(global)))
        })
    }

    pub fn create_table(
        &self,
        value: WasmVal,
        table_type: TableArgs,
    ) -> Result<RustOpaque<WTable>> {
        self.with_module_mut(|mut store| {
            let mapped_value = value.to_val(&mut store)?;
            // Convert Val to Ref for Table::new
            let ref_val = mapped_value.ref_().ok_or_else(|| {
                anyhow::anyhow!("Table values must be reference types")
            })?;
            // Get the reference type - Ref::ty returns Option<RefType> for null refs
            let ref_type = ref_val.ty(&store).unwrap_or_else(|_| {
                // Default to funcref for null references
                RefType::new(false, HeapType::Func)
            });
            let table = Table::new(
                &mut store,
                TableType::new(ref_type, table_type.minimum, table_type.maximum),
                ref_val,
            )
            .map_err(to_anyhow)?;
            Ok(RustOpaque::new(WTable::from(table)))
        })
    }

    // GLOBAL

    #[frb(sync)]
    pub fn get_global_type(&self, global: RustOpaque<WGlobal>) -> GlobalTy {
        self.with_module(|store| (&global.as_wasmtime().ty(store)).into())
    }

    #[frb(sync)]
    pub fn get_global_value(&self, global: RustOpaque<WGlobal>) -> Result<WasmVal> {
        self.with_module_mut(|mut store| {
            let val = global.as_wasmtime().get(&mut store);
            let wasm_val = WasmVal::from_val(val, &store)?;
            Ok(wasm_val)
        })
    }

    pub fn set_global_value(
        &self,
        global: RustOpaque<WGlobal>,
        value: WasmVal,
    ) -> Result<()> {
        self.with_module_mut(|mut store| {
            let mapped = value.to_val(&mut store)?;
            global.as_wasmtime().set(&mut store, mapped)
                .map(|_| ())
                .map_err(to_anyhow)
        })
    }

    // MEMORY

    #[frb(sync)]
    pub fn get_memory_type(&self, memory: RustOpaque<WMemory>) -> MemoryTy {
        let m = memory.as_wasmtime();
        self.with_module(|store| (&m.ty(store)).into())
    }
    #[frb(sync)]
    pub fn get_memory_data(&self, memory: RustOpaque<WMemory>) -> Vec<u8> {
        let m = memory.as_wasmtime();
        self.with_module(|store| m.data(store).to_owned())
    }
    #[frb(sync)]
    pub fn get_memory_data_pointer(&self, memory: RustOpaque<WMemory>) -> usize {
        let m = memory.as_wasmtime();
        self.with_module(|store| m.data_ptr(store) as usize)
    }
    pub fn get_memory_data_pointer_and_length(
        &self,
        memory: RustOpaque<WMemory>,
    ) -> PointerAndLength {
        let m = memory.as_wasmtime();
        self.with_module(|store| PointerAndLength {
            pointer: m.data_ptr(store) as usize,
            length: m.data_size(store),
        })
    }
    pub fn read_memory(
        &self,
        memory: RustOpaque<WMemory>,
        offset: usize,
        bytes: usize,
    ) -> Result<Vec<u8>> {
        let m = memory.as_wasmtime();
        self.with_module(|store| {
            let mut buffer = Vec::with_capacity(bytes);
            #[allow(clippy::uninit_vec)]
            unsafe {
                buffer.set_len(bytes)
            };
            m.read(store, offset, &mut buffer)
                .map(|_| buffer)
                .map_err(to_anyhow)
        })
    }
    #[frb(sync)]
    pub fn get_memory_pages(&self, memory: RustOpaque<WMemory>) -> u32 {
        let m = memory.as_wasmtime();
        self.with_module(|store| m.size(store).try_into().unwrap())
    }

    pub fn write_memory(
        &self,
        memory: RustOpaque<WMemory>,
        offset: usize,
        buffer: Vec<u8>,
    ) -> Result<()> {
        let m = memory.as_wasmtime();
        self.with_module_mut(|store| {
            m.write(store, offset, &buffer)
                .map_err(to_anyhow)
        })
    }
    #[frb(sync)]
    pub fn grow_memory(&self, memory: RustOpaque<WMemory>, pages: u32) -> Result<u32> {
        let m = memory.as_wasmtime();
        self.with_module_mut(|store| {
            m.grow(store, pages.into())
                .map(|p| p.try_into().unwrap())
                .map_err(to_anyhow)
        })
    }

    // TABLE
    // Note: wasmtime 41 uses u64 for table operations internally, but we keep u32 API for backwards compatibility

    #[frb(sync)]
    pub fn get_table_size(&self, table: RustOpaque<WTable>) -> u32 {
        let t = table.as_wasmtime();
        self.with_module(|store| t.size(store) as u32)
    }
    #[frb(sync)]
    pub fn get_table_type(&self, table: RustOpaque<WTable>) -> TableTy {
        let t = table.as_wasmtime();
        self.with_module(|store| (&t.ty(store)).into())
    }

    pub fn grow_table(
        &self,
        table: RustOpaque<WTable>,
        delta: u32,
        value: WasmVal,
    ) -> Result<u32> {
        let t = table.as_wasmtime();
        self.with_module_mut(|mut store| {
            let mapped = value.to_val(&mut store)?;
            // Convert Val to Ref for Table::grow
            let ref_val = mapped.ref_().ok_or_else(|| {
                anyhow::anyhow!("Table grow value must be a reference type")
            })?;
            t.grow(&mut store, delta.into(), ref_val)
                .map(|v| v as u32)
                .map_err(to_anyhow)
        })
    }

    #[frb(sync)]
    pub fn get_table(&self, table: RustOpaque<WTable>, index: u32) -> Result<Option<WasmVal>> {
        let t = table.as_wasmtime();
        self.with_module_mut(|mut store| {
            match t.get(&mut store, index.into()) {
                Some(ref_val) => {
                    // Convert Ref to Val for WasmVal::from_val
                    let val = Val::from(ref_val);
                    Ok(Some(WasmVal::from_val(val, &store)?))
                }
                None => Ok(None),
            }
        })
    }

    pub fn set_table(
        &self,
        table: RustOpaque<WTable>,
        index: u32,
        value: WasmVal,
    ) -> Result<()> {
        let t = table.as_wasmtime();
        self.with_module_mut(|mut store| {
            let mapped = value.to_val(&mut store)?;
            // Convert Val to Ref for Table::set
            let ref_val = mapped.ref_().ok_or_else(|| {
                anyhow::anyhow!("Table set value must be a reference type")
            })?;
            t.set(&mut store, index.into(), ref_val)
                .map_err(to_anyhow)
        })
    }

    pub fn fill_table(
        &self,
        table: RustOpaque<WTable>,
        index: u32,
        value: WasmVal,
        len: u32,
    ) -> Result<()> {
        let t = table.as_wasmtime();
        self.with_module_mut(|mut store| {
            let mapped = value.to_val(&mut store)?;
            // Convert Val to Ref for Table::fill
            let ref_val = mapped.ref_().ok_or_else(|| {
                anyhow::anyhow!("Table fill value must be a reference type")
            })?;
            t.fill(&mut store, index.into(), ref_val, len.into())
                .map(|_| ())
                .map_err(to_anyhow)
        })
    }

    // FUEL
    // Note: wasmtime 41 changed fuel API - now uses get_fuel/set_fuel instead of add_fuel/consume_fuel

    #[frb(sync)]
    pub fn add_fuel(&self, delta: u64) -> Result<()> {
        self.with_module_mut(|mut store| {
            // In wasmtime 41, we need to get current fuel and add to it
            let current = store.get_fuel().unwrap_or(0);
            store.set_fuel(current.saturating_add(delta)).map(|_| ())
        })
    }
    #[frb(sync)]
    pub fn fuel_consumed(&self) -> Option<u64> {
        // get_fuel returns remaining fuel, not consumed
        // We can't track consumed fuel without knowing initial fuel
        self.with_module_mut(|store| store.get_fuel().ok())
    }
    #[frb(sync)]
    pub fn consume_fuel(&self, delta: u64) -> Result<u64> {
        self.with_module_mut(|mut store| {
            let current = store.get_fuel()?;
            let new_fuel = current.saturating_sub(delta);
            store.set_fuel(new_fuel)?;
            Ok(new_fuel)
        })
    }
}

pub fn parse_wat_format(wat: String) -> Result<Vec<u8>> {
    Ok(wat::parse_str(wat)?)
}

// TODO: FRB v2 migration - The callback mechanism needs to be redesigned for v2
// In v1, this was a raw C FFI callback. In v2, we need to use DartFn<...> or similar.
// type WasmFunction =
//     unsafe extern "C" fn(function_id: u32, args: *mut DartAbi) -> *mut wire_list_wasm_val;
type WasmFunction = fn(u32, Vec<WasmVal>) -> Vec<WasmVal>;

pub struct CompiledModule(pub RustOpaque<Arc<std::sync::Mutex<WModule>>>);

impl CompiledModule {
    pub fn create_shared_memory(
        &self,
        memory_type: MemoryTy,
    ) -> Result<WasmRunSharedMemory> {
        let module = self.0.lock().unwrap();
        let memory = SharedMemory::new(module.as_wasmtime().engine(), memory_type.to_memory_type()?)?;
        Ok(memory.into())
    }

    #[frb(sync)]
    pub fn get_module_imports(&self) -> Vec<ModuleImportDesc> {
        self.0
            .lock()
            .unwrap()
            .as_wasmtime()
            .imports()
            .map(|i| (&i).into())
            .collect()
    }

    #[frb(sync)]
    pub fn get_module_exports(&self) -> Vec<ModuleExportDesc> {
        self.0
            .lock()
            .unwrap()
            .as_wasmtime()
            .exports()
            .map(|i| (&i).into())
            .collect()
    }
}

impl From<Module> for CompiledModule {
    fn from(module: Module) -> Self {
        CompiledModule(RustOpaque::new(Arc::new(std::sync::Mutex::new(WModule::from(module)))))
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
) -> Result<CompiledModule> {
    compile_wasm(module_wasm, config)
}

// ============================================================================
// Component Model Support (WASI Preview2)
// ============================================================================

/// The kind of WebAssembly binary (core module or component)
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum WasmBinaryKind {
    /// Core WebAssembly module (uses WASI Preview1)
    Module,
    /// WebAssembly Component (uses WASI Preview2)
    Component,
}

/// Detect whether the given bytes are a core module or a component.
/// Returns None if the bytes are not valid WebAssembly.
#[frb(sync)]
pub fn detect_wasm_kind(wasm_bytes: Vec<u8>) -> Option<WasmBinaryKind> {
    // Check the magic number and version/layer
    // Core modules: \0asm followed by version 1 (0x01 0x00 0x00 0x00)
    // Components: \0asm followed by layer 1 (0x0d 0x00 0x01 0x00)
    if wasm_bytes.len() < 8 {
        return None;
    }

    // Check magic number
    if &wasm_bytes[0..4] != b"\0asm" {
        return None;
    }

    // Check version/layer bytes
    match &wasm_bytes[4..8] {
        [0x01, 0x00, 0x00, 0x00] => Some(WasmBinaryKind::Module),
        [0x0d, 0x00, 0x01, 0x00] => Some(WasmBinaryKind::Component),
        _ => None,
    }
}

/// A compiled WebAssembly Component (uses WASI Preview2)
pub struct CompiledComponent(pub RustOpaque<Arc<std::sync::Mutex<Component>>>);

impl CompiledComponent {
    /// Get the component's imports
    #[frb(sync)]
    pub fn get_component_imports(&self) -> Vec<String> {
        // Component imports have a different structure than module imports
        // For now, return import names as strings
        let component = self.0.lock().unwrap();
        let imports: Vec<String> = component
            .component_type()
            .imports(&component.engine())
            .map(|(name, _)| name.to_string())
            .collect();
        imports
    }

    /// Get the component's exports
    #[frb(sync)]
    pub fn get_component_exports(&self) -> Vec<String> {
        let component = self.0.lock().unwrap();
        let exports: Vec<String> = component
            .component_type()
            .exports(&component.engine())
            .map(|(name, _)| name.to_string())
            .collect();
        exports
    }
}

impl From<Component> for CompiledComponent {
    fn from(component: Component) -> CompiledComponent {
        CompiledComponent(RustOpaque::new(Arc::new(std::sync::Mutex::new(component))))
    }
}

/// Compile a WebAssembly Component (for WASI Preview2)
pub fn compile_component(component_wasm: Vec<u8>, config: ModuleConfig) -> Result<CompiledComponent> {
    let mut wasmtime_config: Config = config.into();
    // Enable component model for components
    wasmtime_config.wasm_component_model(true);
    let engine = Engine::new(&wasmtime_config)?;
    let component = Component::new(&engine, &component_wasm[..])?;
    Ok(component.into())
}

/// Compile a WebAssembly Component synchronously
pub fn compile_component_sync(
    component_wasm: Vec<u8>,
    config: ModuleConfig,
) -> Result<CompiledComponent> {
    compile_component(component_wasm, config)
}

// ============================================================================
// End Component Model Support
// ============================================================================

#[frb(sync)]
pub fn wasm_features_for_config(config: ModuleConfig) -> crate::config::WasmFeatures {
    config.wasm_features()
}

#[frb(sync)]
pub fn wasm_runtime_features() -> WasmRuntimeFeatures {
    WasmRuntimeFeatures::default()
}

#[derive(Debug, Clone)]
pub struct WasmRunSharedMemory(pub RustOpaque<Arc<RwLock<WSharedMemory>>>);

impl From<SharedMemory> for WasmRunSharedMemory {
    fn from(memory: SharedMemory) -> Self {
        WasmRunSharedMemory(RustOpaque::new(Arc::new(RwLock::new(WSharedMemory::from(memory)))))
    }
}

impl WasmRunSharedMemory {
    #[frb(sync)]
    pub fn ty(&self) -> MemoryTy {
        (&self.0.read().unwrap().as_wasmtime().ty()).into()
    }
    #[frb(sync)]
    pub fn size(&self) -> u64 {
        self.0.read().unwrap().as_wasmtime().size()
    }
    #[frb(sync)]
    pub fn data_size(&self) -> usize {
        self.0.read().unwrap().as_wasmtime().data_size()
    }
    #[frb(sync)]
    pub fn data_pointer(&self) -> usize {
        self.0.read().unwrap().as_wasmtime().data().as_ptr() as usize
    }
    #[frb(sync)]
    pub fn grow(&self, delta: u64) -> Result<u64> {
        Ok(self.0.read().unwrap().as_wasmtime().grow(delta)?)
    }
    // pub fn atomic_i8(&self) -> crate::atomics::Ati8 {
    //     crate::atomics::Ati8(self.0.read().unwrap().data().as_ptr() as usize)
    // }

    pub fn atomics(&self) -> Atomics {
        Atomics(self.0.read().unwrap().inner.data().as_ptr() as usize)
    }
    #[frb(sync)]
    pub fn atomic_notify(&self, addr: u64, count: u32) -> Result<u32> {
        Ok(
            self.0.read().unwrap().inner.atomic_notify(addr, count)?,
        )
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
    ) -> Result<SharedMemoryWaitResult> {
        Ok(
            self.0
                .read()
                .unwrap()
                .inner
                .atomic_wait32(addr, expected, None)?
                .into(),
        )
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
    ) -> Result<SharedMemoryWaitResult> {
        Ok(
            self.0
                .read()
                .unwrap()
                .inner
                .atomic_wait64(addr, expected, None)?
                .into(),
        )
    }
}

impl Atomics {
    /// Adds the provided value to the existing value at the specified index of the array. Returns the old value at that index.
    pub fn add(&self, offset: usize, kind: AtomicKind, val: i64, order: AtomicOrdering) -> i64 {
        unsafe {
            match kind {
                AtomicKind::I32 => Ati32(self.0)
                    .add(offset, val.try_into().unwrap(), order)
                    .into(),
                AtomicKind::U32 => Atu32(self.0)
                    .add(offset, val.try_into().unwrap(), order)
                    .into(),
                AtomicKind::I64 => Ati64(self.0).add(offset, val, order),
                AtomicKind::U64 => Atu64(self.0)
                    .add(offset, val.try_into().unwrap(), order)
                    .try_into()
                    .unwrap(),
                AtomicKind::I8 => Ati8(self.0)
                    .add(offset, val.try_into().unwrap(), order)
                    .into(),
                AtomicKind::U8 => Atu8(self.0)
                    .add(offset, val.try_into().unwrap(), order)
                    .into(),
                AtomicKind::I16 => Ati16(self.0)
                    .add(offset, val.try_into().unwrap(), order)
                    .into(),
                AtomicKind::U16 => Atu16(self.0)
                    .add(offset, val.try_into().unwrap(), order)
                    .into(),
            }
        }
    }

    /// Returns the value at the specified index of the array.
    pub fn load(&self, offset: usize, kind: AtomicKind, order: AtomicOrdering) -> i64 {
        unsafe {
            match kind {
                AtomicKind::I32 => Ati32(self.0).load(offset, order).into(),
                AtomicKind::U32 => Atu32(self.0).load(offset, order).into(),
                AtomicKind::I64 => Ati64(self.0).load(offset, order),
                AtomicKind::U64 => Atu64(self.0).load(offset, order).try_into().unwrap(),
                AtomicKind::I8 => Ati8(self.0).load(offset, order).into(),
                AtomicKind::U8 => Atu8(self.0).load(offset, order).into(),
                AtomicKind::I16 => Ati16(self.0).load(offset, order).into(),
                AtomicKind::U16 => Atu16(self.0).load(offset, order).into(),
            }
        }
    }

    /// Stores a value at the specified index of the array. Returns the value.
    pub fn store(&self, offset: usize, kind: AtomicKind, val: i64, order: AtomicOrdering) {
        unsafe {
            match kind {
                AtomicKind::I32 => Ati32(self.0).store(offset, val.try_into().unwrap(), order),
                AtomicKind::U32 => Atu32(self.0).store(offset, val.try_into().unwrap(), order),
                AtomicKind::I64 => Ati64(self.0).store(offset, val, order),
                AtomicKind::U64 => Atu64(self.0).store(offset, val.try_into().unwrap(), order),
                AtomicKind::I8 => Ati8(self.0).store(offset, val.try_into().unwrap(), order),
                AtomicKind::U8 => Atu8(self.0).store(offset, val.try_into().unwrap(), order),
                AtomicKind::I16 => Ati16(self.0).store(offset, val.try_into().unwrap(), order),
                AtomicKind::U16 => Atu16(self.0).store(offset, val.try_into().unwrap(), order),
            }
        }
    }

    /// Stores a value at the specified index of the array. Returns the old value.
    pub fn swap(&self, offset: usize, kind: AtomicKind, val: i64, order: AtomicOrdering) -> i64 {
        unsafe {
            match kind {
                AtomicKind::I32 => Ati32(self.0)
                    .swap(offset, val.try_into().unwrap(), order)
                    .into(),
                AtomicKind::U32 => Atu32(self.0)
                    .swap(offset, val.try_into().unwrap(), order)
                    .into(),
                AtomicKind::I64 => Ati64(self.0).swap(offset, val, order),
                AtomicKind::U64 => Atu64(self.0)
                    .swap(offset, val.try_into().unwrap(), order)
                    .try_into()
                    .unwrap(),
                AtomicKind::I8 => Ati8(self.0)
                    .swap(offset, val.try_into().unwrap(), order)
                    .into(),
                AtomicKind::U8 => Atu8(self.0)
                    .swap(offset, val.try_into().unwrap(), order)
                    .into(),
                AtomicKind::I16 => Ati16(self.0)
                    .swap(offset, val.try_into().unwrap(), order)
                    .into(),
                AtomicKind::U16 => Atu16(self.0)
                    .swap(offset, val.try_into().unwrap(), order)
                    .into(),
            }
        }
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
        unsafe {
            match kind {
                AtomicKind::I32 => Ati32(self.0)
                    .compare_exchange(
                        offset,
                        current.try_into().unwrap(),
                        new_value.try_into().unwrap(),
                        success,
                        failure,
                    )
                    .into(),
                AtomicKind::U32 => Atu32(self.0)
                    .compare_exchange(
                        offset,
                        current.try_into().unwrap(),
                        new_value.try_into().unwrap(),
                        success,
                        failure,
                    )
                    .into(),
                AtomicKind::I64 => Ati64(self.0)
                    .compare_exchange(offset, current, new_value, success, failure)
                    .into(),
                AtomicKind::U64 => Atu64(self.0)
                    .compare_exchange(
                        offset,
                        current.try_into().unwrap(),
                        new_value.try_into().unwrap(),
                        success,
                        failure,
                    )
                    .into(),
                AtomicKind::I8 => Ati8(self.0)
                    .compare_exchange(
                        offset,
                        current.try_into().unwrap(),
                        new_value.try_into().unwrap(),
                        success,
                        failure,
                    )
                    .into(),
                AtomicKind::U8 => Atu8(self.0)
                    .compare_exchange(
                        offset,
                        current.try_into().unwrap(),
                        new_value.try_into().unwrap(),
                        success,
                        failure,
                    )
                    .into(),
                AtomicKind::I16 => Ati16(self.0)
                    .compare_exchange(
                        offset,
                        current.try_into().unwrap(),
                        new_value.try_into().unwrap(),
                        success,
                        failure,
                    )
                    .into(),
                AtomicKind::U16 => Atu16(self.0)
                    .compare_exchange(
                        offset,
                        current.try_into().unwrap(),
                        new_value.try_into().unwrap(),
                        success,
                        failure,
                    )
                    .into(),
            }
        }
    }

    /// Subtracts a value at the specified index of the array. Returns the old value at that index.
    pub fn sub(&self, offset: usize, kind: AtomicKind, val: i64, order: AtomicOrdering) -> i64 {
        unsafe {
            match kind {
                AtomicKind::I32 => Ati32(self.0)
                    .sub(offset, val.try_into().unwrap(), order)
                    .into(),
                AtomicKind::U32 => Atu32(self.0)
                    .sub(offset, val.try_into().unwrap(), order)
                    .into(),
                AtomicKind::I64 => Ati64(self.0).sub(offset, val, order),
                AtomicKind::U64 => Atu64(self.0)
                    .sub(offset, val.try_into().unwrap(), order)
                    .try_into()
                    .unwrap(),
                AtomicKind::I8 => Ati8(self.0)
                    .sub(offset, val.try_into().unwrap(), order)
                    .into(),
                AtomicKind::U8 => Atu8(self.0)
                    .sub(offset, val.try_into().unwrap(), order)
                    .into(),
                AtomicKind::I16 => Ati16(self.0)
                    .sub(offset, val.try_into().unwrap(), order)
                    .into(),
                AtomicKind::U16 => Atu16(self.0)
                    .sub(offset, val.try_into().unwrap(), order)
                    .into(),
            }
        }
    }

    /// Computes a bitwise AND on the value at the specified index of the array with the provided value. Returns the old value at that index.
    pub fn and(&self, offset: usize, kind: AtomicKind, val: i64, order: AtomicOrdering) -> i64 {
        unsafe {
            match kind {
                AtomicKind::I32 => Ati32(self.0)
                    .and(offset, val.try_into().unwrap(), order)
                    .into(),
                AtomicKind::U32 => Atu32(self.0)
                    .and(offset, val.try_into().unwrap(), order)
                    .into(),
                AtomicKind::I64 => Ati64(self.0).and(offset, val, order),
                AtomicKind::U64 => Atu64(self.0)
                    .and(offset, val.try_into().unwrap(), order)
                    .try_into()
                    .unwrap(),
                AtomicKind::I8 => Ati8(self.0)
                    .and(offset, val.try_into().unwrap(), order)
                    .into(),
                AtomicKind::U8 => Atu8(self.0)
                    .and(offset, val.try_into().unwrap(), order)
                    .into(),
                AtomicKind::I16 => Ati16(self.0)
                    .and(offset, val.try_into().unwrap(), order)
                    .into(),
                AtomicKind::U16 => Atu16(self.0)
                    .and(offset, val.try_into().unwrap(), order)
                    .into(),
            }
        }
    }

    /// Computes a bitwise OR on the value at the specified index of the array with the provided value. Returns the old value at that index.
    pub fn or(&self, offset: usize, kind: AtomicKind, val: i64, order: AtomicOrdering) -> i64 {
        unsafe {
            match kind {
                AtomicKind::I32 => Ati32(self.0)
                    .or(offset, val.try_into().unwrap(), order)
                    .into(),
                AtomicKind::U32 => Atu32(self.0)
                    .or(offset, val.try_into().unwrap(), order)
                    .into(),
                AtomicKind::I64 => Ati64(self.0).or(offset, val, order),
                AtomicKind::U64 => Atu64(self.0)
                    .or(offset, val.try_into().unwrap(), order)
                    .try_into()
                    .unwrap(),
                AtomicKind::I8 => Ati8(self.0)
                    .or(offset, val.try_into().unwrap(), order)
                    .into(),
                AtomicKind::U8 => Atu8(self.0)
                    .or(offset, val.try_into().unwrap(), order)
                    .into(),
                AtomicKind::I16 => Ati16(self.0)
                    .or(offset, val.try_into().unwrap(), order)
                    .into(),
                AtomicKind::U16 => Atu16(self.0)
                    .or(offset, val.try_into().unwrap(), order)
                    .into(),
            }
        }
    }

    /// Computes a bitwise XOR on the value at the specified index of the array with the provided value. Returns the old value at that index.
    pub fn xor(&self, offset: usize, kind: AtomicKind, val: i64, order: AtomicOrdering) -> i64 {
        unsafe {
            match kind {
                AtomicKind::I32 => Ati32(self.0)
                    .xor(offset, val.try_into().unwrap(), order)
                    .into(),
                AtomicKind::U32 => Atu32(self.0)
                    .xor(offset, val.try_into().unwrap(), order)
                    .into(),
                AtomicKind::I64 => Ati64(self.0).xor(offset, val, order),
                AtomicKind::U64 => Atu64(self.0)
                    .xor(offset, val.try_into().unwrap(), order)
                    .try_into()
                    .unwrap(),
                AtomicKind::I8 => Ati8(self.0)
                    .xor(offset, val.try_into().unwrap(), order)
                    .into(),
                AtomicKind::U8 => Atu8(self.0)
                    .xor(offset, val.try_into().unwrap(), order)
                    .into(),
                AtomicKind::I16 => Ati16(self.0)
                    .xor(offset, val.try_into().unwrap(), order)
                    .into(),
                AtomicKind::U16 => Atu16(self.0)
                    .xor(offset, val.try_into().unwrap(), order)
                    .into(),
            }
        }
    }
}

impl<T: Num> From<std::result::Result<T, T>> for CompareExchangeResult {
    fn from(result: std::result::Result<T, T>) -> Self {
        Self {
            success: result.is_ok(),
            value: if let std::result::Result::Ok(result) = result {
                result.to_i64()
            } else {
                result.unwrap_err().to_i64()
            },
        }
    }
}

trait Num: std::fmt::Debug {
    fn to_i64(self) -> i64;
}

impl Num for i32 {
    fn to_i64(self) -> i64 {
        self as i64
    }
}

impl Num for u32 {
    fn to_i64(self) -> i64 {
        self as i64
    }
}

impl Num for i8 {
    fn to_i64(self) -> i64 {
        self as i64
    }
}

impl Num for u8 {
    fn to_i64(self) -> i64 {
        self as i64
    }
}

impl Num for i16 {
    fn to_i64(self) -> i64 {
        self as i64
    }
}

impl Num for u16 {
    fn to_i64(self) -> i64 {
        self as i64
    }
}

impl Num for i64 {
    fn to_i64(self) -> i64 {
        self
    }
}

impl Num for u64 {
    fn to_i64(self) -> i64 {
        self as i64
    }
}
