#!/usr/bin/env bash
# Cross-compilation build script for wasm_run_native
# Supports building for multiple targets using cross-rs/cross and osxcross
#
# Docker images are automatically cleaned up after each successful build.
# Use --keep-images to retain Docker images for faster rebuilds.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NATIVE_DIR="$(dirname "$SCRIPT_DIR")"
WORKSPACE_ROOT="$(cd "$NATIVE_DIR/../../.." && pwd)"
TEMP_DIR="${TMPDIR:-/tmp}/wasm_run_cross"

# Configure Docker to use /tmp for temporary files during image pulls
export DOCKER_TMPDIR="${DOCKER_TMPDIR:-/tmp}"

# Output directory for built libraries (committed to git)
OUTPUT_DIR="$NATIVE_DIR/lib"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Supported targets
LINUX_TARGETS=(
    "x86_64-unknown-linux-gnu"
    "aarch64-unknown-linux-gnu"
)

ANDROID_TARGETS=(
    "aarch64-linux-android"
    "armv7-linux-androideabi"
    "x86_64-linux-android"
    "i686-linux-android"
)

MACOS_TARGETS=(
    "x86_64-apple-darwin"
    "aarch64-apple-darwin"
)

WINDOWS_TARGETS=(
    "x86_64-pc-windows-gnu"
)

IOS_TARGETS=(
    "aarch64-apple-ios"
)

# Minimum versions
MIN_RUST_VERSION="1.85.0"

# Docker images
DARWIN_BUILDER_IMAGE="joseluisq/rust-linux-darwin-builder:latest"

# iOS cross-compilation from Linux
# cctools/ld64 is provided by the osxcross Docker image
# iOS SDK is auto-downloaded from xybp888/iOS-SDKs if not set
IOS_SDK_PATH="${IOS_SDK_PATH:-}"
IOS_SDK_REPO="https://github.com/xybp888/iOS-SDKs.git"
IOS_SDK_VERSION="iPhoneOS18.4.sdk"

# Temp directory for downloaded SDKs (cleaned up at exit)
SDK_TEMP_DIR=""

# ============================================================================
# Utility functions
# ============================================================================

log_info() { echo -e "${BLUE}ℹ${NC} $*"; }
log_success() { echo -e "${GREEN}✓${NC} $*"; }
log_warn() { echo -e "${YELLOW}⚠${NC} $*"; }
log_error() { echo -e "${RED}✗${NC} $*"; }

ensure_temp_dir() {
    mkdir -p "$TEMP_DIR"
    echo "$TEMP_DIR"
}

check_disk_space() {
    local required_gb="${1:-10}"
    local avail_kb=$(df / | tail -1 | awk '{print $4}')
    local avail_gb=$((avail_kb / 1024 / 1024))

    if [[ $avail_gb -lt $required_gb ]]; then
        log_warn "Low disk space: ${avail_gb}GB available (recommended: ${required_gb}GB)"
        log_info "Cleaning up Docker to free space..."
        docker system prune -af --volumes 2>/dev/null || true
        return 1
    fi
    log_success "Disk space: ${avail_gb}GB available"
    return 0
}

cleanup_docker_image() {
    local image="$1"
    if [[ -n "$KEEP_DOCKER_IMAGES" ]]; then
        return 0
    fi
    log_info "Cleaning up Docker resources for: $image"

    # Stop and remove any containers using this image
    local containers=$(docker ps -aq --filter "ancestor=$image" 2>/dev/null)
    if [[ -n "$containers" ]]; then
        docker stop $containers 2>/dev/null || true
        docker rm $containers 2>/dev/null || true
    fi

    # Remove the image
    docker rmi "$image" 2>/dev/null || true

    # Clean up dangling images, stopped containers, and unused networks
    docker system prune -f 2>/dev/null || true

    # Remove dangling volumes only (not named volumes)
    docker volume prune -f 2>/dev/null || true
}

