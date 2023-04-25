# wasmi

A Web Assembly executor for the Dart programming language. Currently it uses the [`wasmtime 8.0`](https://github.com/bytecodealliance/wasmtime) or [`wasmi 0.29`](https://github.com/paritytech/wasmi) Rust crates for parsing and executing WASM modules. Bindings are created using [`package:flutter_rust_bridge`](https://github.com/fzyzcjy/flutter_rust_bridge).

For more information on usage and documentation, please visit the main repository: https://github.com/juancastillo0/wasm_interpreter.

# Pure Dart (Native)

To use this library directly in pure Dart you will need to provide the `DynamicLibrary` using the `setDynamicLibrary` function. When building a pure Dart application (backend or cli, for example), you must call `setDynamicLibrary(<nativeLibraryForYourPlatform>)` before using the package. The `<nativeLibraryForYourPlatform>` is a `package:ffi`'s `DynamicLibrary` whose file can be downloaded from the [releases of the Github repository](https://github.com/juancastillo0/wasm_interpreter/releases/).

# Flutter

When using it in a Flutter project you should use [`package:flutter_wasmi`](https://pub.dev/packages/flutter_wasmi) instead, since it will provide the right binaries for your platform.

# Dart Web (Not Flutter Web)

We use the [wasm-feature-detect JavaScript library](https://github.com/GoogleChromeLabs/wasm-feature-detect) for feature detection in the browser. To use this functionality in Dart web applications you will need to add the following script to your html (not necessary for Flutter):

```html
<script src="./packages/wasmi/assets/wasm-feature-detect.js"></script>
```


