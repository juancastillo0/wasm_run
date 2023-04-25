#!/bin/bash

CURR_VERSION=wasmit-v`awk '/^version: /{print $2}' packages/wasmit/pubspec.yaml`

# iOS & macOS
APPLE_HEADER="release_tag_name = '$CURR_VERSION' # generated; do not edit"
sed -i.bak "1 s/.*/$APPLE_HEADER/" packages/flutter_wasmit/ios/flutter_wasmit.podspec
sed -i.bak "1 s/.*/$APPLE_HEADER/" packages/flutter_wasmit/macos/flutter_wasmit.podspec
rm packages/flutter_wasmit/macos/*.bak packages/flutter_wasmit/ios/*.bak

# CMake platforms (Linux, Windows, and Android)
CMAKE_HEADER="set(LibraryVersion \"$CURR_VERSION\") # generated; do not edit"
for CMAKE_PLATFORM in android linux windows
do
    sed -i.bak "1 s/.*/$CMAKE_HEADER/" packages/flutter_wasmit/$CMAKE_PLATFORM/CMakeLists.txt
    rm packages/flutter_wasmit/$CMAKE_PLATFORM/*.bak
done

git add packages/flutter_wasmit/
