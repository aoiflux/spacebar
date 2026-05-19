# Flutter Rust Bridge - Quick Start

Get up and running with Flutter Rust Bridge in 5 minutes.

## Prerequisites

- Rust installed (`rustc --version` works)
- Flutter installed (`flutter --version` works)

## Step 1: Install Code Generator (2 min)

```bash
cargo install flutter_rust_bridge_codegen
```

Verify:

```bash
flutter_rust_bridge_codegen --version
```

## Step 2: Generate Bindings (1 min)

From the project root:

```bash
# Generate FFI bindings from Rust code
flutter_rust_bridge_codegen generate
```

**What it does:**

- Reads `rust/src/lib.rs` and generates Dart bindings
- Creates `lib/generated/rust/frb_generated.dart`
- Automatically handles type conversion and memory management

## Step 3: Get Dependencies (1 min)

```bash
flutter pub get
```

## Step 4: Build & Test (1 min)

```bash
# Build native library and Dart code
flutter build windows  # or macos/linux

# Or just run
flutter run
```

## Step 5: Use in Your Code (0 min)

```dart
import 'package:spacebar/core/utils/crypto_ffi.dart';

// Use the simple API
Future<String> hash = SpacebarCrypto.sha3Hash("hello");
String result = await hash;
print(result); // 3338be694f50c5f338814986cdf0686453a888330b438d3c7d280f2cc8da83c3
```

## What Changed from Manual FFI

### Before (Manual FFI):

```dart
// Complex memory management
final resultPtr = _sha3Hash(nativeInput, utf8Input.length);
final result = resultPtr.cast<Utf8>().toDartString();
_freeString(resultPtr);
malloc.free(nativeInput);
```

### After (Flutter Rust Bridge):

```dart
// Simple, type-safe
final result = await api.sha3Hash(data: utf8Input);
```

## Key Features

✅ **Auto-generated bindings** - Never write FFI boilerplate again ✅
**Type-safe** - Compile-time type checking ✅ **Memory safe** - Automatic memory
management ✅ **Async support** - Built-in Future support ✅
**Cross-platform** - Works on Windows, macOS, Linux, iOS, Android

## Common Tasks

### Add a New Hash Function

1. Add to `rust/src/lib.rs`:

```rust
pub fn new_hash(data: &[u8]) -> String {
    // implementation
}
```

2. Regenerate:

```bash
flutter_rust_bridge_codegen generate
```

3. Use immediately:

```dart
final result = await api.newHash(data: myData);
```

### Check Generated Code

```bash
# View the generated bindings
cat lib/generated/rust/frb_generated.dart

# Or in VS Code:
# Open: lib/generated/rust/frb_generated.dart
```

### Rebuild After Rust Changes

```bash
# Regenerate bindings
flutter_rust_bridge_codegen generate

# Rebuild app
flutter build windows
```

## Testing

### Test Rust Library

```bash
cd rust
cargo test
```

### Test Dart Integration

```dart
// In a test file
test('sha3_hash works', () async {
  final result = await SpacebarCrypto.sha3Hash("hello");
  expect(result, "3338be694f50c5f338814986cdf0686453a888330b438d3c7d280f2cc8da83c3");
});
```

## Troubleshooting

| Problem                                 | Solution                                       |
| --------------------------------------- | ---------------------------------------------- |
| `flutter_rust_bridge_codegen not found` | `cargo install flutter_rust_bridge_codegen`    |
| Generated code missing                  | Run `flutter_rust_bridge_codegen generate`     |
| "Library not found" at runtime          | Run `flutter build windows` (or your platform) |
| Compilation errors after changes        | Run `flutter clean && flutter pub get`         |

## Next Steps

1. ✅ Install code generator
2. ✅ Generate bindings
3. ✅ Try the example functions
4. 📖 Read [SETUP_FLUTTER_RUST_BRIDGE.md](./SETUP_FLUTTER_RUST_BRIDGE.md) for
   advanced topics
5. 🚀 Integrate into your app!

## Key Differences from Manual FFI

| Manual FFI                    | Flutter Rust Bridge               |
| ----------------------------- | --------------------------------- |
| `#[no_mangle] pub extern "C"` | Simple `pub fn`                   |
| Complex pointer handling      | Automatic type conversion         |
| Manual memory management      | Automatic allocation/deallocation |
| Verbose unsafe code           | Safe, generated code              |
| Hard to maintain              | Easy to maintain                  |

## Performance

- Generated code has **minimal overhead**
- **Same speed as manual FFI** when optimized
- No additional runtime cost

## One-Liner Workflow

After modifying Rust code:

```bash
flutter_rust_bridge_codegen generate && flutter build windows
```

That's it! 🎉

---

**Next**: Follow [SETUP_FLUTTER_RUST_BRIDGE.md](./SETUP_FLUTTER_RUST_BRIDGE.md)
for detailed setup and advanced features.
