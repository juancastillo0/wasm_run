# wasm_run_flutter Windows CMakeLists.txt
#
# The native library is now built by wasm_run_native via Cargokit.
# This file is kept minimal as Flutter's FFI plugin mechanism will
# automatically link the native library from wasm_run_native.

cmake_minimum_required(VERSION 3.14)

project(wasm_run_flutter LANGUAGES CXX)

# No bundled libraries needed - wasm_run_native provides them
set(wasm_run_flutter_bundled_libraries "" PARENT_SCOPE)