# ============================================================================
# Tool checking functions
# ============================================================================

errors=()

check_command() {
    local cmd="$1"
    local install_hint="$2"
    if ! command -v "$cmd" &> /dev/null; then
        errors+=("$cmd not found. $install_hint")
        return 1
    fi
    return 0
}

check_rust_version() {
    if ! command -v rustc &> /dev/null; then
        errors+=("rustc not found. Install via: curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh")
        return 1
    fi

    local version=$(rustc --version | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
    if [[ "$(printf '%s\n' "$MIN_RUST_VERSION" "$version" | sort -V | head -n1)" != "$MIN_RUST_VERSION" ]]; then
        errors+=("Rust version $version is too old. Minimum required: $MIN_RUST_VERSION. Run: rustup update")
        return 1
    fi
    log_success "rustc $version"
    return 0
}

check_cargo() {
    if ! command -v cargo &> /dev/null; then
        errors+=("cargo not found. Install via: curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh")
        return 1
    fi
    local version=$(cargo --version | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
    log_success "cargo $version"
    return 0
}

check_docker() {
    if ! command -v docker &> /dev/null; then
        errors+=("docker not found. Install Docker from https://docs.docker.com/get-docker/")
        return 1
    fi

    if ! docker info &> /dev/null; then
        errors+=("Docker daemon not running or permission denied. Try: sudo systemctl start docker")
        return 1
    fi

    local version=$(docker --version | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
    log_success "docker $version (running)"
    return 0
}

ensure_cross_installed() {
    local cross_path="${HOME}/.cargo/bin/cross"
    if [[ ! -x "$cross_path" ]] && ! command -v cross &> /dev/null; then
        log_info "Installing cross-rs/cross..." >&2
        cargo install cross --git https://github.com/cross-rs/cross >&2
    fi

    local cross_cmd="cross"
    if [[ -x "$cross_path" ]]; then
        cross_cmd="$cross_path"
    fi

    local version=$("$cross_cmd" --version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' || echo "unknown")
    log_success "cross $version" >&2
    echo "$cross_cmd"
}

check_rust_target() {
    local target="$1"
    if ! rustup target list --installed | grep -q "^${target}$"; then
        log_info "Installing Rust target: $target"
        rustup target add "$target"
    fi
    log_success "target: $target"
    return 0
}

is_macos() {
    [[ "$(uname -s)" == "Darwin" ]]
}

# ============================================================================
# Build functions
# ============================================================================

copy_output() {
    local target="$1"
    local ext="$2"
    local src="$WORKSPACE_ROOT/target/$target/release"
    local dst="$OUTPUT_DIR/$target"

    mkdir -p "$dst"

    # Try with "lib" prefix first (Linux/macOS), then without (Windows)
    local lib_name
    if [[ -f "$src/libwasm_run_native.$ext" ]]; then
        lib_name="libwasm_run_native.$ext"
    elif [[ -f "$src/wasm_run_native.$ext" ]]; then
        lib_name="wasm_run_native.$ext"
    else
        return 1
    fi

    cp "$src/$lib_name" "$dst/"
    local size=$(du -h "$dst/$lib_name" | cut -f1)
    log_success "$target: $lib_name ($size)"
    return 0
}

build_native() {
    log_info "Building native (host) target..."
    cd "$NATIVE_DIR"
    cargo build --release

    local target
    case "$(uname -s)-$(uname -m)" in
        Linux-x86_64)  target="x86_64-unknown-linux-gnu" ;;
        Linux-aarch64) target="aarch64-unknown-linux-gnu" ;;
        Darwin-x86_64) target="x86_64-apple-darwin" ;;
        Darwin-arm64)  target="aarch64-apple-darwin" ;;
        *) log_error "Unknown host platform"; return 1 ;;
    esac

    # Native build goes to target/release, copy to appropriate location
    mkdir -p "$OUTPUT_DIR/$target"
    if [[ -f "$WORKSPACE_ROOT/target/release/libwasm_run_native.so" ]]; then
        cp "$WORKSPACE_ROOT/target/release/libwasm_run_native.so" "$OUTPUT_DIR/$target/"
    elif [[ -f "$WORKSPACE_ROOT/target/release/libwasm_run_native.dylib" ]]; then
        cp "$WORKSPACE_ROOT/target/release/libwasm_run_native.dylib" "$OUTPUT_DIR/$target/"
    fi
    log_success "Native build complete"
}

