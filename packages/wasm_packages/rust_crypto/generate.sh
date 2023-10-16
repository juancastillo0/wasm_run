#!/bin/bash

SCRIPT_DIR="$(cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
cd $SCRIPT_DIR # Go to the rust_crypto package directory

## Generate Wit Dart bindings
dart run ../../dart_wit_component/wasm_wit_component/bin/generate.dart \
    rust_crypto_wasm/wit/rust-crypto.wit lib/src/rust_crypto_wit.gen.dart

cd rust_crypto_wasm

## Build Wasm Component from Rust
cargo +stable wasi build --release
cp target/wasm32-wasi/release/rust_crypto_wasm.wasm ../lib/assets/
