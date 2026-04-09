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

### Native Build

```bash
# Build with wasmtime (default)
cargo build --features wasmtime-runtime,wasi

# Build with wasmi
cargo build --features wasmi-runtime,wasi --no-default-features

# Check both configurations
cargo check --features wasmtime-runtime,wasi
cargo check --features wasmi-runtime,wasi --no-default-features
```

### Cross-Compilation

The `scripts/cross-build.sh` script builds native libraries for all supported platforms using Docker-based cross-compilation.

#### Requirements

- Docker (running)
- Rust 1.85+
- [cross-rs](https://github.com/cross-rs/cross) (installed automatically)

#### Supported Targets

| Platform | Target Triple | Build Method |
|----------|--------------|--------------|
| Linux x64 | x86_64-unknown-linux-gnu | Native or cross-rs |
| Linux ARM64 | aarch64-unknown-linux-gnu | cross-rs |
| macOS x64 | x86_64-apple-darwin | osxcross Docker |
| macOS ARM64 | aarch64-apple-darwin | osxcross Docker |
| iOS ARM64 | aarch64-apple-ios | osxcross + iOS SDK |
| Android ARM64 | aarch64-linux-android | cross-rs |
| Android ARM32 | armv7-linux-androideabi | cross-rs |
| Android x64 | x86_64-linux-android | cross-rs |
| Android x86 | i686-linux-android | cross-rs |
| Windows x64 | x86_64-pc-windows-gnu | cross-rs |

#### Usage

```bash
# Check tools
./scripts/cross-build.sh --check

# Build all targets (parallel)
./scripts/cross-build.sh --all --parallel

# Build specific platform groups
./scripts/cross-build.sh --linux
./scripts/cross-build.sh --android
./scripts/cross-build.sh --macos
./scripts/cross-build.sh --ios
./scripts/cross-build.sh --windows

# Build single target
./scripts/cross-build.sh aarch64-linux-android

# Keep Docker images for faster rebuilds
./scripts/cross-build.sh --all --keep-images

# Clean built libraries
./scripts/cross-build.sh --clean
```

#### Output

Built libraries are placed in `lib/<target>/`:

```
lib/
├── aarch64-apple-darwin/libwasm_run_native.dylib
├── aarch64-apple-ios/libwasm_run_native.dylib
├── aarch64-linux-android/libwasm_run_native.so
├── aarch64-unknown-linux-gnu/libwasm_run_native.so
├── armv7-linux-androideabi/libwasm_run_native.so
├── i686-linux-android/libwasm_run_native.so
├── x86_64-apple-darwin/libwasm_run_native.dylib
├── x86_64-linux-android/libwasm_run_native.so
├── x86_64-pc-windows-gnu/wasm_run_native.dll
└── x86_64-unknown-linux-gnu/libwasm_run_native.so
```

#### Top-Level Build Script

From the workspace root, you can also use:

```bash
# Build all native libraries
./build.sh native

# Build with specific options
./build.sh native --android --parallel

# Clean everything
./build.sh clean
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
