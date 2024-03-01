
## Documentation

Bindings for WASM WIT components. For more information please visit the main README at https://github.com/juancastillo0/wasm_run?tab=readme-ov-file#wasm-components-and-wasm-interface-type-wit or follow the WIT tutorial at https://github.com/juancastillo0/wasm_run?tab=readme-ov-file#wasm-components-and-wasm-interface-type-wit.


## Build Wasm Module

```
cargo +stable wasi build --release
cp target/wasm32-wasi/release/dart_wit_component.wasm wasm_wit_component/lib/dart_wit_component.wasm
dart run wasm_wit_component/bin/generate.dart wit/dart-wit-generator.wit wasm_wit_component/lib/src/generator.dart
```
