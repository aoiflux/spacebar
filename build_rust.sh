#!/bin/bash
# Cross-platform script to build Rust library for different targets

set -e  # Exit on error

RUST_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/rust"

echo "Building Rust library for current platform..."

cd "$RUST_DIR"

# Determine the platform
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    PLATFORM="linux"
    TARGET="x86_64-unknown-linux-gnu"
    LIB_NAME="libspacebar_crypto.so"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    PLATFORM="macos"
    # Detect architecture
    if [[ $(uname -m) == "arm64" ]]; then
        TARGET="aarch64-apple-darwin"
    else
        TARGET="x86_64-apple-darwin"
    fi
    LIB_NAME="libspacebar_crypto.dylib"
else
    echo "Unsupported platform: $OSTYPE"
    exit 1
fi

echo "Platform: $PLATFORM"
echo "Target: $TARGET"
echo "Library: $LIB_NAME"

# Add target if not already added
rustup target add "$TARGET"

# Build
cargo build --release --target "$TARGET"

OUTPUT_LIB="target/$TARGET/release/$LIB_NAME"

if [ -f "$OUTPUT_LIB" ]; then
    echo ""
    echo "✓ Build successful!"
    echo "Library location: $OUTPUT_LIB"
else
    echo ""
    echo "✗ Build failed - library not found"
    exit 1
fi
