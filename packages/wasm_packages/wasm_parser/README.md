# wasm_parser

## Build Wasm Component from Rust

```sh
cd wasm_parser_wasm
cargo wasi build --release
cp target/wasm32-wasi/release/wasm_parser_wasm.wasm ../lib/assets/
```

## Generate Wit Dart bindings

```sh
dart run wasm_wit_component:generate wasm_parser_wasm/wit/wasm-parser.wit lib/src/wasm_parser_wit.gen.dart
```

## Async Worker

### Build Threaded Wasm from Rust

```sh
cd wasm_parser_wasm
RUSTFLAGS='-C target-feature=+atomics,+bulk-memory,+mutable-globals -C link-args=--shared-memory' cargo +nightly build --target wasm32-unknown-unknown --profile release -Z build-std=std,panic_abort
cp target/wasm32-unknown-unknown/release/wasm_parser_wasm.wasm ../lib/assets/wasm_parser_wasm.threads.wasm
```

### Generate Wit Dart async bindings

```sh
dart run wasm_wit_component:generate wasm_parser_wasm/wit/wasm-parser.wit lib/src/wasm_parser_wit.worker.gen.dart --async-worker
```
