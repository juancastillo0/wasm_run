# compression_rs

Supports brotli, zstd, lz4, gzip, zlib, deflate compression and decompression, and tar and zip archives using Rust libraries through WASM and WIT.

Uses https://github.com/juancastillo0/wasm_run for executing WASM.

## Example

You can find a deployed example in https://juancastillo0.github.io/wasm_run/ and the main file implementation in the [Github repository](https://github.com/juancastillo0/wasm_run/blob/main/packages/wasm_packages/flutter_example/lib/compression_rs_page.dart).

## Build Wasm Component from Rust

```sh
cd compression_rs_wasm
cargo +stable wasi build --release
cp target/wasm32-wasi/release/compression_rs_wasm.wasm ../lib/
```

## Generate Wit Dart bindings

```sh
dart run wasm_wit_component:generate compression_rs_wasm/wit/compression-rs.wit lib/src/compression_rs_wit.gen.dart
```

