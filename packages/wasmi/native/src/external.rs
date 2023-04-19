use std::any::Any;

#[derive(Debug)]
pub struct WFunc {
    #[cfg(not(feature = "wasmtime"))]
    pub func_wasmi: wasmi::Func,
    #[cfg(feature = "wasmtime")]
    pub func_wasmtime: wasmtime::Func,
}

#[cfg(feature = "wasmtime")]
impl From<wasmtime::Func> for WFunc {
    fn from(func: wasmtime::Func) -> Self {
        Self {
            func_wasmtime: func,
        }
    }
}

#[cfg(feature = "wasmtime")]
impl From<WFunc> for wasmtime::Func {
    fn from(func: WFunc) -> Self {
        func.func_wasmtime
    }
}

#[cfg(not(feature = "wasmtime"))]
impl From<wasmi::Func> for WFunc {
    fn from(func: wasmi::Func) -> Self {
        Self { func_wasmi: func }
    }
}

#[cfg(not(feature = "wasmtime"))]
impl From<WFunc> for wasmi::Func {
    fn from(func: WFunc) -> Self {
        func.func_wasmi
    }
}

#[derive(Debug)]
pub struct WMemory {
    #[cfg(not(feature = "wasmtime"))]
    pub func_wasmi: wasmi::Memory,
    #[cfg(feature = "wasmtime")]
    pub func_wasmtime: wasmtime::Memory,
}

#[cfg(feature = "wasmtime")]
impl From<wasmtime::Memory> for WMemory {
    fn from(func: wasmtime::Memory) -> Self {
        Self {
            func_wasmtime: func,
        }
    }
}

#[cfg(feature = "wasmtime")]
impl From<WMemory> for wasmtime::Memory {
    fn from(func: WMemory) -> Self {
        func.func_wasmtime
    }
}

#[cfg(not(feature = "wasmtime"))]
impl From<wasmi::Memory> for WMemory {
    fn from(func: wasmi::Memory) -> Self {
        Self { func_wasmi: func }
    }
}

#[cfg(not(feature = "wasmtime"))]
impl From<WMemory> for wasmi::Memory {
    fn from(func: WMemory) -> Self {
        func.func_wasmi
    }
}

#[derive(Debug)]
pub struct WGlobal(Box<dyn Any>);

#[cfg(feature = "wasmtime")]
impl From<wasmtime::Global> for WGlobal {
    fn from(func: wasmtime::Global) -> Self {
        Self(Box::new(func))
    }
}

#[cfg(feature = "wasmtime")]
impl From<WGlobal> for wasmtime::Global {
    fn from(func: WGlobal) -> Self {
        *func.0.downcast::<wasmtime::Global>().unwrap()
    }
}

#[cfg(not(feature = "wasmtime"))]
impl From<wasmi::Global> for WGlobal {
    fn from(func: wasmi::Global) -> Self {
        Self(Box::new(func))
    }
}

#[cfg(not(feature = "wasmtime"))]
impl From<WGlobal> for wasmi::Global {
    fn from(func: WGlobal) -> Self {
        func.0.downcast::<wasmtime::Global>().unwrap()
    }
}

#[derive(Debug)]
pub struct WTable(Box<dyn Any>);

#[cfg(feature = "wasmtime")]
impl From<wasmtime::Table> for WTable {
    fn from(func: wasmtime::Table) -> Self {
        Self(Box::new(func))
    }
}

#[cfg(feature = "wasmtime")]
impl From<WTable> for wasmtime::Table {
    fn from(func: WTable) -> Self {
        *func.0.downcast::<wasmtime::Table>().unwrap()
    }
}

#[cfg(not(feature = "wasmtime"))]
impl From<wasmi::Table> for WTable {
    fn from(func: wasmi::Table) -> Self {
        Self(Box::new(func))
    }
}

#[cfg(not(feature = "wasmtime"))]
impl From<WTable> for wasmi::Table {
    fn from(func: WTable) -> Self {
        func.0.downcast::<wasmtime::Table>().unwrap()
    }
}
