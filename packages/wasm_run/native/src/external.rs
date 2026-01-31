use std::{
    fmt::Debug,
    panic::{RefUnwindSafe, UnwindSafe},
};

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
    pub inner: wasmi::Memory,
    #[cfg(feature = "wasmtime")]
    pub inner: wasmtime::Memory,
}

#[cfg(feature = "wasmtime")]
impl WMemory {
    pub fn as_wasmtime(&self) -> &wasmtime::Memory {
        &self.inner
    }
}

#[cfg(not(feature = "wasmtime"))]
impl WMemory {
    pub fn as_wasmi(&self) -> &wasmi::Memory {
        &self.inner
    }
}

#[cfg(feature = "wasmtime")]
impl From<wasmtime::Memory> for WMemory {
    fn from(memory: wasmtime::Memory) -> Self {
        Self { inner: memory }
    }
}

#[cfg(feature = "wasmtime")]
impl From<WMemory> for wasmtime::Memory {
    fn from(memory: WMemory) -> Self {
        memory.inner
    }
}

#[cfg(not(feature = "wasmtime"))]
impl From<wasmi::Memory> for WMemory {
    fn from(memory: wasmi::Memory) -> Self {
        Self { inner: memory }
    }
}

#[cfg(not(feature = "wasmtime"))]
impl From<WMemory> for wasmi::Memory {
    fn from(memory: WMemory) -> Self {
        memory.inner
    }
}

#[derive(Debug)]
pub struct WGlobal {
    #[cfg(not(feature = "wasmtime"))]
    pub inner: wasmi::Global,
    #[cfg(feature = "wasmtime")]
    pub inner: wasmtime::Global,
}

impl UnwindSafe for WGlobal {}
impl RefUnwindSafe for WGlobal {}

#[cfg(feature = "wasmtime")]
impl WGlobal {
    pub fn as_wasmtime(&self) -> &wasmtime::Global {
        &self.inner
    }
}

#[cfg(not(feature = "wasmtime"))]
impl WGlobal {
    pub fn as_wasmi(&self) -> &wasmi::Global {
        &self.inner
    }
}

#[cfg(feature = "wasmtime")]
impl From<wasmtime::Global> for WGlobal {
    fn from(global: wasmtime::Global) -> Self {
        Self { inner: global }
    }
}

#[cfg(feature = "wasmtime")]
impl From<WGlobal> for wasmtime::Global {
    fn from(global: WGlobal) -> Self {
        global.inner
    }
}

#[cfg(not(feature = "wasmtime"))]
impl From<wasmi::Global> for WGlobal {
    fn from(global: wasmi::Global) -> Self {
        Self { inner: global }
    }
}

#[cfg(not(feature = "wasmtime"))]
impl From<WGlobal> for wasmi::Global {
    fn from(global: WGlobal) -> Self {
        global.inner
    }
}

#[derive(Debug)]
pub struct WTable {
    #[cfg(not(feature = "wasmtime"))]
    pub inner: wasmi::Table,
    #[cfg(feature = "wasmtime")]
    pub inner: wasmtime::Table,
}

impl UnwindSafe for WTable {}
impl RefUnwindSafe for WTable {}

#[cfg(feature = "wasmtime")]
impl WTable {
    pub fn as_wasmtime(&self) -> &wasmtime::Table {
        &self.inner
    }
}

#[cfg(not(feature = "wasmtime"))]
impl WTable {
    pub fn as_wasmi(&self) -> &wasmi::Table {
        &self.inner
    }
}

#[cfg(feature = "wasmtime")]
impl From<wasmtime::Table> for WTable {
    fn from(table: wasmtime::Table) -> Self {
        Self { inner: table }
    }
}

#[cfg(feature = "wasmtime")]
impl From<WTable> for wasmtime::Table {
    fn from(table: WTable) -> Self {
        table.inner
    }
}

#[cfg(not(feature = "wasmtime"))]
impl From<wasmi::Table> for WTable {
    fn from(table: wasmi::Table) -> Self {
        Self { inner: table }
    }
}

#[cfg(not(feature = "wasmtime"))]
impl From<WTable> for wasmi::Table {
    fn from(table: WTable) -> Self {
        table.inner
    }
}

// GC Reference wrappers for wasmtime GC support

/// Wrapper for wasmtime's Rooted<AnyRef> (GC internal reference).
/// Represents anyref, eqref, structref, arrayref, and i31ref types.
#[cfg(feature = "wasmtime")]
#[derive(Debug)]
pub struct WAnyRef {
    pub inner: wasmtime::Rooted<wasmtime::AnyRef>,
}

#[cfg(feature = "wasmtime")]
impl UnwindSafe for WAnyRef {}
#[cfg(feature = "wasmtime")]
impl RefUnwindSafe for WAnyRef {}

#[cfg(feature = "wasmtime")]
impl Clone for WAnyRef {
    fn clone(&self) -> Self {
        Self {
            inner: self.inner.clone(),
        }
    }
}

