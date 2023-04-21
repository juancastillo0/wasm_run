#!/bin/bash

# Setup
BUILD_PROFILE=${1:-release} # dev, other Cargo.toml profile or release (default)
BUILD_PROFILE_PATH=$BUILD_PROFILE
if [[ $BUILD_PROFILE == "dev" ]]; then BUILD_PROFILE_PATH="debug"; fi
BUILD_DIR=platform-build
mkdir $BUILD_DIR
cd $BUILD_DIR

# Install build dependencies
cargo install cargo-zigbuild
cargo install cargo-xwin

zig_build() {
    local TARGET="$1"
    local PLATFORM_NAME="$2"
    local LIBNAME="$3"
    rustup target add "$TARGET"
    cargo zigbuild --target "$TARGET" --profile $BUILD_PROFILE
    mkdir "$PLATFORM_NAME"
    cp "../target/$TARGET/$BUILD_PROFILE_PATH/$LIBNAME" "$PLATFORM_NAME/"
}

win_build() {
    local TARGET="$1"
    local PLATFORM_NAME="$2"
    local LIBNAME="$3"
    rustup target add "$TARGET"
    cargo xwin build --target "$TARGET" --profile $BUILD_PROFILE
    mkdir "$PLATFORM_NAME"
    cp "../target/$TARGET/$BUILD_PROFILE_PATH/$LIBNAME" "$PLATFORM_NAME/"
}

# Setup api files for wasmtime
bash scripts/config_api.sh wasmtime
SCRIPT_PATH="scripts/config_api.sh"
bash $SCRIPT_PATH wasmtime
. $SCRIPT_PATH wasmtime
source $SCRIPT_PATH wasmtime
source "scripts/config_api.sh" wasmtime

# Build all the dynamic libraries
LINUX_LIBNAME=libwasmi_dart.so
zig_build aarch64-unknown-linux-gnu linux-arm64 $LINUX_LIBNAME
zig_build x86_64-unknown-linux-gnu linux-x64 $LINUX_LIBNAME
WINDOWS_LIBNAME=wasmi_dart.dll
win_build aarch64-pc-windows-msvc windows-arm64 $WINDOWS_LIBNAME
win_build x86_64-pc-windows-msvc windows-x64 $WINDOWS_LIBNAME

if [[ $WASM_BUILD_RUST_WASI_EXAMPLE != false ]]; then
    rustup target add wasm32-wasi
    cargo build --target wasm32-wasi --profile $BUILD_PROFILE \
        --manifest-path ../packages/rust_wasi_example/Cargo.toml
fi

# Archive the dynamic libs
tar -czvf other.tar.gz linux-* windows-*

# Cleanup
rm -rf linux-* windows-*
