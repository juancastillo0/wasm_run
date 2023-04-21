#!/bin/bash

IMPL=${1:-wasmtime} # wasmtime or wasmi
if [[ $IMPL != "wasmtime" && $IMPL != "wasmi" ]]; then
    echo "Invalid WASM runtime: $IMPL"
    exit 1
fi
cp -fr packages/wasmi/native/Cargo.$IMPL.toml packages/wasmi/native/Cargo.toml
cp -fr packages/wasmi/native/src/api_$IMPL.rs packages/wasmi/native/src/api.rs
echo "Configured api for WASM runtime: $IMPL"
