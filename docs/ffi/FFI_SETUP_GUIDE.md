# Rust FFI Bridge Setup Guide

This guide explains how to build and use the Rust FFI bridge for the Spacebar
Flutter project.

## Project Structure

```
spacebar/
├── lib/
│   └── core/utils/
│       ├── crypto_ffi.dart              # Dart FFI bindings
│       └── crypto_ffi_examples.dart     # Usage examples
├── rust/
│   ├── src/
│   │   └── lib.rs                       # Rust implementation
│   ├── Cargo.toml                       # Rust dependencies
│   ├── build.rs                         # Build script
│   ├── .gitignore                       # Rust artifacts to ignore
│   └── README.md                        # Rust-specific documentation
├── windows/
│   └── CMakeLists.txt                   # Windows build configuration
├── build_rust.ps1                       # PowerShell build script
└── pubspec.yaml                         # Flutter dependencies
```

## Setup Instructions

### 1. Install Rust

If you don't have Rust installed:

```bash
# On Windows (in PowerShell or CMD)
iwr https://static.rust-lang.org/rustup-init.exe -outfile rustup-init.exe
.\rustup-init.exe

# Then close and reopen your terminal
```

For macOS/Linux:

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

### 2. Add Windows Target (if on Windows)

```bash
cd rust
rustup target add x86_64-pc-windows-msvc
```

### 3. Build Rust Library

#### Option A: Manual Build (for testing)

```bash
cd rust
cargo build --release
```

This produces:

- Windows: `target\release\spacebar_crypto.dll`
- Linux: `target/release/libspacebar_crypto.so`
- macOS: `target/release/libspacebar_crypto.dylib`

#### Option B: Automated Build with Flutter (Recommended)

When you run `flutter build windows`, the CMake configuration automatically:

1. Builds the Rust library
2. Copies it to the output directory

### 4. Update Flutter Dependencies

Run this to update dependencies (including the new `ffi` package):

```bash
flutter pub get
```

### 5. Test the Build

#### Run tests in Rust library:

```bash
cd rust
cargo test
```

#### Use in Flutter app:

The FFI bridge is in `lib/core/utils/crypto_ffi.dart`. See
`crypto_ffi_examples.dart` for usage.

## Usage

### Basic Usage

```dart
import 'package:spacebar/core/utils/crypto_ffi.dart';

// Hash a string with SHA3
String hash1 = sha3Hash("hello");

// Hash a string with BLAKE3
String hash2 = blake3Hash("hello");

// Hash raw bytes
List<int> data = [1, 2, 3, 4, 5];
String hash3 = sha3HashBytes(data);
String hash4 = blake3HashBytes(data);
```

### Advanced Usage

See `lib/core/utils/crypto_ffi_examples.dart` for:

- Performance comparison
- File hashing
- Checksum verification
- Double hashing
- Error handling
- Widget integration

## Building for Different Platforms

### Windows

```bash
flutter build windows
```

The `spacebar_crypto.dll` will be built automatically and placed in the build
output.

### macOS

```bash
# Add target first
rustup target add aarch64-apple-darwin  # For Apple Silicon
rustup target add x86_64-apple-darwin    # For Intel

# Build Flutter
flutter build macos
```

### Linux

```bash
# Install dependencies
sudo apt-get install libclang-dev

# Build Flutter
flutter build linux
```

### iOS

For iOS, the Rust library is statically linked. No additional setup needed.

### Android

For Android, you may need to set up the Android NDK. See the Rust book for
details.

## Troubleshooting

### "Library not found" at runtime

**Problem**: The dynamic library isn't found when running the app.

**Solution**:

- Ensure the library is in the same directory as the executable
- Check the library extension matches your platform:
  - Windows: `.dll`
  - Linux: `.so`
  - macOS: `.dylib`

### Build fails on Windows

**Problem**: `cargo build --release` fails

**Solution**:

- Install Visual Studio Build Tools
- Ensure Rust target is installed: `rustup target add x86_64-pc-windows-msvc`
- Clear cache: `cargo clean`

### FFI binding errors in Dart

**Problem**: "Failed to lookup library"

**Solution**:

1. Verify the library name matches in `crypto_ffi.dart`
2. Check platform string in `_loadLibrary()` function
3. Ensure library is in the application directory

## Performance Notes

- **BLAKE3**: ~5-10x faster than SHA3 for large inputs
- **SHA3**: More widely standardized, similar security

Choose based on your use case:

- Security-critical: Either works, SHA3 is more standardized
- High-throughput: BLAKE3 is recommended

## Library Deployment

### Development

During development, the library is loaded from the output directory alongside
the executable.

### Production

For distribution:

1. **Windows**: Include `spacebar_crypto.dll` with your application
2. **Linux**: Include `libspacebar_crypto.so` and ensure it's in the search path
3. **macOS**: The library can be code-signed and embedded
4. **iOS**: Statically linked (no separate file needed)
5. **Android**: Included via native assets

## Development Notes

### Modifying Rust Code

1. Edit `rust/src/lib.rs`
2. Run tests: `cd rust && cargo test`
3. Rebuild: `cargo build --release`
4. The Dart FFI wrapper automatically finds the new library

### Adding New Functions

To add a new hash function:

1. Add function to `rust/src/lib.rs`
2. Export with `#[no_mangle] pub extern "C"`
3. Create Dart wrapper in `crypto_ffi.dart`
4. Update documentation

### Updating Dependencies

Update Rust dependencies:

```bash
cd rust
cargo update
```

## CI/CD Integration

For GitHub Actions or other CI systems, add to your workflow:

```yaml
- name: Build Rust FFI
  run: |
      cargo build --release --manifest-path=rust/Cargo.toml
```

## References

- [Dart FFI Documentation](https://dart.dev/guides/libraries/c-interop)
- [Rust FFI Guide](https://doc.rust-lang.org/nomicon/ffi.html)
- [SHA3 Crate](https://docs.rs/sha3/)
- [BLAKE3 Crate](https://docs.rs/blake3/)
