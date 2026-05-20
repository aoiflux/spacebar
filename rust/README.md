# Spacebar Crypto FFI Bridge

This directory contains the Rust FFI (Foreign Function Interface) bridge that
provides cryptographic hash functions to the Spacebar Flutter application.

## Overview

This Rust library provides two cryptographic hash functions exposed via FFI:

- **SHA3-256**: Standard SHA3-256 hash function
- **BLAKE3**: Fast BLAKE3 hash function

## Building

### Prerequisites

- [Rust toolchain](https://www.rust-lang.org/tools/install)
- Cargo (comes with Rust)

### Building the Library

#### Windows

```powershell
cargo build --release
```

This will produce `target\release\spacebar_crypto.dll`

#### Linux

```bash
cargo build --release
```

This will produce `target/release/libspacebar_crypto.so`

#### macOS

```bash
cargo build --release
```

This will produce `target/release/libspacebar_crypto.dylib`

### Integrated Build with Flutter

When building the Flutter project on Windows, the Rust library is automatically
built via CMake:

```bash
flutter build windows
```

The compiled `spacebar_crypto.dll` will be placed in the build output directory
alongside the Flutter executable.

## Library Details

### Exported Functions

#### `sha3_hash(data: *const u8, len: u32) -> *mut c_char`

Computes SHA3-256 hash of input data.

**Parameters:**

- `data`: Pointer to input data
- `len`: Length of input data in bytes

**Returns:** Pointer to C string containing hexadecimal hash

**Must be freed with `free_string()`**

#### `blake3_hash(data: *const u8, len: u32) -> *mut c_char`

Computes BLAKE3 hash of input data.

**Parameters:**

- `data`: Pointer to input data
- `len`: Length of input data in bytes

**Returns:** Pointer to C string containing hexadecimal hash

**Must be freed with `free_string()`**

#### `free_string(ptr: *mut c_char)`

Frees memory allocated by hash functions.

**Parameters:**

- `ptr`: Pointer to C string to free

## Dart FFI Wrapper

The Dart FFI wrapper is located at `lib/core/utils/crypto_ffi.dart` and provides
easy-to-use functions:

### Dart API

```dart
// Hash a string with SHA3
String hash = sha3Hash("hello");

// Hash raw bytes with SHA3
String hash = sha3HashBytes([1, 2, 3, 4, 5]);

// Hash a string with BLAKE3
String hash = blake3Hash("hello");

// Hash raw bytes with BLAKE3
String hash = blake3HashBytes([1, 2, 3, 4, 5]);
```

## Testing

Run tests for the Rust library:

```bash
cargo test
```

## Platform Support

- ✅ Windows (x86_64, ARM64)
- ✅ Linux (x86_64, ARM64)
- ✅ macOS (Intel, Apple Silicon)
- ✅ iOS (via static linking)
- ✅ Android (via NDK)

## Performance

Built with optimization flags:

- Link-time optimization (LTO) enabled
- Optimized for release builds
- Single codegen unit for maximum optimization

## Dependencies

- `sha3 ^0.10` - SHA3 implementation
- `blake3 ^1.5` - BLAKE3 implementation
- `ffi` - Rust FFI support (built-in)

## Troubleshooting

### Library not found on runtime

Ensure the compiled library is in the same directory as the Flutter executable
or in a location where the system can find shared libraries.

- **Windows**: `spacebar_crypto.dll` should be next to `spacebar.exe`
- **Linux**: `libspacebar_crypto.so` should be in `LD_LIBRARY_PATH`
- **macOS**: `libspacebar_crypto.dylib` should be in `DYLD_LIBRARY_PATH`

### Build fails on Windows

Ensure you have Rust installed and the Visual C++ build tools are available.

### Memory leaks

Always call `free_string()` on returned hash pointers from Dart. The wrapper
functions handle this automatically.

## Performance Notes

BLAKE3 is significantly faster than SHA3 for large inputs. For cryptographic
security, both are suitable, but SHA3 is more widely standardized.
