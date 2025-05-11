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