build_with_cross() {
    local target="$1"
    local cross_cmd="$2"

    log_info "Building for $target with cross..."

    # Check disk space before cross (which pulls Docker images)
    check_disk_space 10 || true

    # Run cross from workspace root so that CROSS_REMOTE mounts everything correctly
    # and outputs go to $WORKSPACE_ROOT/target/$target/release/
    cd "$WORKSPACE_ROOT"

    # Use CROSS_REMOTE=1 to build entirely in container (avoids glibc mismatch on newer hosts)
    # Build only the wasm_run_native package
    CROSS_REMOTE=1 "$cross_cmd" build --release --target="$target" -p wasm_run_native
    local result=$?

    # Determine extension
    local ext="so"
    case "$target" in
        *windows*) ext="dll" ;;
        *darwin*|*ios*) ext="dylib" ;;
    esac

    if [[ $result -eq 0 ]]; then
        # Copy output from workspace target directory
        # Windows DLLs don't have "lib" prefix, so check both naming conventions
        if ! copy_output "$target" "$ext"; then
            log_error "Could not find build output for $target"
            result=1
        fi
    fi

    # Cleanup cross Docker images after build
    local cross_image="ghcr.io/cross-rs/${target}:main"
    cleanup_docker_image "$cross_image"

    return $result
}

build_macos_with_docker() {
    local target="$1"

    log_info "Building for $target with osxcross Docker..."

    # Check disk space before pulling large image
    check_disk_space 15 || true

    # Create temp dir for cargo cache
    local cargo_tmp=$(mktemp -d)
    trap "rm -rf '$cargo_tmp'" EXIT

    # Run from workspace root and build only wasm_run_native package
    # Use CARGO_HOME in temp dir to avoid filling up container storage
    # Install required Rust version and set CC/CXX/linker to osxcross clang
    local cc_var="CC"
    local linker_var="CARGO_TARGET_X86_64_APPLE_DARWIN_LINKER"
    local cc_val="o64-clang"

    if [[ "$target" == "aarch64-apple-darwin" ]]; then
        linker_var="CARGO_TARGET_AARCH64_APPLE_DARWIN_LINKER"
        cc_val="aarch64-apple-darwin22.4-clang"
    fi

    docker run --rm \
        -v "$WORKSPACE_ROOT:/app" \
        -v "$cargo_tmp:/cargo" \
        -e "CARGO_HOME=/cargo" \
        -e "RUSTUP_HOME=/cargo/rustup" \
        -e "CC=$cc_val" \
        -e "CXX=${cc_val}++" \
        -e "$linker_var=$cc_val" \
        -w "/app" \
        "$DARWIN_BUILDER_IMAGE" \
        sh -c "rustup default 1.93.0 && rustup target add $target && cargo build --release --target=$target -p wasm_run_native"

    local result=$?

    # Cleanup temp cargo dir
    rm -rf "$cargo_tmp" 2>/dev/null || true
    trap - EXIT

    # Cleanup Docker image after build
    cleanup_docker_image "$DARWIN_BUILDER_IMAGE"

    if [[ $result -eq 0 ]]; then
        copy_output "$target" "dylib"
    fi
    return $result
}

build_macos_native() {
    local target="$1"

    log_info "Building for $target (native macOS)..."
    cd "$WORKSPACE_ROOT"
    cargo build --release --target="$target" -p wasm_run_native

    copy_output "$target" "dylib"
}

