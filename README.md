<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

[![Code coverage Coveralls](https://coveralls.io/repos/github/juancastillo0/dart_interpreter/badge.svg?branch=main)](https://coveralls.io/github/juancastillo0/dart_interpreter?branch=main)
[![Code coverage Codecov](https://codecov.io/gh/juancastillo0/dart_interpreter/branch/main/graph/badge.svg?token=QJLQSCIJ42)](https://codecov.io/gh/juancastillo0/dart_interpreter)
[![Build & Test](https://github.com/juancastillo0/wasm_interpreter/actions/workflows/build.yaml/badge.svg)](https://github.com/juancastillo0/wasm_interpreter/actions/workflows/build.yaml)
[![dart_interpreter is released under the MIT license.](https://img.shields.io/badge/License-MIT-blue.svg)](https://github.com/juancastillo0/dart_interpreter/blob/main/LICENSE)
[![PRs welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](#contributing)

# Dart Wasm Interpreter

A Web Assembly executor for the Dart programming language. Currently it uses the [`wasmtime 8.0`](https://github.com/bytecodealliance/wasmtime) or [`wasmi 0.29`](https://github.com/paritytech/wasmi) Rust crates for parsing and executing WASM modules. Bindings are created using [`package:flutter_rust_bridge`](https://github.com/fzyzcjy/flutter_rust_bridge).

- [Dart Wasm Interpreter](#dart-wasm-interpreter)
  - [Features](#features)
    - [Supported Wasm Features](#supported-wasm-features)
    - [Execute WASM on any platform](#execute-wasm-on-any-platform)
      - [Flutter](#flutter)
        - [Runtime for Platform](#runtime-for-platform)
      - [Pure Dart (CLI/Backend/Web)](#pure-dart-clibackendweb)
      - [WASM Web bindings](#wasm-web-bindings)
    - [Parse Web Assembly Text Format (WAT)](#parse-web-assembly-text-format-wat)
    - [Parse and Introspect WASM Modules](#parse-and-introspect-wasm-modules)
      - [Imports and Exports](#imports-and-exports)
    - [Web Assembly System Interface (WASI)](#web-assembly-system-interface-wasi)
      - [stdio (stdin, stdout, stderr)](#stdio-stdin-stdout-stderr)
      - [Files and Directories](#files-and-directories)
      - [Environment and Arguments](#environment-and-arguments)
  - [Getting started](#getting-started)
  - [Usage](#usage)
  - [Additional information](#additional-information)



## Features

### Supported Wasm Features

| Feature\Runtime               | Wasmtime 8.0    | Wasmi 0.29 | Chrome<sup>[1]</sup> |
| ----------------------------- | --------------- | ---------- | -------------------- |
| multi_value                   | ✅               | ✅          | ✅                    |
| bulk_memory                   | ✅               | ✅          | ✅                    |
| reference_types               | ✅               | ✅          | ✅                    |
| mutable_global                | ✅               | ✅          | ✅                    |
| saturating_float_to_int       | ✅               | ✅          | ✅                    |
| sign_extension                | ✅               | ✅          | ✅                    |
| extended_const                | ✅               | ✅          | ✅                    |
| floats                        | ✅               | ✅          | ✅                    |
| simd                          | ✅               | ❌          | ✅                    |
| relaxed_simd                  | 🏳               | ❌          | 🏳                    |
| threads_shared_memory_atomics | 🏳               | ❌          | ✅                    |
| multi_memory                  | 🏳               | ❌          | ❌                    |
| memory64                      | 🏳               | ❌          | 🏳                    |
| component_model               | ❌<sup>[2]</sup> | ❌          | ❌                    |
| tail_call                     | ❌               | ✅          | ✅                    |
| exceptions                    | ❌               | ❌          | ✅                    |
| garbage_collection            | ❌               | ❌          | 🏳                    |
| memory_control                | ❌               | ❌          | ❌                    |
| type_reflection               | ✅               | ✅          | 🏳                    |
| wasi_snapshot_preview_1       | ✅               | ✅          | ❌                    |
| wasi_nn                       | ❌<sup>[2]</sup> | ❌          | ❌                    |
| wasi_crypto                   | ❌<sup>[2]</sup> | ❌          | ❌                    |
| wasi_threads                  | ❌<sup>[2]</sup> | ❌          | ❌                    |

- 🏳: Not enabled by default, may require additional configuration or a custom browser flag.
- [1]: For up-to-date values in browsers please visit https://webassembly.org/roadmap/.
- [2]: Supported, but not implemented.


### Execute WASM on any platform

#### Flutter

We provide [`package:flutter_wasi`](./packages/flutter_wasmi/) to bundle the right binaries for your platform compilation targets.

##### Runtime for Platform

| Platform | Architecture                     | Runtime<sup>[1]</sup> |
| -------- | -------------------------------- | --------------------- |
| Linux    | aarch64 x86_64                   | Wasmtime 8.0          |
| MacOS    | x86_64 aarch64                   | Wasmtime 8.0          |
| Windows  | aarch64 x86_64                   | Wasmtime 8.0          |
| iOS      | aarch64 x86_64 aarch64-sim       | Wasmi 0.29            |
| Android  | armeabi-v7a arm64-v8a x86 x86_64 | Wasmi 0.29            |
| Web      | N/A                              | Browser/Wasmi 0.29    |

- [1]: Wasmi 0.29 supports any runtime that Rust could be compiled to.

#### Pure Dart (CLI/Backend/Web)

For other platforms, you may download the executables for each platform and specify the `DynamicLibrary` in non-web platforms.

For the web platform we provide the same interface for the WASM runtime provided by the browser (you may also use the Wasmi WASM module).

#### WASM Web bindings

We use [package:wasm_interop](https://pub.dev/packages/wasm_interop) to implement the browser web API. In this way, you won't need to provide a custom runtime, since the browser already provides it.

However, in web browsers there is no support for the [WAT](https://developer.mozilla.org/en-US/docs/WebAssembly/Understanding_the_text_format) format and other queries that you may perform over the WASM modules on native platforms. For example, WASM [function type definitions](https://github.com/WebAssembly/js-types/blob/main/proposals/js-types/Overview.md) (arguments and results) are not provided in most browsers. If you what these features, you may use the compiled WASM module.

We use the [wasm-feature-detect JavaScript library](https://github.com/GoogleChromeLabs/wasm-feature-detect) for feature detection in the browser. To use this functionality in Dart web applications you will need to add the following script (not necessary for Flutter):

```html
<script src="https://unpkg.com/wasm-feature-detect/dist/umd/index.js"></script>
```


### Parse Web Assembly Text Format (WAT)

Support for compiling modules in [WAT format](https://developer.mozilla.org/en-US/docs/WebAssembly/Understanding_the_text_format). At the moment this is only supported in native platforms.

### Parse and Introspect WASM Modules

#### Imports and Exports

You may retrieve the names and types of each import and export defined in a WASM module.

### Web Assembly System Interface (WASI)

We support [WASI](https://github.com/WebAssembly/WASI) through the [wasmtime_wasi](https://docs.rs/wasmtime-wasi/8.0.0/wasmtime_wasi/) or [wasmi_wasi](https://docs.rs/wasmi_wasi/0.29.0/wasmi_wasi) Rust crates, [chosen depending on the target platform](#runtime-for-platform). 

#### stdio (stdin, stdout, stderr)

#### Files and Directories

#### Environment and Arguments

## Getting started

TODO: List prerequisites and provide or point to information on how to
start using the package.

```yaml
dependencies:
  wasmi: 0.0.1
```

When using Flutter:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_wasmi: 0.0.1
```

## Usage

TODO: Include short and useful examples for package users. Add longer examples
to `/example` folder. 

```dart
const like = 'sample';
```

## Additional information

TODO: Tell users more about the package: where to find more information, how to 
contribute to the package, how to file issues, what response they can expect 
from the package authors, and more.
