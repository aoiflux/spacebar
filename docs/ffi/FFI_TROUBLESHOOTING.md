# Rust FFI Bridge - Troubleshooting Guide

## Common Issues and Solutions

### 🔴 Rust Not Installed

**Error**: `'cargo' is not recognized as an internal or external command`

**Solution**:

1. Install Rust from https://www.rust-lang.org/tools/install
2. On Windows, use:
   `iwr https://static.rust-lang.org/rustup-init.exe -outfile rustup-init.exe && .\rustup-init.exe`
3. Close terminal and reopen to refresh PATH
4. Verify: `rustup --version`

---

### 🔴 Build Tools Missing (Windows)

**Error**: `error: Microsoft Visual C++ 14.0 or greater is required`

**Solution**:

1. Install Visual Studio Build Tools from:
   https://visualstudio.microsoft.com/visual-cpp-build-tools/
2. Or install Visual Studio Community with C++ workload
3. Restart your computer
4. Try building again

---

### 🔴 Library Not Found at Runtime

**Error**: `Failed to lookup library: spacebar_crypto.dll`

**Causes & Solutions**:

**A) Library not in app directory**

```
Check: Build output directory should contain spacebar_crypto.dll
Windows: build\windows\runner\Release\
macOS: build/macos/Build/Products/Release/
Linux: build/linux/x64/release/
```

**B) Incorrect library name**

```dart
// Check in crypto_ffi.dart - must match exactly:
// Windows: spacebar_crypto.dll (NOT libspacebar_crypto.dll)
// Linux: libspacebar_crypto.so (not just spacebar_crypto.so)
// macOS: libspacebar_crypto.dylib
```

**C) Path issues**

- Ensure library is in same directory as executable
- Or add to system PATH

**D) Rebuild required**

```bash
flutter clean
flutter pub get
flutter build windows  # or macos/linux
```

---

### 🔴 Cargo Build Fails

**Error**: `error: could not find 'cargo'` or build fails with compilation
errors

**Solutions**:

1. **Update Rust**:
   ```bash
   rustup update
   rustup target add x86_64-pc-windows-msvc
   ```

2. **Clean and rebuild**:
   ```bash
   cd rust
   cargo clean
   cargo build --release
   ```

3. **Check dependencies**:
   ```bash
   cd rust
   cargo check
   ```

4. **View detailed errors**:
   ```bash
   RUST_BACKTRACE=1 cargo build --release
   ```

---

### 🔴 FFI Binding Errors in Dart

**Error**: `cannot find symbol 'sha3_hash'` or similar

**Solutions**:

1. **Verify function is exported**:
   ```rust
   // In rust/src/lib.rs, check for:
   #[no_mangle]
   pub extern "C" fn sha3_hash(...)
   ```

2. **Verify function name in Dart**:
   ```dart
   // In crypto_ffi.dart, check the lookup string matches exactly:
   .lookup<NativeFunction<_Sha3HashNative>>('sha3_hash')
   ```

3. **Rebuild Rust library**:
   ```bash
   cd rust
   cargo build --release
   ```

4. **Clear Dart cache**:
   ```bash
   flutter pub get
   flutter clean
   ```

---

### 🔴 CMake Configuration Error (Windows)

**Error**: `CMake Error` or `Ninja build failed`

**Solutions**:

1. **Ensure CMake is installed**:
   ```bash
   cmake --version
   ```

2. **Check windows/CMakeLists.txt syntax**:
   - Open in VS Code
   - Look for red squiggles
   - Fix any syntax errors

3. **Verify Rust path in CMakeLists.txt**:
   ```cmake
   set(RUST_PROJECT_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../rust")
   # Should point to your rust directory
   ```

4. **Rebuild Flutter**:
   ```bash
   flutter clean
   flutter build windows -v  # verbose to see errors
   ```

---

### 🔴 Memory Issues (Crashes)

**Error**: `Segmentation fault` or app crash after hashing

**Common Causes**:

1. **Not calling free_string()**:
   ```dart
   // WRONG - causes memory leak
   final hash = sha3Hash("test");

   // RIGHT - Dart wrapper handles this
   final hash = sha3Hash("test");
   // Memory is freed automatically
   ```

2. **Double-free error**:
   - Don't manually call `_freeString()`
   - The wrapper in `crypto_ffi.dart` handles it

3. **Null pointer**:
   - Don't pass null data pointers
   - The Rust code checks for this

**Solution**: Use the Dart wrapper functions, not raw FFI calls.

---

### 🔴 Hash Value Doesn't Match

**Error**: Hash value is different from expected

**Check**:

