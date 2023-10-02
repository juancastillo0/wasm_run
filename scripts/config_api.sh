#!/bin/bash

SCRIPT_DIR="$(cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
cd $SCRIPT_DIR/.. # Go to the root of the project

IMPL=${1:-wasmtime} # wasmtime or wasmi
if [[ $IMPL != "wasmtime" && $IMPL != "wasmi" ]]; then
    echo "Invalid WASM runtime: $IMPL"
    exit 1
fi
cp -fr packages/wasm_run/native/Cargo.$IMPL.toml packages/wasm_run/native/Cargo.toml
cp -fr packages/wasm_run/native/src/api_$IMPL.rs packages/wasm_run/native/src/api.rs
echo "Configured api for WASM runtime: $IMPL"
