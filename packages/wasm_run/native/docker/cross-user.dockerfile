# Custom cross-rs image that runs as non-root user
# This ensures build artifacts are owned by the host user, not root
#
# Usage: Configured via Cross.toml with build-args for USER_ID and GROUP_ID

ARG CROSS_BASE_IMAGE
FROM $CROSS_BASE_IMAGE

ARG USER_ID=1000
ARG GROUP_ID=1000

# Create non-root user and make root's rustup/cargo accessible (not copied)
# This avoids doubling disk usage during build
RUN groupadd -g $GROUP_ID builder 2>/dev/null || true && \
    useradd -m -u $USER_ID -g $GROUP_ID -s /bin/bash builder 2>/dev/null || true && \
    mkdir -p /cargo /rust /home/builder/.cargo && \
    chown -R $USER_ID:$GROUP_ID /cargo /rust /home/builder 2>/dev/null || true && \
    if [ -d /root/.rustup ]; then chmod -R a+rX /root/.rustup; fi && \
    if [ -d /root/.cargo ]; then chmod -R a+rX /root/.cargo; fi

USER builder
ENV HOME=/home/builder
ENV CARGO_HOME=/home/builder/.cargo
ENV RUSTUP_HOME=/root/.rustup
ENV PATH="/root/.cargo/bin:${PATH}"
