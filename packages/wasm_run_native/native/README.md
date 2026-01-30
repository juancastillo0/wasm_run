# wasm_run_native

Native WebAssembly runtime for Dart/Flutter applications. This crate provides FFI bindings via `flutter_rust_bridge` to either:

- **wasmtime** (default) - High-performance JIT compiler with full WASI support
- **wasmi** - Pure interpreter, works on more platforms but with some limitations

## Features

### Runtime Selection

```toml
# Use wasmtime (default - recommended for most platforms)
[dependencies]
wasm_run_native = { version = "0.1.0", features = ["wasmtime-runtime", "wasi"] }

# Use wasmi (for platforms without JIT support)
[dependencies]
wasm_run_native = { version = "0.1.0", default-features = false, features = ["wasmi-runtime", "wasi"] }
```

### Wasmtime Features (v41.0.1)

When using the wasmtime runtime, the following WebAssembly proposals are supported:

| Feature | Default | Description |
|---------|---------|-------------|
| `multi_value` | Yes | Multiple return values |
| `bulk_memory` | Yes | Bulk memory operations |
| `reference_types` | Yes | Reference types (funcref, externref) |
| `simd` | Yes | 128-bit SIMD operations |
| `relaxed_simd` | No | Relaxed SIMD operations |
| `threads` | No | Shared memory and atomics |
| `multi_memory` | No | Multiple memories per module |
| `memory64` | No | 64-bit memory addresses |
| `tail_call` | Yes | Tail call optimization |
| `gc` | No | Garbage collection (anyref, structref, arrayref) |
| `exceptions` | No | Exception handling |
| `component_model` | No | Component Model (WASI Preview2) |

### Wasmi Features (v1.0.7)

When using the wasmi interpreter:

| Feature | Supported | Notes |
|---------|-----------|-------|
| `simd` | Yes | New in wasmi 1.0 |
| `relaxed_simd` | Yes | New in wasmi 1.0 |
| `multi_memory` | Yes | New in wasmi 1.0 |
| `memory64` | Yes | New in wasmi 1.0 |
| `tail_call` | Yes | |
| `threads` | No | Not supported in interpreter |
| `gc` | No | Not supported in interpreter |
| `exceptions` | No | Not supported in interpreter |

## WASI Support

### Preview1 (Core Modules)

All WebAssembly modules compiled with standard toolchains use WASI Preview1:

- Rust: `rustc --target wasm32-wasi`
- C/C++: wasi-sdk
- Go, AssemblyScript, etc.

### Preview2 (Components)

Component Model support is available for WebAssembly Components:

- Rust: `rustc --target wasm32-wasip2` (experimental)
- Components created with `wasm-tools component new`

Use `detect_wasm_kind()` to determine if a binary is a core module or component.

## Building

```bash
# Build with wasmtime (default)
cargo build --features wasmtime-runtime,wasi

# Build with wasmi
cargo build --features wasmi-runtime,wasi --no-default-features

# Check both configurations
cargo check --features wasmtime-runtime,wasi
cargo check --features wasmi-runtime,wasi --no-default-features
```

## Architecture

This crate is designed to work with `flutter_rust_bridge` to generate Dart FFI bindings:

```
wasm_run_native (Rust)
    |
    v
flutter_rust_bridge (codegen)
    |
    v
wasm_run (Dart) - bridge_generated.dart
    |
    v
wasm_run_flutter (Flutter plugin) - platform bindings
```

## License

MIT
