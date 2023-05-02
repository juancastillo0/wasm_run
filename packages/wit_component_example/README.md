
Docs from https://github.com/bytecodealliance/wit-bindgen

- cargo install wasm-tools
  - https://github.com/bytecodealliance/wasm-tools


# non-WASI

- cargo build --target wasm32-unknown-unknown
- wasm-tools component new ./target/wasm32-unknown-unknown/debug/wit_component_example.wasm -o wit_component_example_component.wasm
- wasm-tools component wit wit_component_example_component.wasm

```wit
default world wit_component_example_component {
  import print: func(msg: string)
  export run: func()
}
```

# WASI

wasi_snapshot_preview1.wasm downloaded from https://github.com/bytecodealliance/preview2-prototyping

- cargo build --target wasm32-wasi
- wasm-tools component new ./target/wasm32-wasi/debug/wit_component_example.wasm -o wit_component_example_component_wasi.wasm --adapt ./wasi_snapshot_preview1.wasm
- wasm-tools component wit wit_component_example_component_wasi.wasm