/// Wrapper for wasmtime's Rooted<ExnRef> (exception reference).
#[cfg(feature = "wasmtime")]
#[derive(Debug)]
pub struct WExnRef {
    pub inner: wasmtime::Rooted<wasmtime::ExnRef>,
}

#[cfg(feature = "wasmtime")]
impl UnwindSafe for WExnRef {}
#[cfg(feature = "wasmtime")]
impl RefUnwindSafe for WExnRef {}

#[cfg(feature = "wasmtime")]
impl Clone for WExnRef {
    fn clone(&self) -> Self {
        Self {
            inner: self.inner.clone(),
        }
    }
}

// wasmi stubs for GC types (not supported in wasmi)

/// Stub for WAnyRef in wasmi (GC not supported)
#[cfg(not(feature = "wasmtime"))]
#[derive(Debug, Clone)]
pub struct WAnyRef {
    _private: (),
}

#[cfg(not(feature = "wasmtime"))]
impl UnwindSafe for WAnyRef {}
#[cfg(not(feature = "wasmtime"))]
impl RefUnwindSafe for WAnyRef {}

/// Stub for WExnRef in wasmi (exception handling not supported)
#[cfg(not(feature = "wasmtime"))]
#[derive(Debug, Clone)]
pub struct WExnRef {
    _private: (),
}

#[cfg(not(feature = "wasmtime"))]
impl UnwindSafe for WExnRef {}
#[cfg(not(feature = "wasmtime"))]
impl RefUnwindSafe for WExnRef {}

// Module wrapper for FRB compatibility

/// Wrapper for wasmtime::Module
#[cfg(feature = "wasmtime")]
#[derive(Debug)]
pub struct WModule {
    pub inner: wasmtime::Module,
}

#[cfg(feature = "wasmtime")]
impl UnwindSafe for WModule {}
#[cfg(feature = "wasmtime")]
impl RefUnwindSafe for WModule {}

#[cfg(feature = "wasmtime")]
impl WModule {
    pub fn as_wasmtime(&self) -> &wasmtime::Module {
        &self.inner
    }
}

#[cfg(feature = "wasmtime")]
impl From<wasmtime::Module> for WModule {
    fn from(module: wasmtime::Module) -> Self {
        Self { inner: module }
    }
}

#[cfg(feature = "wasmtime")]
impl From<WModule> for wasmtime::Module {
    fn from(module: WModule) -> Self {
        module.inner
    }
}

/// Stub for WModule in wasmi
#[cfg(not(feature = "wasmtime"))]
#[derive(Debug)]
pub struct WModule {
    pub inner: wasmi::Module,
}

#[cfg(not(feature = "wasmtime"))]
impl UnwindSafe for WModule {}
#[cfg(not(feature = "wasmtime"))]
impl RefUnwindSafe for WModule {}

#[cfg(not(feature = "wasmtime"))]
impl WModule {
    pub fn as_wasmi(&self) -> &wasmi::Module {
        &self.inner
    }
}

#[cfg(not(feature = "wasmtime"))]
impl From<wasmi::Module> for WModule {
    fn from(module: wasmi::Module) -> Self {
        Self { inner: module }
    }
}

#[cfg(not(feature = "wasmtime"))]
impl From<WModule> for wasmi::Module {
    fn from(module: WModule) -> Self {
        module.inner
    }
}

// SharedMemory wrapper for FRB compatibility (wasmtime only)

/// Wrapper for wasmtime::SharedMemory
#[cfg(feature = "wasmtime")]
#[derive(Debug)]
pub struct WSharedMemory {
    pub inner: wasmtime::SharedMemory,
}

#[cfg(feature = "wasmtime")]
impl UnwindSafe for WSharedMemory {}
#[cfg(feature = "wasmtime")]
impl RefUnwindSafe for WSharedMemory {}

#[cfg(feature = "wasmtime")]
impl Clone for WSharedMemory {
    fn clone(&self) -> Self {
        Self {
            inner: self.inner.clone(),
        }
    }
}

#[cfg(feature = "wasmtime")]
impl WSharedMemory {
    pub fn as_wasmtime(&self) -> &wasmtime::SharedMemory {
        &self.inner
    }
}

#[cfg(feature = "wasmtime")]
impl From<wasmtime::SharedMemory> for WSharedMemory {
    fn from(memory: wasmtime::SharedMemory) -> Self {
        Self { inner: memory }
    }
}

#[cfg(feature = "wasmtime")]
impl From<WSharedMemory> for wasmtime::SharedMemory {
    fn from(memory: WSharedMemory) -> Self {
        memory.inner
    }
}

/// Stub for WSharedMemory in wasmi (shared memory not supported)
#[cfg(not(feature = "wasmtime"))]
#[derive(Debug, Clone)]
pub struct WSharedMemory {
    _private: (),
}

#[cfg(not(feature = "wasmtime"))]
impl UnwindSafe for WSharedMemory {}
#[cfg(not(feature = "wasmtime"))]
impl RefUnwindSafe for WSharedMemory {}
