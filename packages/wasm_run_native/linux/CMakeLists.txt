# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

# Project-level configuration.
set(PROJECT_NAME "wasm_run_native")
project(${PROJECT_NAME} LANGUAGES CXX)

# Include cargokit cmake module
include("../cargokit/cmake/cargokit.cmake")

# Apply cargokit to build the Rust library
# Arguments: target, manifest_dir, lib_name, any_symbol_name
apply_cargokit(${PROJECT_NAME} ../native wasm_run_native "")

# List of absolute paths to libraries that should be bundled with the plugin.
set(wasm_run_native_bundled_libraries
  "${${PROJECT_NAME}_cargokit_lib}"
  PARENT_SCOPE
)
