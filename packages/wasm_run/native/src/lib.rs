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

// Re-export types used by frb_generated
pub use external::{WFunc, WGlobal, WMemory, WTable};
pub use types::*;
pub use config::*;
pub use api::*;
