# Quick Start: Using the Rust FFI Crypto Library

## 30-Second Setup

1. **Install Rust** (one-time):
   ```bash
   # Windows (PowerShell)
   iwr https://static.rust-lang.org/rustup-init.exe -outfile rustup-init.exe
   .\rustup-init.exe

   # macOS/Linux
   curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
   ```

2. **Get dependencies**:
   ```bash
   flutter pub get
   ```

3. **Build** (automatically happens with `flutter build`):
   ```bash
   flutter build windows
   # or
   flutter build macos
   # or
   flutter build linux
   ```

## Using the Library

Add this to your Dart file:

```dart
import 'package:spacebar/core/utils/crypto_ffi.dart';

// Hash a string
String hash = sha3Hash("hello world");
print(hash);  // 3ee6a5b0b76a14890a8fbbbc1f935e88aa05d54ae37d8c90e88c7f98f0c94e72d

// Or use BLAKE3 (faster)
String hash = blake3Hash("hello world");
print(hash);  // d84c5795f91c8d8c0ab63758c2b877c0034edf23e2c28c64e587327f9abc47e7
```

## API Reference

### String Hashing

```dart
// SHA3-256 hash of a string
String sha3Hash(String input)

// BLAKE3 hash of a string
String blake3Hash(String input)
```

### Byte Hashing

```dart
// SHA3-256 hash of raw bytes
String sha3HashBytes(List<int> bytes)

// BLAKE3 hash of raw bytes
String blake3HashBytes(List<int> bytes)
```

## Common Tasks

### Verify a checksum

```dart
String computedHash = blake3Hash(fileContent);
bool isValid = computedHash == expectedHash;
```

### Hash a file

```dart
File file = File('path/to/file');
List<int> bytes = file.readAsBytesSync();
String hash = blake3HashBytes(bytes);
```

### Performance comparison

```dart
final sw1 = Stopwatch()..start();
sha3Hash("data");
sw1.stop();

final sw2 = Stopwatch()..start();
blake3Hash("data");
sw2.stop();

print("SHA3: ${sw1.elapsedMilliseconds}ms");
print("BLAKE3: ${sw2.elapsedMilliseconds}ms");
```

## When to Use Each

- **SHA3**: Standard cryptographic hash (NIST approved)
- **BLAKE3**: Faster, modern design, still cryptographically secure

## Troubleshooting

| Problem             | Solution                                          |
| ------------------- | ------------------------------------------------- |
| "Library not found" | Ensure library is in app directory or system PATH |
| Build fails         | Run `rustup update` and `cargo clean`             |
| Dart import fails   | Check `pubspec.yaml` has `ffi: ^2.1.2`            |

## Full Documentation

- See [FFI_SETUP_GUIDE.md](./FFI_SETUP_GUIDE.md) for complete setup
- See [rust/README.md](./rust/README.md) for Rust details
- See
  [lib/core/utils/crypto_ffi_examples.dart](./lib/core/utils/crypto_ffi_examples.dart)
  for examples
