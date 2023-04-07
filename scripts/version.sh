#!/bin/bash

CURR_VERSION=wasmi-v`awk '/^version: /{print $2}' packages/wasmi/pubspec.yaml`

# iOS & macOS
APPLE_HEADER="release_tag_name = '$CURR_VERSION' # generated; do not edit"
sed -i.bak "1 s/.*/$APPLE_HEADER/" packages/flutter_wasmi/ios/flutter_wasmi.podspec
sed -i.bak "1 s/.*/$APPLE_HEADER/" packages/flutter_wasmi/macos/flutter_wasmi.podspec
rm packages/flutter_wasmi/macos/*.bak packages/flutter_wasmi/ios/*.bak

# CMake platforms (Linux, Windows, and Android)
CMAKE_HEADER="set(LibraryVersion \"$CURR_VERSION\") # generated; do not edit"
for CMAKE_PLATFORM in android linux windows
do
    sed -i.bak "1 s/.*/$CMAKE_HEADER/" packages/flutter_wasmi/$CMAKE_PLATFORM/CMakeLists.txt
    rm packages/flutter_wasmi/$CMAKE_PLATFORM/*.bak
done

git add packages/flutter_wasmi/
