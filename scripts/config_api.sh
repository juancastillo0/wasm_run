#!/bin/bash

SCRIPT_DIR="$(cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
cd $SCRIPT_DIR/.. # Go to the root of the project

IMPL=${1:-wasmtime} # wasmtime or wasmi
if [[ $IMPL != "wasmtime" && $IMPL != "wasmi" ]]; then
    echo "Invalid WASM runtime: $IMPL"
    exit 1
fi
cp -fr packages/wasmit/native/Cargo.$IMPL.toml packages/wasmit/native/Cargo.toml
cp -fr packages/wasmit/native/src/api_$IMPL.rs packages/wasmit/native/src/api.rs
echo "Configured api for WASM runtime: $IMPL"
