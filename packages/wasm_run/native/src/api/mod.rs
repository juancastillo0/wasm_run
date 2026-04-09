// Flutter Rust Bridge v2 API module
// Conditionally compiles either wasmtime or wasmi backend

#[cfg(feature = "wasmtime")]
pub mod wasmtime;

#[cfg(not(feature = "wasmtime"))]
pub mod wasmi;

// Re-export the selected implementation
#[cfg(feature = "wasmtime")]
pub use wasmtime::*;

#[cfg(not(feature = "wasmtime"))]
pub use wasmi::*;
