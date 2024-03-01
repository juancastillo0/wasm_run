# sql_parser

SQL parser, AST and visitors.

Uses https://github.com/juancastillo0/wasm_run for executing WASM and https://github.com/sqlparser-rs/sqlparser-rs for the underlying implementation.

## Example

You can find a deployed example in https://juancastillo0.github.io/wasm_run/ and the main file implementation in the [Github repository](https://github.com/juancastillo0/wasm_run/blob/main/packages/wasm_packages/flutter_example/lib/sql_parser_page.dart).

## Build Wasm Component from Rust

```sh
cd sql_parser_wasm
cargo wasi build --release
cp target/wasm32-wasi/release/sql_parser_wasm.wasm ../lib/assets/
```

## Generate Wit Dart bindings

```sh
dart run wasm_wit_component:generate sql_parser_wasm/wit/sql-parser.wit lib/src/sql_parser_wit.gen.dart
```
