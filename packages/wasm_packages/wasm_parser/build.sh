#!/bin/bash

SCRIPT_DIR="$(cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
cd $SCRIPT_DIR # Go to the wasm_parser package directory

## Generate Wit Dart bindings
dart run ../../dart_wit_component/wasm_wit_component/bin/generate.dart \
    wasm_parser_wasm/wit/wasm-parser.wit lib/src/wasm_parser_wit.gen.dart
### Generate Wit Dart async bindings
dart run ../../dart_wit_component/wasm_wit_component/bin/generate.dart \
    wasm_parser_wasm/wit/wasm-parser.wit lib/src/wasm_parser_wit.worker.gen.dart --async-worker

cd wasm_parser_wasm

## Build Wasm Component from Rust
cargo wasi build --release
cp target/wasm32-wasi/release/wasm_parser_wasm.wasm ../lib/assets/
### Build Threaded Wasm from Rust
RUSTFLAGS='-C target-feature=+atomics,+bulk-memory,+mutable-globals' \
    cargo +nightly build --target wasm32-unknown-unknown --release -Z build-std=std,panic_abort
cp target/wasm32-unknown-unknown/release/wasm_parser_wasm.wasm ../lib/assets/wasm_parser_wasm.threads.wasm
