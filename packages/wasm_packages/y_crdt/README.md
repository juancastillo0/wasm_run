# y_crdt

## Build Wasm Component from Rust

```sh
cd y_crdt_wasm
cargo wasi build --release
cp target/wasm32-wasi/release/y_crdt_wasm.wasm ../lib/assets/
```

## Generate Wit Dart bindings

```sh
dart run wasm_wit_component:generate y_crdt_wasm/wit/y-crdt.wit lib/src/y_crdt_wit.gen.dart
```
