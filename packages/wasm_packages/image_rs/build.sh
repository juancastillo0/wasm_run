#!/bin/bash

SCRIPT_DIR="$(cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
cd $SCRIPT_DIR # Go to the image_rs package directory

## Generate Wit Dart bindings
dart run ../../dart_wit_component/wasm_wit_component/bin/generate.dart \
    image_rs_wasm/wit/image-rs.wit lib/src/image_rs_wit.gen.dart

cd image_rs_wasm

## Build Wasm Component from Rust
cargo wasi build --release
cp target/wasm32-wasi/release/image_rs_wasm.wasm ../lib/assets/


