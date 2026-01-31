# Custom osxcross image with Rust 1.93+ for wasmtime compatibility
# Runs as root but output ownership is fixed by the build script
#
# Based on joseluisq/rust-linux-darwin-builder

FROM joseluisq/rust-linux-darwin-builder:latest

ARG RUST_VERSION=1.93.0

# Install required Rust version and cross-compilation targets
# The base image has Rust 1.87.0 but wasmtime requires 1.90+
RUN rustup install $RUST_VERSION && \
    rustup default $RUST_VERSION && \
    rustup target add x86_64-apple-darwin aarch64-apple-darwin aarch64-apple-ios
