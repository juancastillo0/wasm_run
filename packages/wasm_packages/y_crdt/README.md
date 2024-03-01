# y_crdt

y.js (https://github.com/yjs/yjs) Dart port, a CRDT implementation. CRDTs allow for local, offline editing and synchronization of shared data.

Uses https://github.com/juancastillo0/wasm_run for executing WASM and https://github.com/y-crdt/y-crdt for the underlying implementation.

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
