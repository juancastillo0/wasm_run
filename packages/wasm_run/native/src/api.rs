pub use crate::atomics::*;
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
use std::sync::mpsc::{self, Receiver, Sender};
pub use std::sync::{Mutex, RwLock};
use std::{cell::RefCell, collections::HashMap, fs, sync::Arc};
use wasi_common::pipe::WritePipe;
use wasmtime::*;
pub use wasmtime::{Func, Global, GlobalType, Memory, Module, SharedMemory, Table};

type Value = wasmtime::Val;
type ValueType = wasmtime::ValType;

static ARRAY: Lazy<RwLock<GlobalState>> = Lazy::new(|| RwLock::new(Default::default()));

thread_local!(static STORE: RefCell<Option<WasmiModuleImpl>> = RefCell::new(None));

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
        ValueType::V128 => Value::V128(0.into()),
        ValueType::ExternRef => Value::ExternRef(None),
        ValueType::FuncRef => Value::FuncRef(None),
    }
}

struct WasmiModuleImpl {
    module: Arc<Mutex<Module>>,
    linker: Linker<StoreState>,
    store: Store<StoreState>,
    instance: Option<Instance>,
    threads: Option<Arc<Mutex<Vec<Option<WasmiModuleImpl>>>>>,
    pool: Option<Arc<rayon::ThreadPool>>,
    channels: Option<Arc<Mutex<FunctionChannels>>>,
}

struct StoreState {
    wasi_ctx: Option<wasi_common::WasiCtx>,
    stdout: Option<StreamSink<Vec<u8>>>,
    stderr: Option<StreamSink<Vec<u8>>>,
    functions: HashMap<usize, HostFunction>,
    stack: CallStack,
    // TODO: add to stdin?
}