build_ios_native() {
    local target="$1"

    log_info "Building for $target (native iOS - requires Xcode)..."
    cd "$WORKSPACE_ROOT"
    cargo build --release --target="$target" -p wasm_run_native

    # iOS uses static libraries (.a)
    copy_output "$target" "a"
}

# Check if iOS SDK is available for cross-compilation
has_ios_sdk() {
    [[ -n "$IOS_SDK_PATH" ]] && [[ -d "$IOS_SDK_PATH" ]] && \
    [[ -f "$IOS_SDK_PATH/SDKSettings.plist" || -d "$IOS_SDK_PATH/usr/include" ]]
}

# Download iOS SDK to temp directory (Linux/Windows only, not needed on macOS)
download_ios_sdk() {
    if is_macos; then
        log_info "macOS detected - using Xcode SDK, skipping download"
        return 0
    fi

    if has_ios_sdk; then
        log_info "iOS SDK already available at: $IOS_SDK_PATH"
        return 0
    fi

    log_info "Downloading iOS SDK from $IOS_SDK_REPO..."

    # Create temp directory for SDK
    SDK_TEMP_DIR=$(mktemp -d)
    trap 'cleanup_sdk_temp' EXIT

    # Use git sparse checkout to only download the SDK we need
    cd "$SDK_TEMP_DIR"
    git init -q
    git remote add origin "$IOS_SDK_REPO"
    git config core.sparseCheckout true
    echo "$IOS_SDK_VERSION/" > .git/info/sparse-checkout

    log_info "Fetching $IOS_SDK_VERSION (this may take a few minutes)..."
    if ! git pull --depth=1 origin master 2>/dev/null; then
        log_error "Failed to download iOS SDK"
        return 1
    fi

    IOS_SDK_PATH="$SDK_TEMP_DIR/$IOS_SDK_VERSION"
    if [[ ! -d "$IOS_SDK_PATH" ]]; then
        log_error "iOS SDK not found after download"
        return 1
    fi

    log_success "iOS SDK downloaded to: $IOS_SDK_PATH"
    return 0
}

# Cleanup temp SDK directory
cleanup_sdk_temp() {
    if [[ -n "$SDK_TEMP_DIR" ]] && [[ -d "$SDK_TEMP_DIR" ]]; then
        log_info "Cleaning up temporary iOS SDK..."
        rm -rf "$SDK_TEMP_DIR"
    fi
}


