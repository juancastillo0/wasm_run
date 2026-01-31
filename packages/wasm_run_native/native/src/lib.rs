// Flutter Rust Bridge v2 library structure
// The api module contains the public API for Dart FFI

// Public API module (contains wasmtime or wasmi implementation)
pub mod api;

// Supporting modules
pub mod config;
pub mod errors;
pub mod external;
pub mod types;

#[allow(dead_code)]
mod atomics;

// FRB v2 generated module - will be created by codegen
mod frb_generated;
