# Minimal CMakeLists.txt for Android
# The actual Rust build is handled by cargokit's gradle plugin

cmake_minimum_required(VERSION 3.10)
project(wasm_run_native LANGUAGES CXX)

# Android does not need CMake-based cargokit - gradle handles it
# This file exists to satisfy Flutter's FFI plugin requirements
