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

A Web Assembly interpreter for the Dart programming language. Currently it uses the [`wasmi`](https://docs.rs/wasmi/0.29.0/wasmi/) Rust crate for parsing and executing WASM modules. Bindings are created using [`package:flutter_rust_bridge`](https://github.com/fzyzcjy/flutter_rust_bridge).


## Features

### Execute WASM on any platform

#### Flutter

We provide [`package:flutter_wasi`](./packages/flutter_wasmi/) to bundle the right binaries for your platform compilation targets.

#### Pure Dart (CLI/Backend/Web)

For other platforms, you may download the executables for each platform and specify the `DynamicLibrary` in non-web platforms, or use the WASM runtime provided by the browser (or download the WASM module).

#### WASM Web bindings

We use [package:wasm_interop](https://pub.dev/packages/wasm_interop) to implement the browser web API. In this way, you won't need to provide a custom runtime, since the browser already provides it.

However, there is no support for the WAT format and other queries that you may perform over the WASM modules on native platforms. For example, wasm function type definitions (arguments and results) are not provided in most browsers. If you what these features, you may use the compiled WASM module.

### Parse Web Assembly Text Format (WAT)

Support for compiling modules in WAT format.

### Parse and Introspect WASM Modules

#### Imports and Exports

You may retrieve the names and types of each import and export defined in a module.

### Web Assembly System Interface (WASI)

We support WASI thought the [wasmi_wasi](https://docs.rs/wasmi_wasi/0.29.0/wasmi_wasi) Rust crate. 

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
