#!/bin/bash

# Setup
BUILD_PROFILE=${1:-release} # dev, other Cargo.toml profile or release (default)
BUILD_PROFILE_PATH=$BUILD_PROFILE
if [[ $BUILD_PROFILE == "dev" ]]; then BUILD_PROFILE_PATH="debug"; fi
BUILD_DIR=platform-build
mkdir $BUILD_DIR
cd $BUILD_DIR

# By default use wasmtime
bash "../scripts/config_api.sh" wasmtime

export MACOSX_DEPLOYMENT_TARGET=10.11
export IPHONEOS_DEPLOYMENT_TARGET=11.0

# Build static libs
for TARGET in \
        aarch64-apple-ios x86_64-apple-ios aarch64-apple-ios-sim \
        x86_64-apple-darwin aarch64-apple-darwin; do
        rustup target add $TARGET
        cargo build --profile $BUILD_PROFILE --target=$TARGET
        # if the exit code is not 0, build with wasmi instead of wasmtime
        if [[ $? != 0 ]]; then
                bash "../scripts/config_api.sh" wasmi
                cargo build --profile $BUILD_PROFILE --target=$TARGET
                bash "../scripts/config_api.sh" wasmtime # revert wasmtime default
        fi
done

if [[ $BUILD_RUST_WASM_EXAMPLES != false ]]; then
    bash ../scripts/build-rust-wasm-examples.sh $BUILD_PROFILE
fi

# Create XCFramework zip
FRAMEWORK="Wasmit.xcframework"
LIBNAME=libwasm_run_dart.a
DYNAMIC_LIBNAME=libwasm_run_dart.dylib
mkdir mac-lipo ios-sim-lipo
IOS_SIM_LIPO=ios-sim-lipo/$LIBNAME
MAC_LIPO=mac-lipo/$LIBNAME
lipo -create -output $IOS_SIM_LIPO \
        ../target/aarch64-apple-ios-sim/$BUILD_PROFILE_PATH/$LIBNAME \
        ../target/x86_64-apple-ios/$BUILD_PROFILE_PATH/$LIBNAME
lipo -create -output $MAC_LIPO \
        ../target/aarch64-apple-darwin/$BUILD_PROFILE_PATH/$LIBNAME \
        ../target/x86_64-apple-darwin/$BUILD_PROFILE_PATH/$LIBNAME
xcodebuild -create-xcframework \
        -library $IOS_SIM_LIPO \
        -library $MAC_LIPO \
        -library ../target/aarch64-apple-ios/$BUILD_PROFILE_PATH/$LIBNAME \
        -output $FRAMEWORK
zip -r $FRAMEWORK.zip $FRAMEWORK

mkdir macos-arm64 && cp ../target/aarch64-apple-darwin/$BUILD_PROFILE_PATH/$DYNAMIC_LIBNAME macos-arm64/
mkdir macos-x64 && cp ../target/x86_64-apple-darwin/$BUILD_PROFILE_PATH/$DYNAMIC_LIBNAME macos-x64/
tar -czvf macos.tar.gz macos-*

# Cleanup
rm -rf ios-sim-lipo mac-lipo $FRAMEWORK macos-*
