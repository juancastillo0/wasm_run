// Select the appropriate API implementation based on runtime
#[cfg(feature = "wasmtime")]
mod api;

// NOTE: wasmi 1.0 support requires updates to api_wasmi.rs
// The wasmi API changed significantly (core module is now private,
// wasi_common is now wasmi_wasi, etc.). Use wasmtime-runtime for now.
// TODO: Update api_wasmi.rs for wasmi 1.0 compatibility
#[cfg(not(feature = "wasmtime"))]
#[path = "api_wasmi.rs"]
mod api;

mod bridge_generated;
mod config;
pub mod errors;
mod external;
#[allow(dead_code)]
mod atomics;
mod types;
