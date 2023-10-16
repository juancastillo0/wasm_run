# sql_parser

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
