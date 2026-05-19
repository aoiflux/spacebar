# Flutter Rust Bridge - Setup Guide

This guide explains how to set up and use Flutter Rust Bridge for FFI code
generation in Spacebar.

## What is Flutter Rust Bridge?

`flutter_rust_bridge` is a code generator that automatically creates FFI
bindings between Dart and Rust. Instead of manually writing unsafe FFI code, you
write simple Rust functions and the generator creates all the boilerplate.

### Benefits Over Manual FFI

| Aspect            | Manual FFI           | Flutter Rust Bridge         |
| ----------------- | -------------------- | --------------------------- |
| Setup             | Complex, error-prone | Simple, configuration-based |
| Bindings          | Manual, verbose      | Auto-generated              |
| Type Safety       | Error-prone          | Strongly typed              |
| Memory Management | Manual               | Automatic                   |
| Async Support     | Manual               | Built-in                    |
| Maintenance       | High effort          | Low effort                  |

## Installation

### 1. Install flutter_rust_bridge_codegen

```bash
# Using cargo
cargo install flutter_rust_bridge_codegen

# Or using dart/flutter
dart pub global activate flutter_rust_bridge_codegen
```

### 2. Verify Installation

```bash
flutter_rust_bridge_codegen --version
```

## Project Structure

```
spacebar/
├── rust/
│   ├── src/
│   │   └── lib.rs                      # Simple, type-safe functions
│   └── Cargo.toml                      # With flutter_rust_bridge dependency
├── lib/
│   ├── core/utils/
│   │   └── crypto_ffi.dart             # Wrapper around generated code
│   └── generated/rust/
│       ├── frb_generated.dart          # AUTO-GENERATED (don't edit!)
│       └── frb_generated.web.dart      # For web (auto-generated)
├── flutter_rust_bridge.yaml            # Code generation config
└── pubspec.yaml                        # With flutter_rust_bridge
```

## Generate FFI Bindings

### Quick Start

```bash
# From project root
flutter_rust_bridge_codegen generate
```

### With Options

```bash
# Specify input and output
flutter_rust_bridge_codegen generate \
  --rust-input rust/src/lib.rs \
  --dart-output lib/generated/rust/

# For web support
flutter_rust_bridge_codegen generate --web
```

### Using Configuration File

Create/update `flutter_rust_bridge.yaml` (already created in the project):

```yaml
rust:
    crate_dir: rust
    lib_name: spacebar_crypto

dart:
    output_dir: lib/generated/rust
    use_async: true
```

Then run:

```bash
flutter_rust_bridge_codegen generate
```

## Rust Code Structure

### Simple Rust Functions

Instead of this (manual FFI):

```rust
#[no_mangle]
pub extern "C" fn sha3_hash(data: *const u8, len: usize) -> *mut c_char {
    // Complex manual memory management...
}
```

Write this (with Flutter Rust Bridge):

```rust
pub fn sha3_hash(data: &[u8]) -> String {
    let mut hasher = Sha3_256::new();
    hasher.update(data);
    format!("{:x}", hasher.finalize())
}
```

### Supported Types

Flutter Rust Bridge automatically handles:

- Primitives: `i32`, `i64`, `f64`, `bool`, etc.
- Strings: `String`, `&str`
- Collections: `Vec<T>`, `[T; N]`
- Options: `Option<T>`
- Results: `Result<T, E>`
- Custom structs (with `#[frb]` macro)
- Async functions: `async fn` → `Future<T>`

## Dart Usage

### Import Generated Code

```dart
import 'package:spacebar/core/utils/crypto_ffi.dart';

// Use the simple wrapper API
Future<String> hash = SpacebarCrypto.sha3Hash("hello");
```

### Direct Generated Code (Advanced)

```dart
// Using generated bindings directly
import 'package:spacebar/generated/rust/frb_generated.dart';

// Generated code is async-safe and memory-safe
String hash = await api.sha3Hash(data: Uint8List.fromList([...]));
```

## Build Process

### Development

```bash
# Generate bindings
flutter_rust_bridge_codegen generate

# Rebuild Dart
flutter pub get

# Run app
flutter run
```

### Production Build

#### Windows

```bash
# Automatically builds Rust via CMake during Flutter build
flutter build windows --release
```

#### macOS

```bash
# Build for current architecture
rustup target add aarch64-apple-darwin
rustup target add x86_64-apple-darwin

flutter build macos --release
```

#### Linux

```bash
flutter build linux --release
```

#### iOS

