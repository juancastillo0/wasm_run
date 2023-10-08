set(LibraryVersion "wasm_run-v0.0.1") # generated; do not edit

# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

# Project-level configuration.
set(PROJECT_NAME "wasm_run_flutter")
project(${PROJECT_NAME} LANGUAGES CXX)

# Download the binaries if they are not already present.
set(LibRoot "${CMAKE_CURRENT_SOURCE_DIR}/${LibraryVersion}")
set(ArchivePath "${LibRoot}.tar.gz")
set(BinaryPath "${FLUTTER_TARGET_PLATFORM}/libwasm_run_dart.so")

if(NOT EXISTS "${LibRoot}/${BinaryPath}")
  if(NOT EXISTS ${ArchivePath})
    file(DOWNLOAD
      "https://github.com/juancastillo0/wasm_run/releases/download/${LibraryVersion}/other.tar.gz"
      ${ArchivePath}
      TLS_VERIFY ON
    )
  endif()

  # Extract the binaries, overriding any already present.
  file(REMOVE_RECURSE ${LibRoot})
  file(MAKE_DIRECTORY ${LibRoot})
  execute_process(
    COMMAND ${CMAKE_COMMAND} -E tar xzf ${ArchivePath}
    WORKING_DIRECTORY  ${LibRoot}
  )
  
  # Clean up archive files
  file(GLOB WindowsBinaries "${LibRoot}/windows-*")
  file(REMOVE_RECURSE ${ArchivePath} ${WindowsBinaries})
endif()

# List of absolute paths to libraries that should be bundled with the plugin.
# This list could contain prebuilt libraries, or libraries created by an
# external build triggered from this build file.
set(wasm_run_flutter_bundled_libraries
  "${LibRoot}/${BinaryPath}"
  PARENT_SCOPE
)
