## 0.2.0

 - Upgrade to wasmtime 41.0.1 and wasmi 1.0.7
 - Native crate renamed to `wasm_run_native`
 - New WebAssembly features: GC, tail call, exceptions, component model (wasmtime)
 - New WebAssembly features: SIMD, relaxed SIMD, multi-memory, memory64 (wasmi)
 - WASI Preview2 support for WebAssembly Components
 - See wasm_run 0.2.0 changelog for full details

## 0.1.0

 - flutter_rust_bridge: ">=1.82.4"
 - Use Wasmi 0.31 and Wasmtime 14.0
 - `WasmRunLibrary`, `setUpDesktopDynamicLibrary`, `uriForPackage` and `getUriBodyBytes` utilities
 - (BREAKING) add `WasmInstanceBuilder.module` and `WasmInstanceBuilder.wasiOpenFile`
 - loadAssets with `rootBundle.load` from 'flutter/services.dart'
 - Clean build artifacts after installing
 
## 0.0.1+1

 - Fix web asset loading for Flutter web

## 0.0.1

 - Initial version 2023-05-22
