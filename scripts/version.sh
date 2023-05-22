#!/bin/bash

CURR_VERSION=wasm_run-v`awk '/^version: /{print $2}' packages/wasm_run/pubspec.yaml`

# iOS & macOS
APPLE_HEADER="release_tag_name = '$CURR_VERSION' # generated; do not edit"
sed -i.bak "1 s/.*/$APPLE_HEADER/" packages/flutter_wasm_run/ios/flutter_wasm_run.podspec
sed -i.bak "1 s/.*/$APPLE_HEADER/" packages/flutter_wasm_run/macos/flutter_wasm_run.podspec
rm packages/flutter_wasm_run/macos/*.bak packages/flutter_wasm_run/ios/*.bak

# CMake platforms (Linux, Windows, and Android)
CMAKE_HEADER="set(LibraryVersion \"$CURR_VERSION\") # generated; do not edit"
for CMAKE_PLATFORM in android linux windows
do
    sed -i.bak "1 s/.*/$CMAKE_HEADER/" packages/flutter_wasm_run/$CMAKE_PLATFORM/CMakeLists.txt
    rm packages/flutter_wasm_run/$CMAKE_PLATFORM/*.bak
done

git add packages/flutter_wasm_run/
