#!/bin/bash

SCRIPT_DIR="$(cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
cd $SCRIPT_DIR # Go to the wasm_wit_component package directory

cd ..

## Build Wasm Component from Rust
cargo +stable wasi build --release
cp target/wasm32-wasi/release/dart_wit_component.wasm wasm_wit_component/lib/

cd wasm_wit_component

## Generate Wit Dart bindings
dart run bin/generate.dart ../wit/dart-wit-generator.wit lib/src/generator.dart
