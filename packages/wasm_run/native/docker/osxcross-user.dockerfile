# Custom osxcross image that runs as non-root user
# This ensures build artifacts are owned by the host user, not root
#
# Based on joseluisq/rust-linux-darwin-builder

FROM joseluisq/rust-linux-darwin-builder:latest

ARG USER_ID=1000
ARG GROUP_ID=1000

# Create non-root user and make root's rustup/cargo accessible (not copied)
# This avoids doubling disk usage during build
RUN groupadd -g $GROUP_ID builder 2>/dev/null || true && \
    useradd -m -u $USER_ID -g $GROUP_ID -s /bin/bash builder 2>/dev/null || true && \
    chmod -R a+rX /root/.cargo /root/.rustup && \
    mkdir -p /home/builder/.cargo && \
    chown -R $USER_ID:$GROUP_ID /home/builder

USER builder
ENV HOME=/home/builder
ENV CARGO_HOME=/home/builder/.cargo
ENV RUSTUP_HOME=/root/.rustup
ENV PATH="/root/.cargo/bin:/usr/local/osxcross/target/bin:${PATH}"
