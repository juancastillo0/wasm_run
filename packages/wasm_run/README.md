# wasm_run

A Web Assembly executor for the Dart programming language.

Currently it uses the [`wasmtime 41.0`](https://github.com/bytecodealliance/wasmtime) or [`wasmi 1.0`](https://github.com/paritytech/wasmi) Rust crates for parsing and executing WASM modules. Bindings are created using [`package:flutter_rust_bridge`](https://github.com/fzyzcjy/flutter_rust_bridge).

For more information on usage and documentation, please visit the main repository: https://github.com/juancastillo0/wasm_run.

## Runtime Features

### wasmtime 41.0.1 (default)

High-performance JIT compiler with comprehensive WebAssembly support:

| Feature | Status | Description |
|---------|--------|-------------|
| SIMD | Default | 128-bit vector operations |
| Threads | Optional | Shared memory and atomics |
| GC | Optional | Garbage collection (anyref, structref, arrayref) |
| Tail Call | Default | Tail call optimization |
| Multi-Memory | Optional | Multiple memories per module |
| Memory64 | Optional | 64-bit memory addresses |
| Exceptions | Optional | Exception handling |
| Component Model | Optional | WASI Preview2 support |

### wasmi 1.0.7

Pure interpreter for platforms without JIT support:

| Feature | Status | Description |
|---------|--------|-------------|
| SIMD | Supported | New in wasmi 1.0 |
| Relaxed SIMD | Supported | New in wasmi 1.0 |
| Multi-Memory | Supported | New in wasmi 1.0 |
| Memory64 | Supported | New in wasmi 1.0 |
| Tail Call | Supported | |
| Threads | Not supported | Use wasmtime for threads |
| GC | Not supported | Use wasmtime for GC |

## WASI Support

- **Preview1**: All core WebAssembly modules (Rust wasm32-wasi, C/C++ wasi-sdk, Go, etc.)
- **Preview2**: WebAssembly Components (experimental, use `compile_component()`)

# Pure Dart (Native)

For pure Dart application (backend or cli, for example), you may download the compiled dynamic libraries for each platform and specify the `ffi.DynamicLibrary` in the `WasmRunLibrary.set` function or execute the [script](./packages/wasm_run/bin/setup.dart) `dart run wasm_run:setup` (or the function `WasmRunLibrary.setUp`) to download the right library for your current platform and configure it so that you don't need to call `WasmRunLibrary.set` manually. The compiled libraries can be found in the [releases assets](https://github.com/juancastillo0/wasm_run/releases) of this repository.

# Flutter

When using it in a Flutter project you should use [`package:wasm_run_flutter`](https://pub.dev/packages/wasm_run_flutter) instead, since it will provide the right binaries for your platform.

# Dart Web (Not Flutter Web)

We use the [wasm-feature-detect JavaScript library](https://github.com/GoogleChromeLabs/wasm-feature-detect) for feature detection in the browser. To use this functionality in Dart web applications you will need to add the following script to your html (not necessary for Flutter):

```html
<script src="./packages/wasm_run/assets/wasm-feature-detect.js"></script>
<script type="module" src="./packages/wasm_run/assets/browser_wasi_shim.js"></script>
```


