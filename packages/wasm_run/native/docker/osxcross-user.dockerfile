# Custom osxcross image - NOT USED due to disk space constraints
# The osxcross base image is ~6GB and adding layers exceeds typical root partition space
#
# Instead, cross-build.sh runs the base image as root and fixes ownership after build
# with: sudo chown -R $(id -u):$(id -g) target/
#
# This file is kept for reference in case disk space is available in the future.

FROM joseluisq/rust-linux-darwin-builder:latest

ARG USER_ID=1000
ARG GROUP_ID=1000

# Create non-root user and copy root's rustup/cargo to the new user
RUN groupadd -g $GROUP_ID builder 2>/dev/null || true && \
    useradd -m -u $USER_ID -g $GROUP_ID -s /bin/bash builder 2>/dev/null || true && \
    cp -r /root/.cargo /home/builder/.cargo && \
    cp -r /root/.rustup /home/builder/.rustup && \
    chown -R $USER_ID:$GROUP_ID /home/builder

USER builder
ENV HOME=/home/builder
ENV CARGO_HOME=/home/builder/.cargo
ENV RUSTUP_HOME=/home/builder/.rustup
ENV PATH="/home/builder/.cargo/bin:/usr/local/osxcross/target/bin:${PATH}"
