/// Native WebAssembly runtime library for wasm_run.
///
/// This package provides the native library bindings built from Rust using
/// wasmtime or wasmi. It is automatically built via Cargokit during the
/// Flutter build process.
///
/// You generally don't need to use this package directly - instead use
/// `package:wasm_run` or `package:wasm_run_flutter`.
library wasm_run_native;

// This package only provides native libraries - no Dart code needed.
// The FFI bindings are in package:wasm_run.
