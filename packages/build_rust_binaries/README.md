# build_rust_binaries

Build hooks and CLI for cross-compiling Rust native libraries and distributing them via CDN — designed for Dart & Flutter packages that embed Rust FFI binaries.

## Features

- **Three build modes** — fetch pre-built binaries from a CDN, build from a local Rust checkout, or use an existing binary file
- **Cross-compilation** — maps Dart target triples (OS + architecture) to Rust target triples for Android, iOS, macOS, Linux, Windows, and Fuchsia
- **Android NDK integration** — auto-generates `.cargo/config.toml` with the correct linkers and environment for Android cross-compilation
- **SHA-256 verification** — validates downloaded and built binaries against known hashes
- **CI/CD ready** — YAML config file, CSV/JSON output, fail-fast or continue-on-failure strategies
- **Dart build hook** — integrates with the Dart `hooks` package to fetch or build Rust binaries during `dart pub get` or `flutter pub get`
- **Dependency injection** — every external interaction (HTTP, process execution, logging) is injectable, enabling full testability

## Installation

```yaml
# pubspec.yaml
dependencies:
  build_rust_binaries: ^0.1.0
```

Or via CLI:

```bash
dart pub add build_rust_binaries
```

### Prerequisites

- **Dart SDK** >= 3.10.0
- **Rust toolchain** with `rustup` (for `checkout` and CLI build modes)
- **Android NDK** (for Android cross-compilation targets)
- **Platform-specific toolchains** (see [Cross-compilation setup](#cross-compilation-setup) below)

## Concepts

The package provides two entry points that work together:

| Entry point | What it does | When to use |
|-------------|--------------|-------------|
| `BuildRustBinariesCLI` | Builds Rust binaries for multiple targets on a single host machine | In CI or local dev — produces binary artifacts that you upload to a CDN |
| `sourceRustBinariesBuildHook` | Fetches or locates a pre-built Rust binary for the current target | In a `hook/build.dart` script — runs automatically when consumers run `dart pub get` |

A typical workflow:

1. **Build** — Run `BuildRustBinariesCLI` in CI (GitHub Actions, etc.) on Linux, macOS, and Windows runners to cross-compile `.so` / `.dylib` / `.dll` files for every target
2. **Upload** — Upload the built binaries to a release CDN (GitHub Releases, S3, etc.)
3. **Fetch** — In your package's `hook/build.dart`, use `sourceRustBinariesBuildHook` in `fetch` mode to download the correct binary for the end user's platform
4. **Verify** — The hook validates the downloaded binary against a known SHA-256 hash

## Usage

### CLI — Building binaries locally or in CI

Create a `build_binaries.config.yaml` file in your Rust project:

```yaml
# build_binaries.config.yaml
assetName: my_library-$libraryType-$target
outputDirectory: platform-build
hostSupportedTargets:
  windows:
    - "x86_64-pc-windows-msvc"
    - "aarch64-pc-windows-msvc"
  linux:
    - "x86_64-unknown-linux-gnu"
    - "aarch64-unknown-linux-gnu"
  darwin:
    - "aarch64-apple-darwin"
    - "x86_64-apple-darwin"
    - "aarch64-apple-ios"
    - "aarch64-apple-ios-sim"
outputs:
  my_library-default-$target:
    targets:
      - "aarch64-apple-darwin"
      - "x86_64-apple-darwin"
      - "aarch64-pc-windows-msvc"
      - "x86_64-pc-windows-msvc"
      - "aarch64-unknown-linux-gnu"
      - "x86_64-unknown-linux-gnu"
  my_library-wasmi-$target:
    features: wasmi,wasi
    noDefaultFeatures: true
    targets:
      - "aarch64-apple-ios"
      - "aarch64-apple-ios-sim"
```

Run the CLI:

```bash
# Using the standalone CLI
dart run build_rust_binaries \
  --config build_binaries.config.yaml \
  --manifest-path ./rust/ \
  --output-directory platform-build \
  --build-dynamic \
  --create-cargo-config

# Or from your own package's bin/ entry point
dart run bin/build_binaries.dart --create-cargo-config --output-directory platform-build
```

Pass `--create-cargo-config` on first run to generate `.cargo/config.toml` with the correct Android NDK linkers (only needed once).

The CLI outputs binaries named according to the `assetName` template, e.g.:

```
platform-build/
  my_library-dynamic-x86_64-unknown-linux-gnu
  my_library-dynamic-aarch64-apple-darwin
  my_library-dynamic-x86_64-pc-windows-msvc
  sha256-hashes.csv
```

#### Using the CLI from your own code

```dart
import 'package:build_rust_binaries/build_rust_binaries.dart';

void main(List<String> args) async {
  await BuildRustBinariesCLI(
    manifestPathDefault: './native/',         // default path to Cargo.toml
    assetNameDefault: r'my_lib-$libraryType-$target',
    log: print,
    runProcess: myCustomProcessRunner,         // optional: wrap cargo commands
  ).mainCli(args);
}
```

#### Using the CLI locally with the build hook (local mode)

Instead of uploading to a CDN, you can build locally with the CLI and use the build hook's `local` mode to copy the binary from the output directory:

```bash
# 1. Build the binary locally
dart run bin/build_binaries.dart \
  --output-directory platform-build \
  --targets x86_64-unknown-linux-gnu \
  --build-dynamic
```

In your root `pubspec.yaml`, configure the build hook to use local mode:

```yaml
hooks:
  user_defines:
    my_package:
      buildMode: local
      localPath: platform-build/my_library-dynamic-x86_64-unknown-linux-gnu
```

### Build Hook — Fetching binaries from a CDN

Create a `hook/build.dart` in your package:

```dart
import 'package:build_rust_binaries/build_rust_binaries.dart';

void main(List<String> args) async {
  await sourceRustBinariesBuildHook(
    args,
    SourceBinariesParams(
      fetchAssetUrl: (input) {
        // Dynamically construct the CDN URL for the current target
        final rustTarget = /* derive from input.config.code */ '';
        return Uri.parse(
          'https://github.com/your-org/your-repo/releases/download/v1.0.0/'
          'my_library-dynamic-$rustTarget',
        );
      },
      sha256ForAsset: (input) {
        // Return the expected hash for the current target
        return myKnownHashes[rustTarget];
      },
      defaultBuildOptions: BuildOptions(
        buildMode: BuildModeEnum.fetch,
        libraryName: 'my_library',
      ),
    ),
  );
}
```

Or use a fetch URI base with per-asset SHA-256 hashes:

```dart
void main(List<String> args) async {
  await sourceRustBinariesBuildHook(
    args,
    SourceBinariesParams(
      defaultBuildOptions: BuildOptions(
        buildMode: BuildModeEnum.fetch,
        fetchUriBase: 'https://github.com/your-org/your-repo/releases/download/v1.0.0/',
        libraryName: 'my_library',
        assetsSha256: {
          'my_library-dynamic-aarch64-apple-darwin':
              '1654553b0782eca999cd5ce3ae9610d5f338e27fcb82a5856e0cdf67acf1b2d9',
          'my_library-dynamic-x86_64-unknown-linux-gnu':
              '5a0df6b8992c112a66dca94efeacc87a05ac3c695e2ddf38fea8e32dc47ee05f',
          // ... all targets
        },
      ),
    ),
  );
}
```

The full path is constructed as `$fetchUriBase$assetName` where `assetName` follows the template `$libraryName-$libraryType-$target` by default.

### Build Hook — Building from a local Rust checkout

```yaml
# pubspec.yaml
hooks:
  user_defines:
    my_package:
      buildMode: checkout
      checkoutPath: packages/my_package/native/
```

The checkout mode runs `rustup target add`, configures the toolchain, and invokes `cargo rustc` with the appropriate flags for the current Dart target.

### Configuring the build mode via pubspec.yaml

Users control the build mode through their `pubspec.yaml`:

```yaml
hooks:
  user_defines:
    my_package:
      # Option 1: Fetch from CDN
      buildMode: fetch

      # Option 2: Use a local binary
      buildMode: local
      localPath: path/to/library.so

      # Option 3: Build from a Rust checkout
      buildMode: checkout
      checkoutPath: packages/my_package/native/
```

## Cross-compilation Setup

### Android targets

Android cross-compilation requires the Android NDK. Set one of these environment variables before running:

- `ANDROID_NDK_ROOT`
- `ANDROID_NDK_HOME`
- `ANDROID_NDK_LATEST_HOME`

Then run the CLI with `--create-cargo-config` (only once). This generates a `.cargo/config.toml` file with the correct NDK linker paths:

```toml
[target]
aarch64-linux-android.linker="<ndk>/toolchains/llvm/prebuilt/<os>-x86_64/bin/aarch64-linux-android31-clang"
armv7-linux-androideabi.linker="<ndk>/toolchains/llvm/prebuilt/<os>-x86_64/bin/armv7a-linux-androideabi31-clang"
i686-linux-android.linker="<ndk>/toolchains/llvm/prebuilt/<os>-x86_64/bin/i686-linux-android31-clang"
x86_64-linux-android.linker="<ndk>/toolchains/llvm/prebuilt/<os>-x86_64/bin/x86_64-linux-android31-clang"
riscv64-linux-android.linker="<ndk>/toolchains/llvm/prebuilt/<os>-x86_64/bin/riscv64-linux-android35-clang"

[env]
ANDROID_NDK_HOME="<ndk>"
AR="<ndk>/toolchains/llvm/prebuilt/<os>-x86_64/bin/llvm-ar"
CC_aarch64-linux-android="<ndk>/toolchains/llvm/prebuilt/<os>-x86_64/bin/aarch64-linux-android31-clang"
CC_armv7-linux-androideabi="<ndk>/toolchains/llvm/prebuilt/<os>-x86_64/bin/armv7a-linux-androideabi31-clang"
CC_i686-linux-android="<ndk>/toolchains/llvm/prebuilt/<os>-x86_64/bin/i686-linux-android31-clang"
CC_x86_64-linux-android="<ndk>/toolchains/llvm/prebuilt/<os>-x86_64/bin/x86_64-linux-android31-clang"
CC_riscv64-linux-android="<ndk>/toolchains/llvm/prebuilt/<os>-x86_64/bin/riscv64-linux-android35-clang"
```

#### Per-target Android API levels

Pass a comma-separated list of `<target>=<api-level>` pairs to `--android-version`. Entries without a `=` set the default:

```bash
--android-version 'aarch64-linux-android=33,riscv64-linux-android=35,31'
```

This sets API level 33 for `aarch64-linux-android`, 35 for `riscv64-linux-android`, and 31 for all other Android targets.

### Linux cross-compilation from any host

Install the cross-compilation toolchains for your distribution:

```bash
# Ubuntu/Debian
sudo apt-get install \
  gcc-aarch64-linux-gnu gcc-arm-linux-gnueabihf \
  gcc-riscv64-linux-gnu gcc-i686-linux-gnu
```

The generated `.cargo/config.toml` includes linker entries for these.

### Windows: x64 to ARM64 cross-compilation

To cross-compile for `aarch64-pc-windows-msvc` (Windows on ARM) from an x64 host:

1. Install the **ARM64 build tools** via Visual Studio Installer:
   - Open Visual Studio Installer → Modify → Individual components
   - Select **MSVC v143 - VS 2022 C++ ARM64 build tools** (or the version matching your VS installation)
   - Select **Windows 11 SDK** (or Windows 10 SDK)

2. Open a **Developer Command Prompt for VS** and run the ARM64 environment script:

```cmd
"C:\Program Files\Microsoft Visual Studio\18\Community\VC\Auxiliary\Build\vcvarsamd64_arm64.bat"
```

3. Run the build CLI from that same prompt:

```cmd
dart run bin/build_binaries.dart --output-directory platform-build
```

The linker script sets up the environment variables (`LIB`, `INCLUDE`, `PATH`) needed for the MSVC ARM64 cross-compiler toolchain.

### macOS: iOS cross-compilation

Set `SDKROOT` to the Xcode SDK path before building:

```bash
export SDKROOT=$(xcrun --show-sdk-path)
```

## Configuration Reference

### `build_binaries.config.yaml`

| Key | Type | Description |
|-----|------|-------------|
| `outputDirectory` | `String` | Directory for built binaries |
| `assetName` | `String` | Output filename template. Supports `$libraryType`, `$target`, `$output`, `$features`, `$libraryName` |
| `manifestPath` | `String` | Path to `Cargo.toml` (default: `./rust/Cargo.toml`) |
| `buildStatic` | `bool` | Build static libraries (default: false) |
| `buildDynamic` | `bool` | Build dynamic libraries (default: true) |
| `createCargoConfig` | `bool` | Generate `.cargo/config.toml` for Android NDK |
| `androidVersion` | `String` | Android API level or per-target versions |
| `failFast` | `bool` | Stop on first build failure (default: true) |
| `computeSha256` | `bool` | Generate `sha256-hashes.csv` (default: true) |
| `hostSupportedTargets` | `Map<String, List<String>>` | Targets allowed per host OS (`windows`, `linux`, `darwin`). Filters out targets the current host cannot compile. |
| `outputs` | `Map<String, BuildBinariesOutput>` | Named output groups, each with optional `features`, `noDefaultFeatures`, and a list of `targets` |

### `pubspec.yaml` build hook defines

Set under `hooks: user_defines: <package_name>:`:

| Key | Values | Description |
|-----|--------|-------------|
| `buildMode` | `fetch`, `local`, `checkout` | How to obtain the Rust binary |
| `localPath` | filesystem path | Required for `local` mode. Path to the pre-built binary. |
| `checkoutPath` | filesystem path | Required for `checkout` mode. Path to the Rust crate root (containing `Cargo.toml`). |
| `fetchUri` | URL string | Full URL to the binary (for `fetch` mode) |
| `fetchUriBase` | URL string | Base URL; binary name is appended from `assetName` template |
| `features` | comma-separated string | Cargo features to enable |
| `noDefaultFeatures` | `true` / `false` | Disable default Cargo features |
| `libraryName` | string | Library name (default: package name) |
| `assetName` | string | Template for the asset filename |
| `assetsSha256` | map of string → string | Asset name to expected SHA-256 hash |

## CLI Reference

```
--help, -h                  Show usage help
--output-directory, -o      Directory to place built libraries
--config, -c                Path to YAML config file (default: build_binaries.config.yaml)
--manifest-path, -m         Path to Cargo.toml (default: ./rust/Cargo.toml)
--targets, -t               Comma-separated list of Rust targets to build
--features, -f              Comma-separated Cargo features to enable
--no-default-features       Disable default Cargo features
--build-static              Build static libraries
--build-dynamic             Build dynamic libraries (default)
--asset-name                Output filename template (e.g. mylib-$libraryType-$target)
--create-cargo-config       Generate .cargo/config.toml with Android NDK linkers
--no-create-cargo-config    Skip cargo config generation
--android-version           Android API level (default: 31,riscv64-linux-android=35)
--fail-fast                 Stop on first failure (default: true)
--no-fail-fast              Continue building remaining targets on failure
--compute-sha256            Generate sha256-hashes.csv (default: true)
--no-compute-sha256         Skip hash computation
--cargo-project             Path to the Cargo project directory
```

## Complete Example: CI/CD Pipeline

This example shows a GitHub Actions workflow that builds Rust binaries across Linux, macOS, and Windows runners, producing artifacts for all supported targets.

```yaml
# .github/workflows/build_binaries.yaml
name: Build Rust Binaries

on:
  push:
    tags: ['v*']
  workflow_dispatch:

env:
  RUST_TOOLCHAIN: nightly-2025-09-27

jobs:
  build_binaries:
    runs-on: ${{ matrix.os }}
    strategy:
      fail-fast: false
      matrix:
        os: [ubuntu-latest, windows-latest, macos-latest]
    steps:
      - uses: actions/checkout@v4

      - uses: subosito/flutter-action@v2
        with:
          channel: stable

      - run: dart pub global activate melos && melos bs

      - uses: dtolnay/rust-toolchain@master
        with:
          toolchain: ${{ env.RUST_TOOLCHAIN }}

      # Linux: install cross-compilation linkers
      - name: Setup Linux cross-compilation linkers
        if: matrix.os == 'ubuntu-latest'
        run: |
          sudo apt-get update
          sudo apt-get install \
            gcc-aarch64-linux-gnu gcc-arm-linux-gnueabihf \
            gcc-riscv64-linux-gnu gcc-i686-linux-gnu

      # macOS: set SDKROOT for iOS targets
      - name: Set SDKROOT for iOS cross-compilation
        if: matrix.os == 'macos-latest'
        run: |
          echo "SDKROOT=$(xcrun --show-sdk-path)" >> $GITHUB_ENV

      # Build
      - run: dart run bin/build_binaries.dart \
               --create-cargo-config \
               --output-directory ../../platform-build \
               --no-fail-fast
        working-directory: packages/my_package

      # Upload artifacts
      - uses: actions/upload-artifact@v4
        with:
          name: binaries-${{ matrix.os }}
          path: platform-build/
```

After the workflow runs, upload the `platform-build/` contents to your CDN (GitHub Releases, S3, etc.). The build hook in your package's `hook/build.dart` will download the appropriate binary at `dart pub get` time.

### Real-world example

The `wasm_run` package uses this package to build and distribute native Rust binaries for 16+ targets across 3 host OSes. See:

- [`packages/wasm_run/build_binaries.config.yaml`](https://github.com/juancastillo0/wasm_run/blob/main/packages/wasm_run/build_binaries.config.yaml) — multi-output config with wasmi/wasmtime feature variants
- [`packages/wasm_run/hook/build.dart`](https://github.com/juancastillo0/wasm_run/blob/main/packages/wasm_run/hook/build.dart) — fetch-mode build hook with per-target SHA-256 hashes
- [`.github/workflows/build.yaml`](https://github.com/juancastillo0/wasm_run/blob/main/.github/workflows/build.yaml) — the `build_binaries` job in CI

### Template Variables

The `assetName` template supports these variables:

| Variable | Description | Example |
|----------|-------------|---------|
| `$libraryType` | `static` or `dynamic` | `dynamic` |
| `$target` | Rust target triple | `x86_64-unknown-linux-gnu` |
| `$output` | Output group name from config | `my_library-wasmi` |
| `$features` | Comma-separated Cargo features (underscores replace commas) | `wasmi_wasi` |
| `$libraryName` | Library name (from config or Cargo.toml) | `my_library` |

Example template: `$libraryName-$libraryType-$target` produces `my_library-dynamic-x86_64-unknown-linux-gnu`.

## Additional Information

- **Homepage**: [github.com/juancastillo0/wasm_run](https://github.com/juancastillo0/wasm_run)
- **Issue tracker**: [github.com/juancastillo0/wasm_run/issues](https://github.com/juancastillo0/wasm_run/issues)
- **License**: See repository root
