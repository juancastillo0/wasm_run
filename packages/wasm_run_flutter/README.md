# wasm_run_flutter

A Web Assembly executor for the Dart programming language.

Currently it uses the [`wasmtime 9.0`](https://github.com/bytecodealliance/wasmtime) or [`wasmi 0.30`](https://github.com/paritytech/wasmi) Rust crates for parsing and executing WASM modules. Bindings are created using [`package:flutter_rust_bridge`](https://github.com/fzyzcjy/flutter_rust_bridge).

For more information on usage and documentation, please visit the main repository: https://github.com/juancastillo0/wasm_run.

This Flutter library only contains the necessary binaries for executing `package:wasm_run`'s WASM API. The WASM runtime used for each platform is selected according to the platform and architecture according to the following table:

| Platform | Architecture               | Runtime<sup>[1]</sup> |
| -------- | -------------------------- | --------------------- |
| Linux    | aarch64 x86_64             | Wasmtime 9.0          |
| MacOS    | aarch64 x86_64             | Wasmtime 9.0          |
| Windows  | aarch64 x86_64             | Wasmtime 9.0          |
| iOS      | aarch64 x86_64 aarch64-sim | Wasmi 0.30            |
| Android  | armeabi-v7a x86 x86_64     | Wasmi 0.30            |
| Android  | arm64-v8a                  | Wasmtime 9.0          |
| Web      | N/A                        | Browser/Wasmi 0.30    |

