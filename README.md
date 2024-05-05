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

[![Code coverage Coveralls](https://coveralls.io/repos/github/juancastillo0/wasm_run/badge.svg?branch=main)](https://coveralls.io/github/juancastillo0/wasm_run?branch=main)
[![Code coverage Codecov](https://codecov.io/gh/juancastillo0/wasm_run/branch/main/graph/badge.svg?token=QJLQSCIJ42)](https://codecov.io/gh/juancastillo0/wasm_run)
[![Build & Test](https://github.com/juancastillo0/wasm_run/actions/workflows/build.yaml/badge.svg)](https://github.com/juancastillo0/wasm_run/actions/workflows/build.yaml)
[![wasm_run is released under the MIT license.](https://img.shields.io/badge/License-MIT-blue.svg)](https://github.com/juancastillo0/wasm_run/blob/main/LICENSE)
[![PRs welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](#contributing)

# Dart Wasm Run

A Web Assembly executor for the Dart programming language.

Currently it uses the [`wasmtime 14.0`](https://github.com/bytecodealliance/wasmtime) or [`wasmi 0.31`](https://github.com/paritytech/wasmi) Rust crates for parsing and executing WASM modules. Bindings are created using [`package:flutter_rust_bridge`](https://github.com/fzyzcjy/flutter_rust_bridge).

| Pub                                                                                                            | Source                                                                      | Description                                                                                                                                       |
| -------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------- |
| [![version](https://img.shields.io/pub/v/wasm_run.svg)](https://pub.dev/packages/wasm_run)                     | [wasm_run](./packages/wasm_run/)                                            | Wasm executor and utilities                                                                                                                       |
| [![version](https://img.shields.io/pub/v/wasm_run_flutter.svg)](https://pub.dev/packages/wasm_run_flutter)     | [wasm_run_flutter](./packages/wasm_run_flutter/)                            | Native libraries to use `package:wasm_run` in Flutter projects                                                                                    |
| [![version](https://img.shields.io/pub/v/wasm_wit_component.svg)](https://pub.dev/packages/wasm_wit_component) | [wasm_wit_component](./packages/dart_wit_component/wasm_wit_component/)     | Wit bindings and code generator for Wasm components                                                                                               |
| [![version](https://img.shields.io/pub/v/compression_rs.svg)](https://pub.dev/packages/compression_rs)         | [compression_rs](./packages/wasm_packages/compression_rs/)                  | Compression, decompression, zip and tar achieves (brotli, lz4, zstd, gzip, zlib, ...)                                                             |
| [![version](https://img.shields.io/pub/v/image_ops.svg)](https://pub.dev/packages/image_ops)                     | [image_ops](./packages/wasm_packages/image_ops/)                              | Enconding, deconding, transformations and operations over multiple image formats (png, jpeg, ico, gif, bmp, tiff, webp, avif, tga, farbfeld, ...) |
| [![version](https://img.shields.io/pub/v/rust_crypto.svg)](https://pub.dev/packages/rust_crypto)               | [rust_crypto](./packages/wasm_packages/rust_crypto/)                        | Hashes, Hmacs, Argon2 Passwords and AES-GCM-SIV encryption. Digests for sha1, sha2, md5, blake3, crc32                                            |
| [![version](https://img.shields.io/pub/v/wasm_parser.svg)](https://pub.dev/packages/wasm_parser)               | [wasm_parser](./packages/wasm_packages/wasm_parser/)                        | Wasm, Wat and Wit parser, validator, printer and Wasm component tools                                                                             |
| [![version](https://img.shields.io/pub/v/y_crdt.svg)](https://pub.dev/packages/y_crdt)                         | [y_crdt](./packages/wasm_packages/y_crdt/)                                  | y.js (https://github.com/yjs/yjs) Dart port, a CRDT implementation. CRDTs allow for local, offline editing and synchronization of shared data.    |
| [![version](https://img.shields.io/pub/v/typesql_parser.svg)](https://pub.dev/packages/typesql_parser)                 | [typesql_parser](./packages/wasm_packages/typesql_parser/)                          | SQL parser, AST and visitors                                                                                                                      |
| [![version](https://img.shields.io/pub/v/typesql.svg)](https://pub.dev/packages/typesql)                       | [typesql](./packages/wasm_packages/typesql_parser/typesql/)                     | SQL type utilities and helpers for Dart model code generator and query execution                                                                  |
| [![version](https://img.shields.io/pub/v/typesql_generator.svg)](https://pub.dev/packages/typesql_generator)   | [typesql_generator](./packages/wasm_packages/typesql_parser/typesql_generator/) | SQL types code generator from .sql files to Dart queries and models                                                                               |


- [Dart Wasm Run](#dart-wasm-run)
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
  - [Execute WASM Function in Worker Threads](#execute-wasm-function-in-worker-threads)
    - [Threads Example](#threads-example)
    - [Web Workers configuration](#web-workers-configuration)
  - [Web Assembly System Interface (WASI)](#web-assembly-system-interface-wasi)
    - [WASI Examples](#wasi-examples)
      - [Dart Wit Component Generator](#dart-wit-component-generator)
      - [WASI Web](#wasi-web)
    - [Stdio (stdin, stdout, stderr)](#stdio-stdin-stdout-stderr)
    - [Directories](#directories)
    - [Environment and Arguments](#environment-and-arguments)
    - [Clocks and Randomness](#clocks-and-randomness)
  - [Wasm Components and Wasm Interface Type (WIT)](#wasm-components-and-wasm-interface-type-wit)
    - [Generate Dart code from Wit files](#generate-dart-code-from-wit-files)
      - [`wasm_wit_component:generate` CLI](#wasm_wit_componentgenerate-cli)
      - [Generate from the Dart API](#generate-from-the-dart-api)
    - [Multiple Types Example](#multiple-types-example)
- [Documentation](#documentation)
  - [Getting started](#getting-started)
  - [Usage](#usage)
  - [Integers, BigInt and Web Browsers](#integers-bigint-and-web-browsers)
  - [Load Wasm Modules with `WasmFileUris`](#load-wasm-modules-with-wasmfileuris)
  - [Configure Dynamic Libraries with `WasmRunLibrary`](#configure-dynamic-libraries-with-wasmrunlibrary)
  - [WasmInstanceBuilder](#wasminstancebuilder)
  - [WasmInstanceFuel](#wasminstancefuel)
  - [Wit Tutorial](#wit-tutorial)
    - [Dart Package](#dart-package)
    - [Rust Package](#rust-package)
    - [Rust Implementation and Wit Package API](#rust-implementation-and-wit-package-api)
    - [Build WASM](#build-wasm)
    - [Generate WIT Host Dart Bindings](#generate-wit-host-dart-bindings)
    - [Loading and Testing the Dart Library](#loading-and-testing-the-dart-library)



# Features

## Supported Wasm Features

| Feature\Runtime               | Wasmtime 14.0   | Wasmi 0.31 | Chrome<sup>[1]</sup> |
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
| tail_call                     | ❌               | 🏳          | ✅                    |
| exceptions                    | ❌               | ❌          | ✅                    |
| garbage_collection            | ❌               | ❌          | 🏳                    |
| memory_control                | ❌               | ❌          | ❌                    |
| type_reflection               | ✅               | ✅          | 🏳                    |
| wasi_snapshot_preview_1       | ✅               | ✅          | ✅                    |
| wasi_nn                       | ❌<sup>[2]</sup> | ❌          | ❌                    |
| wasi_crypto                   | ❌<sup>[2]</sup> | ❌          | ❌                    |
| wasi_threads                  | ❌<sup>[2]</sup> | ❌          | ❌                    |

- 🏳: Not enabled by default, may require additional configuration or a custom browser flag.
- [1]: For up-to-date values in browsers please visit https://webassembly.org/roadmap/.
- [2]: Supported, but not implemented.


## Execute WASM on any platform

### Flutter

We provide [`package:wasm_run_flutter`](./packages/wasm_run_flutter/) to bundle the right binaries for your platform compilation targets.

#### Runtime for Platform

| Platform | Architecture               | Runtime<sup>[1]</sup> |
| -------- | -------------------------- | --------------------- |
| Linux    | aarch64 x86_64             | Wasmtime 14.0         |
| MacOS    | aarch64 x86_64             | Wasmtime 14.0         |
| Windows  | aarch64 x86_64             | Wasmtime 14.0         |
| iOS      | aarch64 x86_64 aarch64-sim | Wasmi 0.31            |
| Android  | armeabi-v7a x86 x86_64     | Wasmi 0.31            |
| Android  | arm64-v8a                  | Wasmtime 14.0         |
| Web      | N/A                        | Browser/Wasmi 0.31    |

- [1]: Wasmi 0.31 supports any platform that Rust could be compiled to.

### Pure Dart (CLI/Backend/Web)

For pure Dart application (backend or cli, for example), you may download the compiled dynamic libraries for each platform and specify the `ffi.DynamicLibrary` in the `WasmRunLibrary.set` function or execute the [script](./packages/wasm_run/bin/setup.dart) `dart run wasm_run:setup` (or the function `WasmRunLibrary.setUp`) to download the right library for your current platform and configure it so that you don't need to call `WasmRunLibrary.set` manually. The compiled libraries can be found in the [releases assets](https://github.com/juancastillo0/wasm_run/releases) of this repository.

For the web platform we provide the same interface but it uses the WASM runtime provided by the browser instead of the native library (you may also use the Wasmi WASM module // TODO: not implemented yet).

### WASM Web bindings

We use [package:wasm_interop](https://pub.dev/packages/wasm_interop) to implement the browser web API. We don't need to provide a custom runtime since the browser already has one.

However, in web browsers there is no support for the [WAT](https://developer.mozilla.org/en-US/docs/WebAssembly/Understanding_the_text_format) format and other queries that you may perform over the WASM modules on native platforms. For example, WASM [function type definitions](https://github.com/WebAssembly/js-types/blob/main/proposals/js-types/Overview.md) of arguments and results are not provided in most browsers. If you need these features, you may use the compiled WASM module (TODO: Not implemented yet).

We use the [wasm-feature-detect JavaScript library](https://github.com/GoogleChromeLabs/wasm-feature-detect) for feature detection in the browser. To use this functionality in Dart web applications you will need to add the following script to your html:

```html
<script src="./packages/wasm_run/assets/wasm-feature-detect.js"></script>
<script type="module" src="./packages/wasm_run/assets/browser_wasi_shim.js"></script>
```

This is can be required also in Flutter, in `web/index.html` when your code call any function or need any object implemented in browser_wasi_shim.
```html
<head>
<script src="/assets/packages/wasm_run/lib/assets/wasm-feature-detect.js" defer></script>
<script type="module" src="/assets/packages/wasm_run/lib/assets/browser_wasi_shim.js" defer></script>
<head>
```


## Parse Web Assembly Text Format (WAT)

Support for compiling modules in [WAT format](https://developer.mozilla.org/en-US/docs/WebAssembly/Understanding_the_text_format). At the moment this is only supported in native platforms.

## Parse and Introspect WASM Modules

Parsing WASM and WAT modules to explore the exposed interface.

### Imports and Exports

You may retrieve the names and types of each import and export defined in a WASM module.


## Execute WASM Function in Worker Threads

At the moment this is experimental and will not work in the Wasmi runtime. 

The native implementation uses Rust's [rayon](https://docs.rs/rayon/latest/rayon/)
crate to execute tasks with a [work-stealing](https://en.wikipedia.org/wiki/Work_stealing)
scheduler. 

To use it you must call `WasmInstance.runParallel` with the `WasmFunction` to execute and the group of arguments to pass to the different threads.

The web implementation uses web workers for running the functions and a simple task
queue for scheduling.

Only shared memories can be accessed when running Wasm functions in workers. Regular memories, tables and globals will be instantiated separately for each worker and can not be easily accessed from the Dart API (imports will not be the same reference in Dart). Function imports will be correctly executed in the main Dart process (requires SharedBuffer support for web browsers). Wasm reference values will not work in the web browser and are not properly tested in native platforms.

### Threads Example

The repository's [packages/rust_threads_example](./packages/rust_threads_example) directory contains an implementation example for a WASM module with shared memories, atomics, thread locals and simd. You may compile it with Rust's Cargo nightly toolchain:

```sh
RUSTFLAGS='-C target-feature=+atomics,+bulk-memory,+mutable-globals' \
  cargo +nightly build --target wasm32-unknown-unknown --release -Z build-std=std,panic_abort
```

The [threads_test.dart](./packages/wasm_run/example/lib/threads_test.dart) contains a benchmark and multiple usage and configuration examples.

### Web Workers configuration

The [assets/wasm.worker.js](packages/wasm_run/lib/assets/wasm.worker.js) is used as the script for implementing the worker, you may override it with the `workerScriptUrl` configuration in `WorkersConfig`.

You may also configure the WASM imports are by using the `mapWorkerWasmImports` parameter. An example of the script can be found in [worker_map_imports.js](packages/wasm_run/example/test/worker_map_imports.js), it exposes a `mapWorkerWasmImports` that receives the imports, the WASM module and other information, and returns the mapped WASM imports object.

## Web Assembly System Interface (WASI)

We support [WASI](https://github.com/WebAssembly/WASI) [wasi_snapshot_preview1](https://github.com/WebAssembly/WASI/blob/main/legacy/preview1/docs.md) through the [wasmtime_wasi](https://docs.rs/wasmtime-wasi/14.0.4/wasmtime_wasi/) or [wasmi_wasi](https://docs.rs/wasmi_wasi/0.31.0/wasmi_wasi) Rust crates, [chosen depending on the target platform](#runtime-for-platform). 

In the web platform we support WASI modules by using [bjorn3/browser_wasi_shim](https://github.com/bjorn3/browser_wasi_shim). The file system directories exported by the host are in-memory Maps where the files are represented as `Uint8List` buffers. Other APIs, such as time and random are implemented using the JavaScript browser APIs.

### WASI Examples

Usage within Dart can be found in the [wasi_test.dart](./packages/wasm_run/example/lib/wasi_test.dart).

The WASI module used to execute the test is compiled from the [`rust_wasi_example` Rust project](./packages/rust_wasi_example/src/lib.rs) within this repo.

You may compile it with the following commands inside the project's directory:

`cargo build --target wasm32-wasi`

or, if you have `cargo-wasi` installed:

`cargo wasi build`

#### Dart Wit Component Generator

Another example of a Wasm module using Wasi is the [Dart Wit Component Generator](#generate-dart-code-from-wit-files).

#### WASI Web

We use the [bjorn3/browser_wasi_shim](https://github.com/bjorn3/browser_wasi_shim) JavaScript library that provides a shim around the browser API and an in-memory file system with `webBrowserFileSystem`.

### Stdio (stdin, stdout, stderr)

You may choose to inherit stdin, stdout and stderr from the current process. Or capture stdout and stderr to execute some custom logic for the stdio exposed by the execution of the specific WASI module.

`WasmInstance.stderr` and `WasmInstance.stdout` provide the captured Streams.

### Directories

You may provide a list of directories that the WASI module is allowed to access.

### Environment and Arguments

You can pass custom environment variables and program arguments to the WASI module or inherit them from the current process.

### Clocks and Randomness

The WASI modules can have access to the system clock and randomness.

## Wasm Components and Wasm Interface Type (WIT)

An experimental Wasm Interface Type (WIT) code generator for Dart can be found in the [dart_wit_component](./packages/dart_wit_component/) directory.

This is a work in progress and we will provide a separate package or additional tools for using Wasm components.

### Generate Dart code from Wit files

The generator is implemented in Rust and the usage within Dart is implemented using `package:wasm_run`. The wit document for the implementation can be found in [wit/dart-wit-generator.wit](packages/dart_wit_component/wit/dart-wit-generator.wit) the Rust implementation can be found in [the dart_wit_component folder](packages/dart_wit_component/wit/dart-wit-generator.wit) which uses [wit-bindgen](https://github.com/bytecodealliance/wit-bindgen). This is a good example of a package (or application) using wit components to implement functionalities in Dart. The usage within Dart is implemented as a [cli](packages/dart_wit_component/wasm_wit_component/lib/src/generate_cli.dart) and as a Dart library in [lib/generator.dart](packages/dart_wit_component/wasm_wit_component/lib/generator.dart). The generated Dart code can be found in [lib/src/generator.dart](packages/dart_wit_component/wasm_wit_component/lib/src/generator.dart).

#### `wasm_wit_component:generate` CLI

Command line interface usage: 

```sh
dart run wasm_wit_component:generate wit/input-file.wit lib/generated-world.dart --watch --no-copy-with
```

| Argument           | Kind       | Description                                                 | Default                      |
| ------------------ | ---------- | ----------------------------------------------------------- | ---------------------------- |
| inputWitPath       | positional | The path to the wit directory or file                       | none (Required)              |
| outputDartPath     | positional | The path to the dart file that will be generated            | next to the wit file         |
| watch              | named      | Whether to watch for changes in the wit path and regenerate | false                        |
| no-default         | named      | Whether to set to false other generator configurations      | false                        |
| json-serialization | named      | Whether to generate toJson and fromJson                     | true (false if --no-default) |
| to-string          | named      | Whether to generate toString method                         | true (false if --no-default) |
| equality           | named      | Whether to generate equality and hashCode                   | true (false if --no-default) |
| copy-with          | named      | Whether to generate copyWith                                | true (false if --no-default) |

#### Generate from the Dart API

API usage examples can be found in the [wit_generator_test.dart](packages/dart_wit_component/wasm_wit_component/example/lib/wit_generator_test.dart).

### Multiple Types Example

Another example with multiple tests can be found in the [example directory](packages/dart_wit_component/wasm_wit_component/example) inside the wasm_wit_component package:

- Wit Component World: [rust_wit_component_example/wit/types-example.wit](packages/dart_wit_component/wasm_wit_component/example/rust_wit_component_example/wit/types-example.wit)
- Rust Implementation: [rust_wit_component_example/src/lib.rs](packages/dart_wit_component/wasm_wit_component/example/rust_wit_component_example/src/lib.rs)
- Dart Generated Code: [lib/types_gen.dart](packages/dart_wit_component/wasm_wit_component/example/lib/types_gen.dart). Generated using:

```sh
dart run wasm_wit_component:generate rust_wit_component_example/wit/types-example.wit lib/types_gen.dart
```
- Tests and Usage: [lib/types_gen_test.dart](packages/dart_wit_component/wasm_wit_component/example/lib/types_gen_test.dart)

# Documentation

## Getting started

When using Flutter:

```yaml
dependencies:
  flutter:
    sdk: flutter
  wasm_run_flutter: 0.1.0
```

When using it in a pure Dart application:

```yaml
dependencies:
  wasm_run: 0.1.0
```

Fetch the dynamic libraries for your platform by running (or the function `WasmRunLibrary.setUp`): 

```
dart run wasm_run:setup
```

Or provide a custom dynamic library from the releases with `WasmRunLibrary.set`.

## Usage

You may explore the `testAll` function in the [main.dart](./packages/wasm_run/example/lib/main.dart) file.
It contains multiple test using distinct APIs withing the browser or native.

A simple usage example is the following. It compiles a WASM module with an `add` export and executes it:

```dart
/// WASM WAT source:
///
/// ```wat
/// (module
///     (func (export "add") (param $a i32) (param $b i32) (result i32)
///         local.get $a
///         local.get $b
///         i32.add
///     )
/// )
/// ```
const base64Binary =
    'AGFzbQEAAAABBwFgAn9/AX8DAgEABwcBA2FkZAAACgkBBwAgACABagsAEARuYW1lAgkBAAIAAWEBAWI=';
final Uint8List binary = base64Decode(base64Binary);
final WasmModule module = await compileWasmModule(
  binary,
  config: const ModuleConfig(
    wasmi: ModuleConfigWasmi(),
    wasmtime: ModuleConfigWasmtime(),
  ),
);
final List<WasmModuleExport> exports = module.getExports();

assert(
  exports.first.toString() ==
      const WasmModuleExport('add', WasmExternalKind.function).toString(),
);
final List<WasmModuleImport> imports = module.getImports();
assert(imports.isEmpty);

// configure wasi
WasiConfig? wasiConfig;
final WasmInstanceBuilder builder = module.builder(wasiConfig: wasiConfig);

// create external
// builder.createTable
// builder.createGlobal
// builder.createMemory

// Add imports
// builder.addImport(moduleName, name, value);

final WasmInstance instance = await builder.build();
final WasmFunction add = instance.getFunction('add')!;

final List<ValueTy?> params = add.params;
assert(params.length == 2);

final WasmRuntimeFeatures runtime = await wasmRuntimeFeatures();
if (!runtime.isBrowser) {
  // Types are not supported in browser
  assert(params.every((t) => t == ValueTy.i32));
  assert(add.results!.length == 1);
  assert(add.results!.first == ValueTy.i32);
}

final List<Object?> result = add([1, 4]);
assert(result.length == 1);
assert(result.first == 5);

final resultInner = add.inner(-1, 8) as int;
assert(resultInner == 7);
```

## Integers, BigInt and Web Browsers

At the moment, 64 bit integers are represented differently in the web browser and native platforms. Dart uses JavaScript's `number` (double) for all numbers when compiled to JavaScript. Since they cannot properly represent the full range of 64 bit integers, WebAssembly uses JavaScript's BigInt (different from Dart's `BigInt`) for the i64 Wasm type. You may choose to convert i64 values into integers using `i64.toInt(I64 value)` (a no-op in native platforms) or to Dart's BigInt with `i64.toBigInt(I64 value)`, where value is returned from or received as a parameter in a `WasmFunction`, or accessed with `WasmGlobal.get()`.

Unfortunately, JavaScript's BigInt is different from `dart:core`'s `BigInt` and using it directly is not recommended, for example it throws when printed and there is some weird behavior with Dart function (we need to use `js_util.callMethod(wasmFunction, 'apply', [null, args])` to call WasmFunction with `I64` parameters). If you target web platforms you should always use it with the `i64` utility functions for proper multi-platform support. Since native platforms represent i64 using Dart's `int` class you can always cast the `I64` values directly with `value as int`, and functions such as `i64.toInt` and `i64.fromInt` simply return the value passed as argument (they are a no-op).

Other utility functions are provided, for the full API you may look at [the source file](packages/wasm_run/lib/src/int64_bigint/int64_bigint.dart):
- `i64.toInt` and `i64.fromInt`
- `i64.toBigInt` and `i64.fromBigInt`
- `i64.getInt64`, `i64.getUint64`, `i64.setInt64` and `i64.setUint64`
  - These functions receive a `ByteData` to get or set the `I64` values at the given byte `offset` inside the buffer.

## Load Wasm Modules with `WasmFileUris`

You can load `WasmModules` from Uris (using http GET or reading from a file) with the [`WasmFileUris`](packages/wasm_run/lib/load_module.dart) utility class. You may aldo provide the `simdUri` and `threadsSimdUri` fields to conditionally import different `WasmModule`s based on the features supported by the current runtime (retrieved using `wasmRuntimeFeatures`).

An usage example can be found in the wit component [generator function](packages/dart_wit_component/wasm_wit_component/lib/generator.dart), where the WASM module is loaded from the file system in `lib/dart_wit_component.wasm` either reading it directly in native platforms or with a GET request for Dart web. As a fallback it will use the releases from the wasm_run repository. And it also received a `loadModule` custom function if you want to override the behavior. This can be useful if you want to provide a different configuration or implementation, or you are loading it from Flutter assets or from a different HTTP endpoint.

## Configure Dynamic Libraries with `WasmRunLibrary`

The `WasmRunLibrary` static utility class allows you to configure the external and dynamic libraries used by `wasm_run`.

- You can use the `String version` getter to retrieve the package version ("0.1.0").
- Set the dynamic library with the `set` static method.
- Set up the library using `setUp`. 
  - Flutter: This will do nothing in Flutter since the libraries are already configured for you. 
  - Pure Dart: It will download the right binary for your platform from the [releases assets](https://github.com/juancastillo0/wasm_run/releases) in this repository and place it in `.dart_tool/wasm_run/<wasm_run_dart_dynamic_library>` or in the path provided by the `WASM_RUN_DART_DYNAMIC_LIBRARY` environment variable. You can also run it with `dart run wasm_run:setup` in a project that depends on `wasm_run`.
  - Web Dart: It will configure your `html.document.head` with script tags (import the libraries) required to use the [wasm-feature-detect](https://github.com/GoogleChromeLabs/wasm-feature-detect) and [bjorn3/browser_wasi_shim](https://github.com/bjorn3/browser_wasi_shim) JavaScript libraries.


## WasmInstanceBuilder

## WasmInstanceFuel

## Wit Tutorial

In the following sections we will create a Dart package that uses a Wasm Wit component generated from a Rust implementation.

First we will create a [Dart package](#dart-package) and setup the [Rust implementation](#rust-package) within it. Then we will create a [Wit package API](#rust-implementation-and-wit-package-api)
with the connected Rust implementation. This Rust package will be [built to Wasm](#build-wasm), either to a `wasm32-wasi` or `wasm32-unknown-unknown` target
depending on whether you require WASI (system) APIs. After that we will [generate the wit Dart binding](#generate-wit-host-dart-bindings) 
using `package:wasm_wit_component`'s `generate` CLI command. Finally, we will setup the [Wasm module loading and implement some tests](#loading-and-testing-the-dart-library)
for the wasm implementation within Dart.

### Dart Package

```sh
dart create --template package your_package
```

```sh
cd your_package
```

### Rust Package

```sh
cargo new --lib your_package_wasm
```

```sh
cd your_package_wasm
```

Edit the generated `Cargo.toml`:

```toml
[lib]
crate-type = ['cdylib']

[dependencies]
wit-bindgen = { git = "https://github.com/bytecodealliance/wit-bindgen", version = "0.7.0", rev = "131746313de2f90d2688afbbc40c4a7ca309fe0d" }
image = "0.24.6"
```

### Rust Implementation and Wit Package API

```wit
package your-package-namespace:your-package

world your-package {
  hello: func() -> string
}
```

Within `your_package_wasm/src/lib.rs`:

```rust

```

### Build WASM

```sh
cargo add cargo-wasi
```

```sh
cargo wasi build --release
```

```sh
cp target/wasm32-wasi/release/your_package_wasm.wasm ../lib/your_package_wasm.wasm
```

### Generate WIT Host Dart Bindings

```sh
cd ..
```

```sh
dart pub add wasm_wit_component wasm_run
```

```sh
dart run wasm_wit_component:generate your_package_wasm/wit/your-package.wit lib/src/your_package_wit.gen.dart
```

### Loading and Testing the Dart Library
