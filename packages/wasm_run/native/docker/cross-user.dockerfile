# Custom cross-rs image that runs as non-root user
# This ensures build artifacts are owned by the host user, not root
#
# Usage: Configured via Cross.toml with build-args for USER_ID and GROUP_ID

ARG CROSS_BASE_IMAGE
FROM $CROSS_BASE_IMAGE

ARG USER_ID=1000
ARG GROUP_ID=1000

# Create non-root user matching host user's UID/GID
RUN groupadd -g $GROUP_ID builder 2>/dev/null || true && \
    useradd -m -u $USER_ID -g $GROUP_ID -s /bin/bash builder 2>/dev/null || true && \
    mkdir -p /cargo /rust && \
    chown -R $USER_ID:$GROUP_ID /cargo /rust 2>/dev/null || true

# Ensure rustup/cargo directories are accessible
RUN if [ -d /root/.rustup ]; then \
        cp -r /root/.rustup /home/builder/.rustup && \
        chown -R $USER_ID:$GROUP_ID /home/builder/.rustup; \
    fi && \
    if [ -d /root/.cargo ]; then \
        cp -r /root/.cargo /home/builder/.cargo && \
        chown -R $USER_ID:$GROUP_ID /home/builder/.cargo; \
    fi

USER builder
ENV HOME=/home/builder
ENV CARGO_HOME=/home/builder/.cargo
ENV RUSTUP_HOME=/home/builder/.rustup
ENV PATH="/home/builder/.cargo/bin:${PATH}"
