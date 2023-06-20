# compression_rs

## Build Wasm Component from Rust

```sh
cd compression_rs_wasm
cargo wasi build --release
cp target/wasm32-wasi/release/compression_rs_wasm.wasm ../lib/
```

## Generate Wit Dart bindings

```sh
dart run wasm_wit_component:generate compression_rs_wasm/wit/compression-rs.wit lib/src/compression_rs_wit.gen.dart
```

