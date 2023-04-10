# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

project(flutter_wasmi_library VERSION 0.0.1 LANGUAGES C)

add_library(flutter_wasmi SHARED
  "flutter_wasmi.c"
)

set_target_properties(flutter_wasmi PROPERTIES
  PUBLIC_HEADER flutter_wasmi.h
  OUTPUT_NAME "flutter_wasmi"
)

target_compile_definitions(flutter_wasmi PUBLIC DART_SHARED_LIB)
