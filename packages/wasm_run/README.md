# wasm_run

A Web Assembly executor for the Dart programming language.

Currently it uses the [`wasmtime 14.0`](https://github.com/bytecodealliance/wasmtime) or [`wasmi 0.31`](https://github.com/paritytech/wasmi) Rust crates for parsing and executing WASM modules. Bindings are created using [`package:flutter_rust_bridge`](https://github.com/fzyzcjy/flutter_rust_bridge).

For more information on usage and documentation, please visit the main repository: https://github.com/juancastillo0/wasm_run.

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


