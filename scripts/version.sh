#!/bin/bash

CURR_VERSION=wasm_run-v$(awk '/^version: /{print $2}' packages/wasm_run/pubspec.yaml)

# iOS & macOS
APPLE_HEADER="release_tag_name = '$CURR_VERSION' # generated; do not edit"
sed -i.bak "1 s/.*/$APPLE_HEADER/" packages/wasm_run_flutter/ios/wasm_run_flutter.podspec
sed -i.bak "1 s/.*/$APPLE_HEADER/" packages/wasm_run_flutter/macos/wasm_run_flutter.podspec
rm packages/wasm_run_flutter/macos/*.bak packages/wasm_run_flutter/ios/*.bak

# CMake platforms (Linux, Windows, and Android)
CMAKE_HEADER="set(LibraryVersion \"$CURR_VERSION\") # generated; do not edit"
for CMAKE_PLATFORM in android linux windows; do
    sed -i.bak "1 s/.*/$CMAKE_HEADER/" packages/wasm_run_flutter/$CMAKE_PLATFORM/CMakeLists.txt
    rm packages/wasm_run_flutter/$CMAKE_PLATFORM/*.bak
done

git add packages/wasm_run_flutter/
