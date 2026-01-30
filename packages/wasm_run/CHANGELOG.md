## 0.2.0

### Major Upgrade: wasmtime 41.0.1, wasmi 1.0.7

**Runtime Updates:**
- Upgrade wasmtime from 14.0.4 to 41.0.1
- Upgrade wasmi from 0.31.0 to 1.0.7
- Rename native crate from `wasm_run_dart` to `wasm_run_native`

**New WebAssembly Features (wasmtime):**
- Tail call optimization (now default enabled)
- Garbage Collection (GC) support - anyref, structref, arrayref, i31ref
- Exception handling support
- Function references proposal
- Component Model support (WASI Preview2)

**New WebAssembly Features (wasmi 1.0):**
- SIMD support (128-bit vector operations)
- Relaxed SIMD support
- Multi-memory support
- Memory64 support
- Note: wasmi 1.0 API migration pending - use wasmtime-runtime for now

**WASI Updates:**
- WASI Preview1 support for core modules (all current toolchains)
- WASI Preview2 support for WebAssembly Components (experimental)
- New `detect_wasm_kind()` function to identify module vs component
- New `compile_component()` / `compile_component_sync()` for components

**New Configuration Options:**
- `wasm_tail_call` - Enable/disable tail call optimization
- `wasm_gc` - Enable WebAssembly GC proposal
- `wasm_function_references` - Enable typed function references
- `wasm_exceptions` - Enable exception handling
- `wasm_component_model` - Enable Component Model

**API Changes:**
- Table operations now use `u64` internally (API remains `u32` for compatibility)
- Fuel API updated: `set_fuel`/`get_fuel` replace `add_fuel`/`consume_fuel`
- `FuncType::new` now requires `Engine` parameter
- ExternRef uses `Rooted<ExternRef>` for GC-managed references

**Improved Error Messages:**
- Detailed error messages for wasmi limitations (threads, GC, atomics)
- Clear guidance on when to use wasmtime vs wasmi

## 0.1.0+2

 - [FIX] Use lowercase String comparison for Safari WASM functions. [PR](https://github.com/juancastillo0/wasm_run/pull/57) thanks to [michelerenzullo](https://github.com/michelerenzullo)
 
## 0.1.0+1

 - Expose `wasm_run:setup` CLI

## 0.1.0

 - flutter_rust_bridge: ">=1.82.4"
 - Use Wasmi 0.31 and Wasmtime 14.0
 - `WasmRunLibrary`, `setUpDesktopDynamicLibrary`, `uriForPackage` and `getUriBodyBytes` utilities
 - [BREAKING] add `WasmInstanceBuilder.module` and `WasmInstanceBuilder.wasiOpenFile`
 - loadAssets with `rootBundle.load` from 'flutter/services.dart'

## 0.0.1+3

 - Expose `wasm_run:setup` CLI

## 0.0.1+2

 - Restrict flutter_rust_bridge: ">=1.72.2 <1.80.0" due to breaking change
 - Improve `undefined` (empty) returns in wasm functions in web for Dart 3

## 0.0.1+1

 - Fix web asset loading for Flutter web

## 0.0.1

 - Initial version 2023-05-22