build_ios_with_docker() {
    local target="$1"

    log_info "Building for $target with osxcross Docker + iOS SDK..."

    if [[ ! -d "$IOS_SDK_PATH" ]]; then
        log_error "iOS SDK not found at: $IOS_SDK_PATH"
        log_info "Download from: https://github.com/xybp888/iOS-SDKs"
        return 1
    fi

    # Check disk space before pulling image
    check_disk_space 15 || true

    # Create temp dir for cargo cache
    local cargo_tmp=$(mktemp -d)
    trap "rm -rf '$cargo_tmp'" EXIT

    local arch="arm64"
    local min_ios_version="12.0"
    if [[ "$target" == "x86_64-apple-ios" ]]; then
        arch="x86_64"
    fi

    local ios_target="${arch}-apple-ios${min_ios_version}"

    # The osxcross Docker image has cctools with ld64 that supports iOS
    # Mount the iOS SDK and use it with the existing toolchain
    # Use aarch64-apple-darwin clang as linker driver (it calls ld64 internally)
    local osxcross_bin="/usr/local/osxcross/target/bin"
    docker run --rm \
        -v "$WORKSPACE_ROOT:/app" \
        -v "$cargo_tmp:/cargo" \
        -v "$IOS_SDK_PATH:/ios-sdk:ro" \
        -e "CARGO_HOME=/cargo" \
        -e "RUSTUP_HOME=/cargo/rustup" \
        -e "SDKROOT=/ios-sdk" \
        -e "CC=clang" \
        -e "CXX=clang++" \
        -e "CFLAGS=-target $ios_target -isysroot /ios-sdk" \
        -e "CXXFLAGS=-target $ios_target -isysroot /ios-sdk" \
        -e "CARGO_TARGET_AARCH64_APPLE_IOS_LINKER=$osxcross_bin/aarch64-apple-darwin22.4-clang" \
        -e "RUSTFLAGS=-C link-arg=-target -C link-arg=$ios_target -C link-arg=-isysroot -C link-arg=/ios-sdk -C link-arg=-fuse-ld=$osxcross_bin/aarch64-apple-darwin22.4-ld" \
        -w "/app" \
        "$DARWIN_BUILDER_IMAGE" \
        sh -c "export PATH=$osxcross_bin:\$PATH && rustup default 1.93.0 && rustup target add $target && cargo build --release --target=$target -p wasm_run_native"

    local result=$?

    # Cleanup temp cargo dir
    rm -rf "$cargo_tmp" 2>/dev/null || true
    trap - EXIT

    # Cleanup Docker image after build
    cleanup_docker_image "$DARWIN_BUILDER_IMAGE"

    if [[ $result -eq 0 ]]; then
        # iOS can use either .a (static) or .dylib (dynamic) - try both
        copy_output "$target" "dylib" || copy_output "$target" "a"
    fi
    return $result
}


build_target() {
    local target="$1"
    local cross_cmd="$2"

    case "$target" in
        x86_64-unknown-linux-gnu)
            if [[ "$(uname -s)-$(uname -m)" == "Linux-x86_64" ]]; then
                build_native
            else
                build_with_cross "$target" "$cross_cmd"
            fi
            ;;
        aarch64-unknown-linux-gnu|*-linux-android*)
            build_with_cross "$target" "$cross_cmd"
            ;;
        *-apple-darwin*)
            if is_macos; then
                build_macos_native "$target"
            else
                build_macos_with_docker "$target"
            fi
            ;;
        *-apple-ios*)
            if is_macos; then
                build_ios_native "$target"
            else
                # Auto-download iOS SDK if not available
                if ! has_ios_sdk; then
                    download_ios_sdk || return 1
                fi
                build_ios_with_docker "$target"
            fi
            ;;
        *-windows-gnu*)
            build_with_cross "$target" "$cross_cmd"
            ;;
        *)
            log_error "Unknown target: $target"
            return 1
            ;;
    esac
}

# ============================================================================
# Parallel build support
# ============================================================================

