
Docs from https://github.com/bytecodealliance/wit-bindgen

- cargo install wasm-tools
  - https://github.com/bytecodealliance/wasm-tools


# non-WASI

- cargo build --target wasm32-unknown-unknown
- wasm-tools component new ./target/wasm32-unknown-unknown/debug/dart_wit_component.wasm -o dart_wit_component_component.wasm
- wasm-tools component wit dart_wit_component_component.wasm

```wit
default world dart_wit_component_component {
  import print: func(msg: string)
  export run: func()
}
```

# WASI

wasi_snapshot_preview1.wasm downloaded from https://github.com/bytecodealliance/preview2-prototyping

- cargo build --target wasm32-wasi
- wasm-tools component new ./target/wasm32-wasi/debug/dart_wit_component.wasm -o dart_wit_component_component_wasi.wasm --adapt ./wasi_snapshot_preview1.wasm
- wasm-tools component wit dart_wit_component_component_wasi.wasm