1. **Input encoding**:
   ```dart
   // These might produce different hashes:
   sha3Hash("hello")            // string
   sha3HashBytes([104, 101, 108, 108, 111])  // same string as bytes
   ```

2. **Verify test values**:
   ```dart
   // SHA3("hello") should be exactly:
   // 3338be694f50c5f338814986cdf0686453a888330b438d3c7d280f2cc8da83c3

   final test = sha3Hash("hello");
   print(test);  // Compare character by character
   ```

3. **Test with known implementation**:
   - Use an online SHA3 calculator to verify
   - Check spacing/line endings in test input

---

### 🔴 Performance Issues (Hashing is slow)

**Typical performance**:

- SHA3: ~0.1ms per KB
- BLAKE3: ~0.02ms per KB

**If slower**:

1. **Using debug build instead of release**:
   ```bash
   flutter build windows --release
   ```

2. **Hashing very large inputs repeatedly**:
   ```dart
   // Instead of:
   for (int i = 0; i < 1000; i++) {
     sha3Hash(largeData);  // Inefficient
   }

   // Consider streaming or batching
   ```

---

### 🔴 Cross-Platform Build Issues

**macOS**: `Library not found for -lSystem`

```bash
# Add target
rustup target add aarch64-apple-darwin
rustup target add x86_64-apple-darwin

# Rebuild
cargo build --release
```

**Linux**: `cannot find -lc`

```bash
# Install build tools
sudo apt-get update
sudo apt-get install build-essential
sudo apt-get install libclang-dev

# Rebuild
cargo build --release
```

---

### 🔴 iOS/Android Integration Issues

**iOS**: Library not statically linked

- Ensure `Cargo.toml` has `crate-type = ["staticlib", "cdylib"]`
- Use correct build target: `aarch64-apple-ios`

**Android**: Library not found in NDK

- Ensure rust targets are added:
  ```bash
  rustup target add aarch64-linux-android
  rustup target add armv7-linux-androideabi
  rustup target add x86_64-linux-android
  ```

---

### 🟡 Warnings (Non-Critical)

**Warning**: `warning: unused variable`

- Usually safe to ignore
- Run `cargo clippy` to see suggestions

**Warning**: `ld.lld-12: warning: relocation R_X86_64_TPOFF32 against symbol`

- Can be safely ignored on Linux

---

## Verification Steps

If something isn't working, run these checks:

1. **Rust is installed and working**:
   ```bash
   rustc --version
   cargo --version
   ```

2. **Flutter can find packages**:
   ```bash
   flutter pub get
   flutter pub upgrade
   ```

3. **Rust library compiles**:
   ```bash
   cd rust
   cargo build --release
   ls target/release/spacebar_crypto.*
   ```

4. **CMake configuration is valid**:
   ```bash
   cd windows
   cmake .
   ```

5. **FFI can find library**:
   - Run app and check console
   - Look for "Loading spacebar_crypto" messages

6. **Hash functions work correctly**:
   - Run unit tests: `cd rust && cargo test`
   - Test values in app match documentation

---

## Getting Help

If you're still stuck:

1. **Check logs**:
   - Flutter: `flutter run -v` (verbose)
   - Cargo: `RUST_BACKTRACE=full cargo build`
   - CMake: `cmake -v` in windows directory

2. **Verify documentation**:
   - [FFI_SETUP_GUIDE.md](./FFI_SETUP_GUIDE.md)
   - [FFI_ARCHITECTURE.md](./FFI_ARCHITECTURE.md)
   - [rust/README.md](./rust/README.md)

3. **Run verification checklist**:
   - [FFI_VERIFICATION_CHECKLIST.md](./FFI_VERIFICATION_CHECKLIST.md)

4. **Check examples**:
   - [crypto_ffi_examples.dart](./lib/core/utils/crypto_ffi_examples.dart)

---

## Common Fixes Summary

| Issue             | Quick Fix                                     |
| ----------------- | --------------------------------------------- |
| Library not found | Ensure DLL/SO in same dir as executable       |
| Build fails       | `rustup update && cargo clean && cargo build` |
| FFI errors        | Verify function names match in Rust and Dart  |
| Hash mismatch     | Check input encoding (string vs bytes)        |
| Memory crash      | Use wrapper functions, not raw FFI            |
| Slow hashing      | Build with `--release` flag                   |
| Windows errors    | Install Visual Studio Build Tools             |
| macOS errors      | `rustup target add aarch64-apple-darwin`      |
| Linux errors      | `sudo apt-get install build-essential`        |

---

**Last Updated**: May 2026 **Tested Platforms**: Windows 10+, macOS 11+, Linux
(Ubuntu 20.04+)
