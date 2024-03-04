#!/bin/bash

SCRIPT_DIR="$(cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
cd $SCRIPT_DIR # Go to the typesql_parser package directory

## Generate Wit Dart bindings
dart run ../../dart_wit_component/wasm_wit_component/bin/generate.dart \
    typesql_parser_wasm/wit/typesql-parser.wit lib/src/typesql_parser_wit.gen.dart

cd typesql_parser_wasm

## Build Wasm Component from Rust
echo "Expanding macros to src/lib_expand.rs"
RUSTFLAGS="-Zproc-macro-backtrace" cargo expand > src/lib_expand.rs

echo "Compiling for wasm32-unknown-unknown"
cargo +stable build --release --target wasm32-unknown-unknown
cp target/wasm32-unknown-unknown/release/typesql_parser_wasm.wasm ../lib/assets/

echo "Optimizing with wasm-opt -Oz"
wasm-opt -Oz -o ../lib/assets/typesql_parser_wasm.wasm ../lib/assets/typesql_parser_wasm.wasm

# cargo +stable wasi build --release
# cp target/wasm32-wasi/release/typesql_parser_wasm.wasm ../lib/assets/

