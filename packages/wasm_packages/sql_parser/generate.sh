#!/bin/bash

SCRIPT_DIR="$(cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
cd $SCRIPT_DIR # Go to the sql_parser package directory

## Generate Wit Dart bindings
dart run ../../dart_wit_component/wasm_wit_component/bin/generate.dart \
    sql_parser_wasm/wit/sql-parser.wit lib/src/sql_parser_wit.gen.dart

cd sql_parser_wasm

## Build Wasm Component from Rust
cargo expand > src/lib_expand.rs

cargo +stable wasi build --release
cp target/wasm32-wasi/release/sql_parser_wasm.wasm ../lib/assets/

