# wasm_run_native

Native WebAssembly runtime library for wasm_run. This package builds the Rust native libraries from source using [Cargokit](https://github.com/irondash/cargokit).

## Overview

This package provides the native FFI bindings for wasm_run, supporting two WebAssembly runtimes:

- **wasmtime** (default) - High-performance JIT compiler with full feature support
- **wasmi** - Pure interpreter, works on platforms without JIT support

## Supported Platforms

| Platform | Architecture | Default Runtime | Notes |
|----------|--------------|-----------------|-------|
| Linux | x86_64, aarch64 | wasmtime | Requires Rust toolchain |
| macOS | x86_64, arm64 | wasmtime | Universal binary support |
| Windows | x86_64 | wasmtime | MSVC toolchain required |
| iOS | arm64, arm64-sim, x86_64-sim | wasmi | No JIT on iOS |
| Android arm64 | arm64-v8a | wasmtime | JIT supported on arm64 |
| Android (other) | armeabi-v7a, x86, x86_64 | wasmi | No JIT on 32-bit |

## Building from Source

### Prerequisites

1. **Rust toolchain** - Install via [rustup](https://rustup.rs/):
   ```bash
   curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
   ```

2. **Platform-specific requirements**:
   - **Android**: Android SDK and NDK (via Android Studio)
   - **iOS/macOS**: Xcode and command line tools
   - **Windows**: Visual Studio with C++ workload
   - **Linux**: GCC or Clang

### Build Process

Cargokit automatically builds the Rust library during Flutter's build process:

```bash
# Flutter builds will automatically compile the Rust code
flutter build apk
flutter build ios
flutter build macos
flutter build linux
flutter build windows
```

### Manual Build (for testing)

```bash
cd native

# Build with wasmtime (default)
cargo build --release

# Build with wasmi
cargo build --release --no-default-features --features wasmi-runtime,wasi
```

## Cross-Compilation

Cargokit handles cross-compilation automatically for most platforms:

### From macOS
- Can build: macOS (x64, arm64), iOS (device + simulator)

### From Windows
- Can build: Windows (x64)

### From Linux
- Can build: Linux (host architecture only)
- For other architectures, use CI runners or cross-compilation tools

### Android (from any platform)
- Requires Android NDK
- Cargokit uses the NDK's toolchain for cross-compilation

## Precompiled Binaries

For faster builds, you can configure precompiled binaries in `native/cargokit.yaml`:

1. Generate a signing key pair:
   ```bash
   dart run cargokit:generate_key
   ```

2. Set up CI to build and upload binaries (see `.github/workflows/build-native.yaml`)

3. Configure `cargokit.yaml`:
   ```yaml
   precompiled_binaries:
     url_prefix: https://github.com/your-org/repo/releases/download
     public_key: <your-public-key-hex>
   ```

## Feature Flags

The Rust library supports these Cargo features:

| Feature | Description |
|---------|-------------|
| `wasmtime-runtime` | Use wasmtime JIT compiler (default) |
| `wasmi-runtime` | Use wasmi interpreter |
| `wasi` | Enable WASI support (default) |

## CI/CD Setup

For automated builds across all platforms, use GitHub Actions runners:

```yaml
jobs:
  build:
    strategy:
      matrix:
        include:
          - os: ubuntu-latest    # Linux x64
          - os: macos-latest     # macOS + iOS
          - os: windows-latest   # Windows
    runs-on: ${{ matrix.os }}
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
      - run: flutter build <platform>
```

For Linux arm64, use self-hosted runners or services like Cirrus CI.

## License

MIT
