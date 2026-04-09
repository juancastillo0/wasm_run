#!/usr/bin/env bash
# Top-level build script for wasm_run
#
# Usage:
#   ./build.sh clean           - Clean all build artifacts (Rust and Dart)
#   ./build.sh native          - Build native libraries for all platforms
#   ./build.sh native --check  - Check tools needed for native builds
#   ./build.sh dart            - Build Dart packages (pub get + build_runner)
#   ./build.sh all             - Build everything

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${BLUE}ℹ${NC} $*"; }
log_success() { echo -e "${GREEN}✓${NC} $*"; }
log_warn() { echo -e "${YELLOW}⚠${NC} $*"; }
log_error() { echo -e "${RED}✗${NC} $*"; }

# Find all pubspec.yaml files (Dart packages)
find_dart_packages() {
    find "$SCRIPT_DIR/packages" -name "pubspec.yaml" -type f 2>/dev/null | \
        xargs -I{} dirname {} | sort -u
}

# Find all Cargo.toml files (Rust packages)
find_rust_packages() {
    find "$SCRIPT_DIR/packages" -name "Cargo.toml" -type f 2>/dev/null | \
        xargs -I{} dirname {} | sort -u
}

do_clean() {
    log_info "Cleaning all build artifacts..."

    # Clean top-level Rust workspace
    if [[ -d "$SCRIPT_DIR/target" ]]; then
        log_info "Removing top-level Rust target directory"
        rm -rf "$SCRIPT_DIR/target"
    fi

    # Clean cross-rs target directory (separate from main target to avoid GLIBC issues)
    if [[ -d "$SCRIPT_DIR/target-cross" ]]; then
        log_info "Removing cross-rs target directory"
        rm -rf "$SCRIPT_DIR/target-cross"
    fi

    # Clean native library builds
    local native_script="$SCRIPT_DIR/packages/wasm_run/native/scripts/cross-build.sh"
    if [[ -x "$native_script" ]]; then
        log_info "Cleaning native build artifacts"
        "$native_script" --clean
    fi

    # Clean all Rust packages
    log_info "Cleaning Rust packages..."
    while IFS= read -r pkg_dir; do
        if [[ -d "$pkg_dir/target" ]]; then
            log_info "  Removing $pkg_dir/target"
            rm -rf "$pkg_dir/target"
        fi
        if [[ -f "$pkg_dir/Cargo.lock" ]]; then
            rm -f "$pkg_dir/Cargo.lock"
        fi
    done < <(find_rust_packages)

    # Clean all Dart packages
    log_info "Cleaning Dart packages..."
    while IFS= read -r pkg_dir; do
        # Remove build directories
        for dir in build .dart_tool; do
            if [[ -d "$pkg_dir/$dir" ]]; then
                log_info "  Removing $pkg_dir/$dir"
                rm -rf "$pkg_dir/$dir"
            fi
        done
        # Remove pubspec.lock (except in root/examples)
        if [[ -f "$pkg_dir/pubspec.lock" ]]; then
            rm -f "$pkg_dir/pubspec.lock"
        fi
    done < <(find_dart_packages)

    # Clean platform-build directory
    if [[ -d "$SCRIPT_DIR/platform-build" ]]; then
        log_info "Removing platform-build directory"
        rm -rf "$SCRIPT_DIR/platform-build"
    fi

    log_success "Clean complete"
}

do_native() {
    log_info "Building native libraries..."

    local native_script="$SCRIPT_DIR/packages/wasm_run/native/scripts/cross-build.sh"
    if [[ ! -x "$native_script" ]]; then
        log_error "Native build script not found: $native_script"
        exit 1
    fi

    # Pass all arguments to native build script
    # Default to --all --parallel if no arguments
    if [[ $# -eq 0 ]]; then
        "$native_script" --all --parallel
    else
        "$native_script" "$@"
    fi
}

do_dart() {
    log_info "Building Dart packages..."

    # Check for dart/flutter
    local dart_cmd="dart"
    if command -v flutter &>/dev/null; then
        dart_cmd="flutter"
    elif ! command -v dart &>/dev/null; then
        log_error "Neither dart nor flutter found in PATH"
        exit 1
    fi

    while IFS= read -r pkg_dir; do
        log_info "Building: $pkg_dir"
        cd "$pkg_dir"

        # Run pub get
        $dart_cmd pub get || log_warn "pub get failed for $pkg_dir"

        # Run build_runner if available
        if grep -q "build_runner" pubspec.yaml 2>/dev/null; then
            $dart_cmd run build_runner build --delete-conflicting-outputs || \
                log_warn "build_runner failed for $pkg_dir"
        fi

        cd "$SCRIPT_DIR"
    done < <(find_dart_packages)

    log_success "Dart builds complete"
}

usage() {
    cat << EOF
Usage: $0 <command> [options]

Commands:
    clean           Clean all build artifacts (Rust and Dart)
    native [opts]   Build native libraries (passes opts to cross-build.sh)
                    Default: --all --parallel
    dart            Build Dart packages (pub get + build_runner)
    all             Build everything (native + dart)
    help            Show this help message

Native build options (passed to cross-build.sh):
    --check         Check for required tools without building
    --clean         Remove built libraries only
    --linux         Build all Linux targets
    --android       Build all Android targets
    --macos         Build all macOS targets
    --windows       Build all Windows targets
    --ios           Build all iOS targets
    --all           Build all supported targets
    --parallel      Build targets in parallel
    --keep-images   Don't cleanup Docker images

Examples:
    $0 clean                    # Clean everything
    $0 native                   # Build all native targets in parallel
    $0 native --check           # Check native build tools
    $0 native --linux --macos   # Build only Linux and macOS
    $0 dart                     # Build Dart packages
    $0 all                      # Build everything
EOF
}

main() {
    if [[ $# -eq 0 ]]; then
        usage
        exit 0
    fi

    local cmd="$1"
    shift

    case "$cmd" in
        clean)
            do_clean
            ;;
        native)
            do_native "$@"
            ;;
        dart)
            do_dart
            ;;
        all)
            do_native "$@"
            do_dart
            ;;
        help|--help|-h)
            usage
            ;;
        *)
            log_error "Unknown command: $cmd"
            usage
            exit 1
            ;;
    esac
}

main "$@"
