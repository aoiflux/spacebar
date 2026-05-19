# FFI Bridge - Setup Verification Checklist

Use this checklist to verify your Rust FFI bridge is properly set up.

## Prerequisites ✓

- [ ] Rust installed (`rustc --version` shows version)
- [ ] Cargo installed (`cargo --version` shows version)
- [ ] Flutter SDK installed (`flutter --version` shows version)
- [ ] CMake installed (for Windows builds)
- [ ] Visual Studio Build Tools (Windows only)

## File Structure ✓

- [ ] `rust/` directory exists
- [ ] `rust/Cargo.toml` exists with dependencies
- [ ] `rust/src/lib.rs` exists with sha3_hash and blake3_hash functions
- [ ] `rust/build.rs` exists
- [ ] `lib/core/utils/crypto_ffi.dart` exists
- [ ] `lib/core/utils/crypto_ffi_examples.dart` exists
- [ ] `windows/CMakeLists.txt` includes Rust build target
- [ ] `FFI_SETUP_GUIDE.md` documentation exists
- [ ] `QUICK_START_FFI.md` documentation exists

## Dependencies ✓

- [ ] `pubspec.yaml` includes `ffi: ^2.1.2`
- [ ] Run `flutter pub get` successfully
- [ ] No dependency conflicts in Flutter

## Rust Library Build ✓

### Windows

```powershell
cd rust
cargo build --release
```

- [ ] Build completes without errors
- [ ] `target\release\spacebar_crypto.dll` exists
- [ ] File size > 1MB (indicates proper compilation)

### macOS

```bash
cd rust
cargo build --release
```

- [ ] Build completes without errors
- [ ] `target/release/libspacebar_crypto.dylib` exists or
- [ ] `target/release/libspacebar_crypto.a` exists

### Linux

```bash
cd rust
cargo build --release
```

- [ ] Build completes without errors
- [ ] `target/release/libspacebar_crypto.so` exists

## Rust Tests ✓

```bash
cd rust
cargo test
```

- [ ] `test_sha3_hash` passes
- [ ] `test_blake3_hash` passes
- [ ] All tests pass without panics

## Flutter Build ✓

### Windows

```bash
flutter build windows
```

- [ ] Build completes successfully
- [ ] No Rust compilation errors in output
- [ ] `spacebar_crypto.dll` in build output directory

### macOS

```bash
flutter build macos
```

- [ ] Build completes successfully
- [ ] Rust library linked correctly

### Linux

```bash
flutter build linux
```

- [ ] Build completes successfully
- [ ] Rust library linked correctly

## Dart FFI Integration ✓

Add to a test file or main:

```dart
import 'package:spacebar/core/utils/crypto_ffi.dart';

void main() {
  final hash1 = sha3Hash("test");
  final hash2 = blake3Hash("test");
  print("SHA3: $hash1");
  print("BLAKE3: $hash2");
}
```

- [ ] Import resolves without errors
- [ ] `sha3Hash()` function available
- [ ] `blake3Hash()` function available
- [ ] No FFI binding errors at runtime

## Runtime Verification ✓

Run the Flutter app (Windows example):

```bash
flutter run
```

- [ ] App starts without library loading errors
- [ ] No "Failed to lookup library" exceptions
- [ ] Can call hash functions successfully
- [ ] Hashes are returned as hex strings

## Hash Value Verification ✓

In the app or test, verify known hash values:

```dart
// SHA3-256("hello") should be:
// 3338be694f50c5f338814986cdf0686453a888330b438d3c7d280f2cc8da83c3
final sha3Test = sha3Hash("hello");
assert(sha3Test == "3338be694f50c5f338814986cdf0686453a888330b438d3c7d280f2cc8da83c3");

// BLAKE3("hello") should be:
// d16ed2f0493584b514e016107eab50685b1634ef174250469ce45ae614528f0c
final blake3Test = blake3Hash("hello");
assert(blake3Test == "d16ed2f0493584b514e016107eab50685b1634ef174250469ce45ae614528f0c");
```

- [ ] SHA3 hash matches expected value
- [ ] BLAKE3 hash matches expected value

## Documentation Review ✓

- [ ] Read `QUICK_START_FFI.md`
- [ ] Read `FFI_SETUP_GUIDE.md`
- [ ] Reviewed `rust/README.md`
- [ ] Reviewed usage examples in `crypto_ffi_examples.dart`

## Troubleshooting Notes ✓

If any checks fail:

| Issue               | Check                                                   |
| ------------------- | ------------------------------------------------------- |
| "Library not found" | Ensure DLL/SO/DYLIB is in app directory                 |
| Build fails         | Run `cargo clean` and rebuild                           |
| FFI binding errors  | Verify library name in `crypto_ffi.dart`                |
| Memory issues       | Check `free_string()` is called for all returned hashes |

## Performance Baseline ✓

Optional: Establish performance baseline

```dart
// SHA3 baseline
var sw = Stopwatch()..start();
for (int i = 0; i < 1000; i++) {
  sha3Hash("test data");
}
sw.stop();
print("SHA3 1000x: ${sw.elapsedMilliseconds}ms");

// BLAKE3 baseline
sw = Stopwatch()..start();
for (int i = 0; i < 1000; i++) {
  blake3Hash("test data");
}
sw.stop();
print("BLAKE3 1000x: ${sw.elapsedMilliseconds}ms");
```

- [ ] Performance is acceptable for use case
- [ ] BLAKE3 is noticeably faster than SHA3

## Production Readiness ✓

- [ ] Error handling implemented
- [ ] Memory leaks checked and verified none
- [ ] Cross-platform testing completed
- [ ] Library distribution plan documented
- [ ] Version control updated (.gitignore includes Rust target/)

## Completion Status

- [ ] All checks completed
- [ ] No blocking issues
- [ ] Ready for development
- [ ] Ready for production

---

**Date Completed**: _______________ **Platform(s) Tested**: _______________
**Notes**: _______________
