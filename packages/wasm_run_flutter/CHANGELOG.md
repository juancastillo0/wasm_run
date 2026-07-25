## 0.2.0+1

- Add CMakeLists.txt for android, windows and linux

## 0.2.0

 - flutter_rust_bridge: ^2.12.0
 - dart-sdk: ^3.10.0 
 - `WasmRunLibrary`, `setUpDesktopDynamicLibrary`, `uriForPackage` and `getUriBodyBytes` utilities
 - Use dart build hooks for sourcing the binaries
 - (BREAKING) remove `bin/setup`, `setUpDesktopDynamicLibrary` and `WasmRunLibrary.setUp`'s `override` argument
 
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