```bash
# Automatic static linking
flutter build ios --release
```

#### Android

```bash
# Requires Android NDK setup
flutter build apk --release
```

## Workflow

### 1. Define Rust Functions

Edit `rust/src/lib.rs`:

```rust
pub fn my_new_function(input: String) -> String {
    // implementation
    input.to_uppercase()
}
```

### 2. Generate Bindings

```bash
flutter_rust_bridge_codegen generate
```

This creates:

- `lib/generated/rust/frb_generated.dart` - Raw FFI bindings
- `lib/generated/rust/frb_generated_api.dart` - Async wrapper (auto-generated)

### 3. Create Dart Wrapper (Optional)

For cleaner API, create wrapper in `lib/core/utils/crypto_ffi.dart`:

```dart
class SpacebarCrypto {
  static Future<String> sha3Hash(String input) async {
    // Call generated code
    return api.sha3Hash(data: input.codeUnits);
  }
}
```

### 4. Test

```bash
flutter test
# or
flutter run
```

## Common Patterns

### Error Handling

**Rust**:

```rust
pub fn my_function() -> Result<String, String> {
    if condition {
        Ok("success".to_string())
    } else {
        Err("error".to_string())
    }
}
```

**Dart**:

```dart
try {
  final result = await api.myFunction();
  print(result);
} catch (e) {
  print("Error: $e");
}
```

### Working with Bytes

**Rust**:

```rust
pub fn hash_bytes(data: Vec<u8>) -> String {
    // Process bytes
}
```

**Dart**:

```dart
final bytes = utf8.encode("hello");
final hash = await api.hashBytes(data: bytes);
```

### Async Operations

**Rust**:

```rust
pub async fn fetch_hash(data: String) -> String {
    // Async operation
    hash_it(data).await
}
```

**Dart**:

```dart
final hash = await api.fetchHash(data: "test");
```

## Regenerating Bindings

After modifying `rust/src/lib.rs`:

```bash
# Regenerate all bindings
flutter_rust_bridge_codegen generate

# Clean and regenerate
flutter_rust_bridge_codegen generate --clean
```

## Debugging

### See Generated Code

```bash
# The generated code is at:
# lib/generated/rust/frb_generated.dart
# lib/generated/rust/frb_generated_api.dart

# View it to understand the mappings
```

### Check Compilation

```bash
# Verify Rust code compiles
cd rust
cargo build --release

# Check FFI generation
flutter_rust_bridge_codegen generate --verbose
```

### Common Issues

**"Library not found"**

- Ensure library is built for current platform
- Check `flutter_rust_bridge.yaml` configuration

**"Function not exported"**

- Make sure function is `pub` in Rust
- Regenerate with `flutter_rust_bridge_codegen generate --clean`

**Type mismatch in generated code**

- Ensure Rust types match supported types
- Check `flutter_rust_bridge.yaml` syntax

## Configuration Options

See `flutter_rust_bridge.yaml` in project root for full configuration:

```yaml
rust:
    crate_dir: rust # Path to Rust crate
    lib_name: spacebar_crypto # Library name from Cargo.toml

dart:
    output_dir: lib/generated # Where to generate Dart files
    use_async: true # Generate async/Future wrappers

codegen:
    profile: release # Build profile (release/debug)
```

## Performance Notes

- Flutter Rust Bridge has minimal overhead
- Generated code is optimized and compiled
- Async operations don't block the Dart thread
- Similar performance to manual FFI

## Next Steps

1. Run code generator: `flutter_rust_bridge_codegen generate`
2. Review generated code: `lib/generated/rust/frb_generated.dart`
3. Build project: `flutter build windows`
4. Test hashing functions
5. Integrate into your app

## References

- [Official Docs](https://cjycode.com/flutter_rust_bridge/index.html)
- [GitHub Repository](https://github.com/fzyzcjy/flutter_rust_bridge)
- [Examples](https://github.com/fzyzcjy/flutter_rust_bridge/tree/main/examples)

## Troubleshooting

| Issue                                   | Solution                                             |
| --------------------------------------- | ---------------------------------------------------- |
| `flutter_rust_bridge_codegen not found` | Install: `cargo install flutter_rust_bridge_codegen` |
| Generated code won't compile            | Run `flutter clean && flutter pub get`               |
| "Library not found" at runtime          | Rebuild: `flutter build [platform]`                  |
| Type not supported                      | Use `#[frb]` macro or convert types in Rust          |

---

**Status**: Ready to generate! Run `flutter_rust_bridge_codegen generate` now.
