use crate::bridge_generated::{new_list_value_2_0, wire_list_value_2, Wire2Api};
use anyhow::Result;
use flutter_rust_bridge::{
    opaque_dyn, support::new_leak_box_ptr, DartAbi, DartSafe, IntoDart, RustOpaque, StreamSink,
    SyncReturn,
};
use once_cell::sync::Lazy;
use std::{convert::TryInto, ffi::c_void, fmt::Debug, sync::Mutex};
use wasmi::*;

// TODO: use Map
static ARRAY: Lazy<Mutex<Vec<WasmiModuleImpl>>> = Lazy::new(|| Mutex::new(vec![]));

struct WasmiModuleImpl {
    module: Module,
    instance: Instance,
    store: Store<u32>,
    builder: Option<WasmiModuleBuilder>,
}

impl std::panic::RefUnwindSafe for WasmiModuleImpl {}
impl std::panic::UnwindSafe for WasmiModuleImpl {}

pub struct WasmiModuleId(pub usize);

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
    fn to_value(&self, ctx: &mut Store<u32>) -> Value {
        match self {
            Value2::I32(i) => Value::I32(*i),
            Value2::I64(i) => Value::I64(*i),
            Value2::F32(i) => Value::F32(i.to_bits().into()),
            Value2::F64(i) => Value::F64(i.to_bits().into()),
            Value2::FuncRef(i) => Value::FuncRef(
                Func::wrap(ctx, |caller: Caller<'_, u32>, param: i32| {
                    println!("Got {param} from WebAssembly");
                    println!("My host state is: {}", caller.data());
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
    pub fn call_function(&self, name: String) -> Result<Vec<Value2>> {
        ARRAY.lock().unwrap()[self.0].call_function(name)
    }
    pub fn call_function_with_args(&self, name: String, args: Vec<Value2>) -> Result<Vec<Value2>> {
        ARRAY.lock().unwrap()[self.0].call_function_with_args(name, args)
    }
    pub fn get_exports(&self) -> Vec<String> {
        ARRAY.lock().unwrap()[self.0].get_exports()
    }
    pub fn get_module_exports(&self) -> Vec<String> {
        ARRAY.lock().unwrap()[self.0].get_module_exports()
    }
    pub fn executions(&self, sink: StreamSink<i32>) -> Result<()> {
        let mut arr = ARRAY.lock().unwrap();
        let value = &mut arr[self.0];
        if value.builder.is_some() {
            return Err(anyhow::anyhow!("Stream sink already set"));
        }
        value.builder = Some(WasmiModuleBuilder { sink });
        Ok(())
    }

    pub fn call_function_with_args_sync(
        &self,
        name: String,
        args: Vec<Value2>,
    ) -> Result<SyncReturn<Vec<Value2>>> {
        let mut arr = ARRAY.lock().unwrap();
        let value = &mut arr[self.0];

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

// pub enum Extern {
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

type ffF = unsafe extern "C" fn(args: i64) -> i64;

pub fn run_function(pointer: i64) -> SyncReturn<Vec<Value2>> {
    let f: ffF = unsafe { std::mem::transmute(pointer) };
    let result = unsafe { f(1) };
    SyncReturn(vec![Value2::I64(result)])
}

type wasm_func = unsafe extern "C" fn(args: *mut DartAbi) -> *mut wire_list_value_2;
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

pub fn compile_wasm(
    module_wasm: Vec<u8>,
    // sink: StreamSink<i32>
    // builder: WasmiModuleBuilder, // sink: StreamSink<int64>,
    // definitions: Map<Map<String, int64>>,
) -> Result<WasmiModuleId> {
    let engine = Engine::default();
    let module = Module::new(&engine, &mut &module_wasm[..])?;
    let linker = <Linker<HostState>>::new(&engine);

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
    // linker.define("host", "hello", host_hello)?;
    let instance = linker.instantiate(&mut store, &module)?.start(&mut store)?;
    let inner = WasmiModuleImpl {
        instance,
        module,
        store,
        builder: None,
    };
    let mut arr = ARRAY.lock().unwrap();
    arr.push(inner);

    Ok(WasmiModuleId(arr.len() - 1))
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
