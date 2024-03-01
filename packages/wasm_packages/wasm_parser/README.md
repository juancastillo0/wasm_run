# wasm_parser

Parses Web Assembly (WASM), WASM Text Format (WAT) and Web Assembly Interface Types (WIT) files

Uses https://github.com/juancastillo0/wasm_run for executing WASM.

## Example

You can find a deployed example in https://juancastillo0.github.io/wasm_run/ and the main file implementation in the [Github repository](https://github.com/juancastillo0/wasm_run/blob/main/packages/wasm_packages/flutter_example/lib/wasm_parser_page.dart).

## Build Wasm Component from Rust

```sh
cd wasm_parser_wasm
cargo +stable wasi build --release
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
