#!/bin/bash

# Setup
BUILD_PROFILE=${1:-release} # dev, other Cargo.toml profile or release (default)
BUILD_DIR=platform-build
mkdir $BUILD_DIR
cd $BUILD_DIR

# Create the jniLibs build directory
JNI_DIR=jniLibs
mkdir -p $JNI_DIR

# Set up cargo-ndk
cargo install cargo-ndk
rustup target add \
        aarch64-linux-android \
        armv7-linux-androideabi \
        x86_64-linux-android \
        i686-linux-android \
        wasm32-wasi

# By default use wasmtime
scripts/config_api.exe --impl wasmtime

# Build the android libraries in the jniLibs directory
for TARGET in armeabi-v7a arm64-v8a x86 x86_64
do
        cargo ndk -o $JNI_DIR --manifest-path ../Cargo.toml \
                -t $TARGET build --profile $BUILD_PROFILE
        # if the exit code is not 0, build with wasmi instead of wasmtime
        if [[ $? != 0 ]]; then
                scripts/config_api.exe --impl wasmi
                cargo ndk -o $JNI_DIR --manifest-path ../Cargo.toml \
                        -t $TARGET build --profile $BUILD_PROFILE
                scripts/config_api.exe --impl wasmtime # revert wasmtime default
        fi
done

if [[ $WASM_BUILD_RUST_WASI_EXAMPLE != false ]]
then
        cargo build --target wasm32-wasi --profile $BUILD_PROFILE \
                --manifest-path ../packages/rust_wasi_example/Cargo.toml
fi

# Archive the dynamic libs
cd $JNI_DIR
tar -czvf ../android.tar.gz *
cd -

# Cleanup
rm -rf $JNI_DIR
