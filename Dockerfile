# Base image for CUDA 11.8 and cuDNN 8
FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu22.04

# Install packages with cleanup
RUN apt-get update \
    && apt-get install -y \
    build-essential \
    wget \
    unzip \
    curl \
    pkg-config \
    libssl-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
# Specify Rust version to 1.71.1
RUN $HOME/.cargo/bin/rustup install 1.71.1 \
    && $HOME/.cargo/bin/rustup default 1.71.1
# Set environment variables for Cargo
ENV PATH="/root/.cargo/bin:${PATH}"
# Setup Rust components and tools
RUN rustup component add \
    rls \
    rust-analysis \
    rust-src \
    rustfmt \
    clippy \
    && cargo install \
    cargo-edit \
    cargo-watch
# Set environment variables for Rust logging
ENV RUST_LOG=info

# Set working directory
WORKDIR /workspace
