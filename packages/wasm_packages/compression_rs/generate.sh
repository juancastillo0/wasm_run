#!/bin/bash

SCRIPT_DIR="$(cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
cd $SCRIPT_DIR # Go to the compression_rs package directory

## Generate Wit Dart bindings
dart run ../../dart_wit_component/wasm_wit_component/bin/generate.dart \
    compression_rs_wasm/wit/compression-rs.wit lib/src/compression_rs_wit.gen.dart
### Generate Wit Dart async bindings
dart run ../../dart_wit_component/wasm_wit_component/bin/generate.dart \
    compression_rs_wasm/wit/compression-rs.wit lib/src/compression_rs_wit.worker.gen.dart --async-worker

cd compression_rs_wasm

## Build Wasm Component from Rust
cargo wasi build --release
cp target/wasm32-wasi/release/compression_rs_wasm.wasm ../lib/assets/
### Build Threaded Wasm from Rust
RUSTFLAGS='-C target-feature=+atomics,+bulk-memory,+mutable-globals' \
    cargo +nightly build --target wasm32-unknown-unknown --release -Z build-std=std,panic_abort
cp target/wasm32-unknown-unknown/release/compression_rs_wasm.wasm ../lib/assets/compression_rs_wasm.threads.wasm