build_targets_parallel() {
    local cross_cmd="$1"
    shift
    local targets=("$@")
    local pids=()
    local results_dir=$(mktemp -d)
    local start_time=$(date +%s)

    log_info "Building ${#targets[@]} targets in parallel..."
    echo ""

    for target in "${targets[@]}"; do
        (
            local target_start=$(date +%s)
            if build_target "$target" "$cross_cmd" > "$results_dir/$target.log" 2>&1; then
                local target_end=$(date +%s)
                echo "success $((target_end - target_start))" > "$results_dir/$target.status"
            else
                local target_end=$(date +%s)
                echo "failed $((target_end - target_start))" > "$results_dir/$target.status"
            fi
        ) &
        pids+=($!)
    done

    # Wait for all builds to complete
    for pid in "${pids[@]}"; do
        wait "$pid" 2>/dev/null || true
    done

    local end_time=$(date +%s)
    local total_time=$((end_time - start_time))

    # Collect and display results
    echo ""
    echo -e "${YELLOW}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}                    PARALLEL BUILD RESULTS${NC}"
    echo -e "${YELLOW}═══════════════════════════════════════════════════════════════${NC}"
    echo ""

    local succeeded=()
    local failed=()

    for target in "${targets[@]}"; do
        if [[ -f "$results_dir/$target.status" ]]; then
            read status duration < "$results_dir/$target.status"
            if [[ "$status" == "success" ]]; then
                succeeded+=("$target")
                echo -e "  ${GREEN}✓${NC} $target (${duration}s)"
            else
                failed+=("$target")
                echo -e "  ${RED}✗${NC} $target (${duration}s)"
            fi
        else
            failed+=("$target")
            echo -e "  ${RED}✗${NC} $target (unknown status)"
        fi
    done

    echo ""
    echo -e "${YELLOW}───────────────────────────────────────────────────────────────${NC}"
    echo -e "  Total time: ${total_time}s"
    echo -e "  Succeeded:  ${#succeeded[@]}/${#targets[@]}"
    if [[ ${#failed[@]} -gt 0 ]]; then
        echo -e "  ${RED}Failed:     ${#failed[@]}${NC}"
    fi
    echo -e "${YELLOW}═══════════════════════════════════════════════════════════════${NC}"

    # Show failed build logs
    if [[ ${#failed[@]} -gt 0 ]]; then
        echo ""
        echo -e "${RED}Failed build logs:${NC}"
        for target in "${failed[@]}"; do
            echo ""
            echo -e "${RED}─── $target ───${NC}"
            if [[ -f "$results_dir/$target.log" ]]; then
                tail -50 "$results_dir/$target.log"
            fi
        done
    fi

    # Cleanup
    rm -rf "$results_dir"

    if [[ ${#failed[@]} -gt 0 ]]; then
        return 1
    fi

    return 0
}

# ============================================================================
# Clean functions
# ============================================================================

do_clean() {
    log_info "Cleaning native build artifacts..."

    # Clean built libraries
    if [[ -d "$OUTPUT_DIR" ]]; then
        log_info "Removing built libraries: $OUTPUT_DIR"
        rm -rf "$OUTPUT_DIR"
    fi

    # Clean workspace target directory
    if [[ -d "$WORKSPACE_ROOT/target" ]]; then
        log_info "Removing Rust target directory: $WORKSPACE_ROOT/target"
        rm -rf "$WORKSPACE_ROOT/target"
    fi

    # Clean temp directory
    if [[ -d "$TEMP_DIR" ]]; then
        log_info "Removing temp directory: $TEMP_DIR"
        rm -rf "$TEMP_DIR"
    fi

    # Clean SDK temp if it exists
    cleanup_sdk_temp

    log_success "Clean complete"
}

# ============================================================================
# Main
# ============================================================================

usage() {
    cat << EOF
Usage: $0 [OPTIONS] [TARGETS...]

Cross-compilation build script for wasm_run_native.

Options:
    --check          Check for required tools without building
    --clean          Remove all built libraries and build artifacts
    --native         Build only native (host) target
    --linux          Build all Linux targets
    --android        Build all Android targets
    --macos          Build all macOS targets
    --windows        Build all Windows targets
    --ios            Build all iOS targets (auto-downloads SDK on Linux)
    --all            Build all supported targets
    --parallel       Build targets in parallel (default: sequential)
    --keep-images    Don't cleanup Docker images after builds (faster rebuilds)
    -h, --help       Show this help message

Targets:
    x86_64-unknown-linux-gnu    Linux x64
    aarch64-unknown-linux-gnu   Linux ARM64
    aarch64-linux-android       Android ARM64
    armv7-linux-androideabi     Android ARM32
    x86_64-linux-android        Android x64
    i686-linux-android          Android x86
    x86_64-apple-darwin         macOS x64
    aarch64-apple-darwin        macOS ARM64
    x86_64-pc-windows-gnu       Windows x64
    aarch64-apple-ios           iOS ARM64

Output:
    Built libraries are placed in: $OUTPUT_DIR/<target>/

Examples:
    $0 --check                              # Check tools only
    $0 --native                             # Build for host
    $0 --android --parallel                 # Build all Android in parallel
    $0 aarch64-unknown-linux-gnu            # Build Linux ARM64
    $0 --all --parallel                     # Build everything in parallel
EOF
}

check_all_tools() {
    echo -e "${YELLOW}Checking required tools...${NC}\n"

    check_rust_version
    check_cargo
    check_docker || true  # Docker optional for native builds

    if [[ ${#errors[@]} -gt 0 ]]; then
        echo -e "\n${RED}Missing or misconfigured tools:${NC}"
        for err in "${errors[@]}"; do
            echo -e "  ${RED}✗${NC} $err"
        done
        return 1
    fi

    echo -e "\n${GREEN}All required tools configured correctly!${NC}"
    return 0
}

main() {
    local targets=()
    local check_only=false
    local clean_only=false
    local native_only=false
    local parallel=false

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --check)
                check_only=true
                shift
                ;;
            --clean)
                clean_only=true
                shift
                ;;
            --native)
                native_only=true
                shift
                ;;
            --linux)
                targets+=("${LINUX_TARGETS[@]}")
                shift
                ;;
            --android)
                targets+=("${ANDROID_TARGETS[@]}")
                shift
                ;;
            --macos)
                targets+=("${MACOS_TARGETS[@]}")
                shift
                ;;
            --windows)
                targets+=("${WINDOWS_TARGETS[@]}")
                shift
                ;;
            --ios)
                targets+=("${IOS_TARGETS[@]}")
                shift
                ;;
            --all)
                targets+=("${LINUX_TARGETS[@]}" "${ANDROID_TARGETS[@]}" "${MACOS_TARGETS[@]}" "${WINDOWS_TARGETS[@]}" "${IOS_TARGETS[@]}")
                shift
                ;;
            --parallel)
                parallel=true
                shift
                ;;
            --keep-images)
                export KEEP_DOCKER_IMAGES=1
                shift
                ;;
            -h|--help)
                usage
                exit 0
                ;;
            -*)
                echo "Unknown option: $1"
                usage
                exit 1
                ;;
            *)
                targets+=("$1")
                shift
                ;;
        esac
    done

    # Always check basic tools
    if ! check_all_tools; then
        echo -e "\n${RED}Please install missing tools before building.${NC}"
        exit 1
    fi

    if $check_only; then
        exit 0
    fi

    if $clean_only; then
        do_clean
        exit 0
    fi

    # Ensure cross is installed
    local cross_cmd
    cross_cmd=$(ensure_cross_installed)

    # Ensure targets are installed
    for target in "${targets[@]}"; do
        check_rust_target "$target" || true
    done

    if $native_only; then
        build_native
        exit 0
    fi

    if [[ ${#targets[@]} -eq 0 ]]; then
        echo -e "\n${YELLOW}No targets specified. Use --help for usage.${NC}"
        exit 0
    fi

    # Create output directory
    mkdir -p "$OUTPUT_DIR"

    # Build targets
    local failed=()
    if $parallel; then
        build_targets_parallel "$cross_cmd" "${targets[@]}" || true
    else
        for target in "${targets[@]}"; do
            if ! build_target "$target" "$cross_cmd"; then
                failed+=("$target")
            fi
        done
    fi

    # Summary
    echo -e "\n${YELLOW}Build Summary:${NC}"
    echo "  Output directory: $OUTPUT_DIR"
    echo "  Attempted: ${#targets[@]}"

    local built=$(find "$OUTPUT_DIR" -name "libwasm_run_native.*" 2>/dev/null | wc -l)
    echo "  Built: $built"

    if [[ ${#failed[@]} -gt 0 ]]; then
        echo -e "\n${RED}Failed targets:${NC}"
        for t in "${failed[@]}"; do
            echo "  - $t"
        done
        exit 1
    fi

    echo -e "\n${GREEN}All builds completed successfully!${NC}"
}

main "$@"