#[derive(Clone)]
struct HostFunction {
    function_pointer: usize,
    function_id: u32,
    param_types: Vec<ValueTy>,
    result_types: Vec<ValueTy>,
}

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
        let wasi = wasi_config.to_wasi_ctx()?;

        if !wasi_config.preopened_files.is_empty() {
            for value in &wasi_config.preopened_files {
                let file = fs::File::open(value)?;
                let wasm_file =
                    wasmtime_wasi::file::File::from_cap_std(cap_std::fs::File::from_std(file));
                wasi.push_file(
                    Box::new(wasm_file),
                    wasi_common::file::FileAccessMode::all(),
                )?;
            }
        }

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
    let guard = module.0.lock().unwrap();
    let engine = guard.engine();

    let mut arr = ARRAY.write().unwrap();
    arr.last_id += 1;

    let id = arr.last_id;

    let stack: CallStack = Default::default();
    let module_id = WasmRunModuleId(id, RustOpaque::new(stack.clone()));

    let mut linker = <Linker<StoreState>>::new(engine);
    let wasi_ctx = make_wasi_ctx(&module_id, &wasi_config)?;
    if wasi_ctx.is_some() {
        wasmtime_wasi::add_to_linker(&mut linker, |ctx| ctx.wasi_ctx.as_mut().unwrap())?;
    }

    let store = Store::new(
        engine,
        StoreState {
            wasi_ctx: wasi_ctx.clone(),
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
                if wasi_ctx.is_some() {
                    wasmtime_wasi::add_to_linker(&mut linker, |ctx| {
                        ctx.wasi_ctx.as_mut().unwrap()
                    })?;
                }
                Ok(Some(WasmiModuleImpl {
                    module: wasm_module.clone(),
                    linker,
                    store: Store::new(
                        engine,
                        StoreState {
                            wasi_ctx: wasi_ctx.clone(),
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

type WorkerSendRecv = Arc<Mutex<(usize, Sender<FunctionCall>, Receiver<Vec<Val>>)>>;

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
            .instantiate(&mut module.store, &module.module.lock().unwrap())?;

        module.instance = Some(instance);
        let threads = module.threads.take();
        if let Some(threads) = threads {
            let len = {
                let mut threads_i = threads.lock().unwrap();
                for thread in threads_i.iter_mut() {
                    let thread = thread.as_mut().unwrap();
                    let thread_instance = thread
                        .linker
                        .instantiate(&mut thread.store, &thread.module.lock().unwrap())?;
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
        let raw_id = unsafe { func.to_raw(&mut m.store) as usize };
        let hf = m.store.data().functions.get(&raw_id).unwrap();
        let ff = Self::_create_function(
            new_context,
            hf.clone(),
            Some(m.channels.as_ref().unwrap().lock().unwrap().workers[thread_index].clone()),
        )
        .unwrap()
        .0;
        ff
    }

    pub fn link_imports(&self, imports: Vec<ModuleImport>) -> Result<SyncReturn<()>> {
        let mut arr = ARRAY.write().unwrap();
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
                        ExternalValue::SharedMemory(m) => ExternalValue::SharedMemory(m.clone()),
                        ExternalValue::Global(g) => {
                            let ty = g.ty(&m.store);
                            let v = match g.get(&mut m.store) {
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
                            ExternalValue::Global(RustOpaque::new(global))
                        }
                        ExternalValue::Memory(mem) => {
                            let ty = mem.ty(&m.store);
                            // TODO: should we copy the memory contents?
                            let memory = Memory::new(&mut thread.store, ty)?;
                            ExternalValue::Memory(RustOpaque::new(memory))
                        }
                        ExternalValue::Table(t) => {
                            let ty = t.ty(&m.store);
                            let fill_value = if t.size(&m.store) > 0 {
                                let v = t.get(&mut m.store, 0);
                                if let Some(Val::FuncRef(Some(v))) = v {
                                    let ff = Self::map_function(
                                        m,
                                        &v,
                                        thread_index,
                                        thread.store.as_context_mut(),
                                    );
                                    Some(Val::FuncRef(Some(ff.func_wasmtime)))
                                } else {
                                    v
                                }
                            } else {
                                None
                            };
                            let v = fill_value.unwrap_or_else(|| default_val(&ty.element()));
                            let table = Table::new(&mut thread.store, ty, v)?;
                            ExternalValue::Table(RustOpaque::new(table))
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

    pub fn call_function_handle_parallel(
        &self,
        func_name: String,
        args: Vec<WasmVal>,
        num_tasks: usize,
        function_stream: StreamSink<ParallelExec>,
    ) {
        use rayon::prelude::*;

        let (num_params, result_types, pool, channels) = {
            let mut m = ARRAY.write().unwrap();
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
                function_stream.add(ParallelExec::Err(format!(
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
            let args: Vec<Value> = args.into_iter().map(|v| v.to_val()).collect();

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

                                let mut outputs: Vec<Value> =
                                    result_types.iter().map(default_val).collect();
                                let func = m
                                    .instance
                                    .unwrap()
                                    .get_func(&mut m.store, &func_name)
                                    .unwrap();
                                func.call(&mut m.store, inputs, &mut outputs)?;
                                Ok(outputs
                                    .into_iter()
                                    .map(WasmVal::from_val)
                                    .collect::<Vec<WasmVal>>())
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
                    function_stream.add(ParallelExec::Ok(req.args));
                    return;
                }
                function_stream.add(ParallelExec::Call(req));
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
            function_stream.add(ParallelExec::Err(
                "Instance has no thread pool configured".to_string(),
            ));
        }
    }

    pub fn worker_execution(
        &self,
        worker_index: usize,
        results: Vec<WasmVal>,
    ) -> Result<SyncReturn<()>> {
        let m = ARRAY.read().unwrap();
        let module = m.map.get(&self.0).unwrap();
        let worker = &module
            .channels
            .as_ref()
            .unwrap()
            .lock()
            .unwrap()
            .workers_out[worker_index];

        worker.send(results.into_iter().map(|v| v.to_val()).collect())?;
        Ok(SyncReturn(()))
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
    ) -> Result<SyncReturn<RustOpaque<WFunc>>> {
        let f: WasmFunction = unsafe { std::mem::transmute(hf.function_pointer) };
        let func = Func::new(
            store.as_context_mut(),
            FuncType::new(
                hf.param_types.iter().cloned().map(ValueType::from),
                hf.result_types.iter().cloned().map(ValueType::from),
            ),
            move |mut caller, params, results| {
                let mapped: Vec<WasmVal> = params
                    .iter()
                    .map(|a| WasmVal::from_val(a.clone()))
                    .collect();
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
                    f,
                    hf.function_id,
                    results,
                )?;
                Ok(())
            },
        );
        let raw_id = unsafe { func.to_raw(&mut store) as usize };
        store.data_mut().functions.insert(raw_id, hf);
        Ok(SyncReturn(RustOpaque::new(func.into())))
    }

    fn execute_function(
        caller: StoreContextMut<'_, StoreState>,
        mapped: Vec<WasmVal>,
        f: WasmFunction,
        function_id: u32,
        results: &mut [Val],
    ) -> Result<()> {
        let inputs = vec![mapped].into_dart();
        let stack = {
            let stack = caller.data().stack.clone();
            let v = RwLock::new(unsafe { std::mem::transmute(caller) });
            stack.0.write().unwrap().push(v);
            stack
        };

        let output: Vec<WasmVal> = unsafe {
            let pointer = new_leak_box_ptr(inputs);
            let result = f(function_id, pointer);
            pointer.drop_in_place();
            result.wire2api()
        };
        // TODO: use Drop for this
        let last_caller = stack.0.write().unwrap().pop();

        if output.len() != results.len() {
            return Err(anyhow::anyhow!("Invalid output length"));
        } else if last_caller.is_none() {
            return Err(anyhow::anyhow!("CALLER_STACK is empty"));
        } else if output.is_empty() {
            return Ok(());
        }
        // let last_caller = last_caller.unwrap();
        // let mut caller = last_caller.write().unwrap();
        let mut outputs = output.into_iter();
        for value in results {
            *value = outputs.next().unwrap().to_val();
        }
        Ok(())
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
            let mapped = value.to_val();
            let global = Global::new(
                &mut store,
                GlobalType::new(
                    mapped.ty(),
                    if mutable {
                        Mutability::Var
                    } else {
                        Mutability::Const
                    },
                ),
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
    pub fn get_memory_data_pointer(&self, memory: RustOpaque<Memory>) -> SyncReturn<usize> {
        SyncReturn(self.with_module(|store| memory.data_ptr(store) as usize))
    }
    pub fn get_memory_data_pointer_and_length(
        &self,
        memory: RustOpaque<Memory>,
    ) -> SyncReturn<PointerAndLength> {
        SyncReturn(self.with_module(|store| PointerAndLength {
            pointer: memory.data_ptr(store) as usize,
            length: memory.data_size(store),
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

    // FUEL
    //

    pub fn add_fuel(&self, delta: u64) -> Result<SyncReturn<()>> {
        self.with_module_mut(|mut store| store.add_fuel(delta).map(SyncReturn))
    }
    pub fn fuel_consumed(&self) -> SyncReturn<Option<u64>> {
        self.with_module_mut(|store| SyncReturn(store.fuel_consumed()))
    }
    pub fn consume_fuel(&self, delta: u64) -> Result<SyncReturn<u64>> {
        self.with_module_mut(|mut store| store.consume_fuel(delta).map(SyncReturn))
    }
}

pub fn parse_wat_format(wat: String) -> Result<Vec<u8>> {
    Ok(wat::parse_str(wat)?)
}

type WasmFunction =
    unsafe extern "C" fn(function_id: u32, args: *mut DartAbi) -> *mut wire_list_wasm_val;

pub struct CompiledModule(pub RustOpaque<Arc<std::sync::Mutex<Module>>>);

impl CompiledModule {
    pub fn create_shared_memory(
        &self,
        memory_type: MemoryTy,
    ) -> Result<SyncReturn<WasmRunSharedMemory>> {
        let module = self.0.lock().unwrap();
        let memory = SharedMemory::new(module.engine(), memory_type.to_memory_type()?)?;
        Ok(SyncReturn(memory.into()))
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

pub fn wasm_features_for_config(config: ModuleConfig) -> SyncReturn<WasmFeatures> {
    SyncReturn(config.wasm_features())
}

pub fn wasm_runtime_features() -> SyncReturn<WasmRuntimeFeatures> {
    SyncReturn(WasmRuntimeFeatures::default())
}

#[derive(Debug, Clone)]
pub struct WasmRunSharedMemory(pub RustOpaque<Arc<RwLock<SharedMemory>>>);

impl From<SharedMemory> for WasmRunSharedMemory {
    fn from(memory: SharedMemory) -> Self {
        WasmRunSharedMemory(RustOpaque::new(Arc::new(RwLock::new(memory))))
    }
}

impl WasmRunSharedMemory {
    pub fn ty(&self) -> SyncReturn<MemoryTy> {
        SyncReturn((&self.0.read().unwrap().ty()).into())
    }
    pub fn size(&self) -> SyncReturn<u64> {
        SyncReturn(self.0.read().unwrap().size())
    }
    pub fn data_size(&self) -> SyncReturn<usize> {
        SyncReturn(self.0.read().unwrap().data_size())
    }
    pub fn data_pointer(&self) -> SyncReturn<usize> {
        SyncReturn(self.0.read().unwrap().data().as_ptr() as usize)
    }
    pub fn grow(&self, delta: u64) -> Result<SyncReturn<u64>> {
        Ok(SyncReturn(self.0.read().unwrap().grow(delta)?))
    }
    // pub fn atomic_i8(&self) -> crate::atomics::Ati8 {
    //     crate::atomics::Ati8(self.0.read().unwrap().data().as_ptr() as usize)
    // }

    pub fn atomics(&self) -> Atomics {
        Atomics(self.0.read().unwrap().data().as_ptr() as usize)
    }
    pub fn atomic_notify(&self, addr: u64, count: u32) -> Result<SyncReturn<u32>> {
        Ok(SyncReturn(
            self.0.read().unwrap().atomic_notify(addr, count)?,
        ))
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
        Ok(SyncReturn(
            self.0
                .read()
                .unwrap()
                .atomic_wait32(addr, expected, None)?
                .into(),
        ))
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
        Ok(SyncReturn(
            self.0
                .read()
                .unwrap()
                .atomic_wait64(addr, expected, None)?
                .into(),
        ))
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
