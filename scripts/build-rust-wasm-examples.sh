#!/bin/bash

SCRIPT_DIR="$(cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
cd $SCRIPT_DIR/.. # Go to the root of the project

BUILD_PROFILE=${1:-release} # dev, other Cargo.toml profile or release (default)
BUILD_PROFILE_PATH=$BUILD_PROFILE
if [[ $BUILD_PROFILE == "dev" ]]; then BUILD_PROFILE_PATH="debug"; fi

# rust_wasi_example
rustup target add wasm32-wasi
cargo build --target wasm32-wasi --profile $BUILD_PROFILE \
    --manifest-path packages/rust_wasi_example/Cargo.toml
cp -fr packages/rust_wasi_example/target/wasm32-wasi/$BUILD_PROFILE_PATH/rust_wasi_example.wasm packages/flutter_wasmit/example/assets/rust_wasi_example.wasm

# rust_threads_example
rustup +nightly target add wasm32-unknown-unknown
rustup +nightly component add rust-src
RUSTFLAGS='-C target-feature=+atomics,+bulk-memory,+mutable-globals' \
    cargo +nightly build --target wasm32-unknown-unknown --profile $BUILD_PROFILE -Z build-std=std,panic_abort \
    --manifest-path packages/rust_threads_example/Cargo.toml
cp -fr packages/rust_threads_example/target/wasm32-unknown-unknown/$BUILD_PROFILE_PATH/rust_threads_example.wasm packages/flutter_wasmit/example/assets/rust_threads_example.wasm
