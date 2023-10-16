#!/bin/bash

SCRIPT_DIR="$(cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
cd $SCRIPT_DIR # Go to the y_crdt package directory

## Generate Wit Dart bindings
dart run ../../dart_wit_component/wasm_wit_component/bin/generate.dart \
    y_crdt_wasm/wit/y-crdt.wit lib/src/y_crdt_wit.gen.dart

cd y_crdt_wasm

## Build Wasm Component from Rust
echo "Expanding macros to src/lib_expand.rs"
RUSTFLAGS="-Zproc-macro-backtrace" cargo expand > src/lib_expand.rs

# echo "Compiling for wasm32-unknown-unknown"
# cargo +stable build --release --target wasm32-unknown-unknown
# cp target/wasm32-unknown-unknown/release/y_crdt_wasm.wasm ../lib/assets/ 

# echo "Optimizing with wasm-opt -Oz"
# wasm-opt -Oz -o ../lib/assets/y_crdt_wasm.wasm ../lib/assets/y_crdt_wasm.wasm

echo "Compiling for wasm32-wasi"
cargo +stable wasi build --release
cp target/wasm32-wasi/release/y_crdt_wasm.wasm ../lib/assets/

