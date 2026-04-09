# wasm_run_flutter Android CMakeLists.txt
#
# The native library is now built by wasm_run_native via Cargokit.
# This file is kept minimal as Flutter's FFI plugin mechanism will
# automatically link the native library from wasm_run_native.

cmake_minimum_required(VERSION 3.10)

# No-op - wasm_run_native handles the native build via Cargokit
