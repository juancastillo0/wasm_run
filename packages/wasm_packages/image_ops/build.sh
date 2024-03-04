#!/bin/bash

SCRIPT_DIR="$(cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
cd $SCRIPT_DIR # Go to the image_ops package directory

## Generate Wit Dart bindings
dart run ../../dart_wit_component/wasm_wit_component/bin/generate.dart \
    image_ops_wasm/wit/image-ops.wit lib/src/image_ops_wit.gen.dart

cd image_ops_wasm

## Build Wasm Component from Rust
cargo +stable wasi build --release
cp target/wasm32-wasi/release/image_ops_wasm.wasm ../lib/assets/
