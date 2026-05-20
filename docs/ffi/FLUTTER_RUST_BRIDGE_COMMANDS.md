# Flutter Rust Bridge - Step-by-Step Setup Commands

Copy and paste these commands to set up Flutter Rust Bridge. All commands assume
you're in the project root directory.

## One-Command Setup (Copy-Paste)

```bash
# Install code generator
cargo install flutter_rust_bridge_codegen

# Generate bindings
flutter_rust_bridge_codegen generate

# Get Flutter dependencies
flutter pub get

# Build for your platform
flutter build windows
```

---

## Step-by-Step Instructions

### Step 1: Install Code Generator

```bash
# This takes 2-3 minutes
cargo install flutter_rust_bridge_codegen

# Verify installation
flutter_rust_bridge_codegen --version
```

**Expected output**: `flutter_rust_bridge_codegen X.X.X`

### Step 2: Generate FFI Bindings

```bash
# From project root directory
flutter_rust_bridge_codegen generate
```

**Expected output**:

```
Generating Dart bindings...
Generated lib/generated/rust/frb_generated.dart
Success!
```

**What this does**:

- Reads `rust/src/lib.rs`
- Reads `flutter_rust_bridge.yaml`
- Generates `lib/generated/rust/frb_generated.dart` (auto-generated, don't
  edit!)
- Creates FFI wrappers for all `pub fn` in Rust

### Step 3: Update Dart Dependencies

```bash
# Get/update packages
flutter pub get

# Optional: upgrade packages
flutter pub upgrade
```

**Expected output**: `Got dependencies` or `Upgraded X packages`

### Step 4: Build Rust Library

```bash
# This compiles the Rust code
cd rust
cargo build --release
cd ..

# Verify build
ls -la rust/target/release/

# Windows:
ls rust/target/release/*.dll

# Linux:
ls rust/target/release/*.so

# macOS:
ls rust/target/release/*.dylib
```

**Expected output**: Library file (.dll, .so, or .dylib) present

### Step 5: Build Flutter App

```bash
# For Windows
flutter build windows --release

# For macOS
flutter build macos --release

# For Linux
flutter build linux --release

# For iOS
flutter build ios --release

# For Android
flutter build apk --release
```

**Expected output**: Build completes successfully

**Note**: First build may take 2-3 minutes as it compiles everything.

### Step 6: Run App

```bash
# Debug build (fast, for testing)
flutter run

# Release build (optimized, for production)
flutter run --release
```

---

## Troubleshooting Commands

### If Build Fails

```bash
# Clean everything
flutter clean

# Remove Rust build artifacts
cd rust
cargo clean
cd ..

# Try again
flutter_rust_bridge_codegen generate
flutter pub get
flutter build windows
```

### Check if Rust Compiles

```bash
cd rust
cargo test

# Should see:
# test test_sha3_hash ... ok
# test test_blake3_hash ... ok
```

### Verify Generated Code

```bash
# View generated Dart code
cat lib/generated/rust/frb_generated.dart

# Should contain:
# - class CryptoApi
# - sha3Hash method
# - blake3Hash method
```

### Check Library File Size

```bash
# Windows
dir rust/target/release/spacebar_crypto.dll

# Linux/macOS
ls -lh rust/target/release/lib*

# Should be 2-4 MB (not just a few KB)
```

---

## Development Workflow Commands

### After Modifying `rust/src/lib.rs`

```bash
# Step 1: Verify Rust code compiles
cd rust
cargo test

# Step 2: Regenerate Dart bindings
flutter_rust_bridge_codegen generate

# Step 3: Update Flutter
flutter pub get

# Step 4: Rebuild
flutter build windows
```

### Quick Rebuild

```bash
# One-liner after changing Rust code
flutter_rust_bridge_codegen generate && flutter build windows
```

### Test Only (No Build)

```bash
# Just run Rust tests
cd rust && cargo test

# Just check Rust syntax
cd rust && cargo check
```

---

## Platform-Specific Commands

### Windows

```bash
# Install target
rustup target add x86_64-pc-windows-msvc

# Build
flutter build windows --release

# Run
flutter run -d windows
```

### macOS

```bash
# Install targets
rustup target add aarch64-apple-darwin  # Apple Silicon
rustup target add x86_64-apple-darwin   # Intel

# Build for current machine
flutter build macos --release

# Run
flutter run -d macos
```

### Linux

```bash
# Install dependencies (Ubuntu/Debian)
sudo apt-get update
sudo apt-get install build-essential libclang-dev

# Build
flutter build linux --release

# Run
flutter run -d linux
```

### iOS

```bash
# Build (automatic static linking)
flutter build ios --release

# To run on simulator:
flutter run -d ios
```

### Android

```bash
# Build APK
flutter build apk --release

# Build for Play Store
flutter build appbundle --release

# Install on device
flutter install
```

---

## Useful Commands

### Show Available Devices

