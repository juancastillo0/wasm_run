#!/bin/bash

# Setup
BUILD_PROFILE=${1:-release} # dev, other Cargo.toml profile or release (default)
BUILD_PROFILE_PATH=$BUILD_PROFILE
if [[ $BUILD_PROFILE == "dev" ]]; then BUILD_PROFILE_PATH="debug"; fi
BUILD_DIR=platform-build
mkdir $BUILD_DIR
cd $BUILD_DIR

# Build static libs
for TARGET in \
        aarch64-apple-ios x86_64-apple-ios aarch64-apple-ios-sim \
        x86_64-apple-darwin aarch64-apple-darwin
do
    rustup target add $TARGET
    cargo build --profile $BUILD_PROFILE --target=$TARGET
done

# Create XCFramework zip
FRAMEWORK="Wasmi.xcframework"
LIBNAME=libwasmi_dart.a
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

# Cleanup
rm -rf ios-sim-lipo mac-lipo $FRAMEWORK