```bash
flutter devices

# Example output:
# Windows (desktop)    • windows    • windows-x86    • Microsoft Windows
# macOS (desktop)      • macos      • darwin-x64     • macOS
# Linux (desktop)      • linux      • linux-x64      • Linux
# Chrome (web)         • chrome     • web-javascript • Chrome
```

### Clear Everything

```bash
# Delete all build artifacts
flutter clean

# Delete Rust build artifacts
cd rust && cargo clean && cd ..

# Reinstall dependencies
flutter pub get
```

### Run with Verbose Output

```bash
# See all compiler output
flutter_rust_bridge_codegen generate --verbose

# See Flutter build details
flutter build windows -v

# See Cargo build details
cd rust && cargo build -vv
```

### Check Package Versions

```bash
# Flutter version
flutter --version

# Rust version
rustc --version

# Cargo version
cargo --version

# Flutter Rust Bridge version
flutter_rust_bridge_codegen --version
```

---

## Complete Fresh Setup

If you want to start completely fresh:

```bash
# 1. Remove all artifacts
flutter clean
cd rust && cargo clean && cd ..

# 2. Update tools
rustup update
flutter upgrade

# 3. Regenerate everything
flutter_rust_bridge_codegen generate --clean

# 4. Get dependencies
flutter pub get

# 5. Build
flutter build windows  # or your platform
```

---

## Continuous Integration / CI Commands

For GitHub Actions or similar:

```bash
# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Install Flutter
git clone https://github.com/flutter/flutter.git
export PATH="$PATH:flutter/bin"

# Install code generator
cargo install flutter_rust_bridge_codegen

# Generate and build
flutter_rust_bridge_codegen generate
flutter pub get
flutter build windows --release
```

---

## Performance Commands

### Benchmark Hashing

```bash
# Create a test file
cat > test_hash.dart << 'EOF'
import 'package:spacebar/core/utils/crypto_ffi.dart';

void main() async {
  // Test SHA3
  var sw = Stopwatch()..start();
  for (int i = 0; i < 1000; i++) {
    await SpacebarCrypto.sha3Hash("test data");
  }
  sw.stop();
  print("SHA3 1000x: ${sw.elapsedMilliseconds}ms");

  // Test BLAKE3
  sw = Stopwatch()..start();
  for (int i = 0; i < 1000; i++) {
    await SpacebarCrypto.blake3Hash("test data");
  }
  sw.stop();
  print("BLAKE3 1000x: ${sw.elapsedMilliseconds}ms");
}
EOF

# Run it
dart test_hash.dart
```

---

## Docker Build (Optional)

If building in Docker:

```dockerfile
FROM rust:latest

# Install Flutter
RUN git clone https://github.com/flutter/flutter.git /flutter
ENV PATH="/flutter/bin:${PATH}"

# Install flutter_rust_bridge_codegen
RUN cargo install flutter_rust_bridge_codegen

# Copy project
COPY . /app
WORKDIR /app

# Build
RUN flutter_rust_bridge_codegen generate
RUN flutter pub get
RUN flutter build linux --release
```

---

## Summary of Key Commands

```bash
# One-time setup
cargo install flutter_rust_bridge_codegen

# Before first run
flutter_rust_bridge_codegen generate
flutter pub get

# Build
flutter build windows

# Run
flutter run

# Regenerate bindings (after changing rust/src/lib.rs)
flutter_rust_bridge_codegen generate

# Quick rebuild
flutter_rust_bridge_codegen generate && flutter build windows
```

---

## What Each Step Does

| Command                                     | Purpose                       | Time     |
| ------------------------------------------- | ----------------------------- | -------- |
| `cargo install flutter_rust_bridge_codegen` | Install code generator        | 2-3 min  |
| `flutter_rust_bridge_codegen generate`      | Create FFI bindings from Rust | 10 sec   |
| `flutter pub get`                           | Download Dart packages        | 30 sec   |
| `flutter build windows`                     | Compile everything            | 2-3 min  |
| `flutter run`                               | Launch app                    | 5-10 sec |

---

## Verify Everything Works

```bash
# Check Rust
cd rust && cargo test

# Generate bindings
flutter_rust_bridge_codegen generate

# Build
flutter build windows

# Check library exists
ls build/windows/runner/Release/spacebar_crypto.dll
```

**Success**: All commands complete without errors ✅

---

## Next Steps After Setup

1. ✅ Run all commands above
2. 📖 Read
   [QUICK_START_FLUTTER_RUST_BRIDGE.md](./QUICK_START_FLUTTER_RUST_BRIDGE.md)
3. 🔍 Check examples in
   [crypto_ffi_examples.dart](./lib/core/utils/crypto_ffi_examples.dart)
4. 🚀 Integrate into your app

---

**Having Issues?** See
[SETUP_FLUTTER_RUST_BRIDGE.md](./SETUP_FLUTTER_RUST_BRIDGE.md) for detailed
troubleshooting.
