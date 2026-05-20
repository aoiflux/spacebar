# Rust FFI Bridge - Deployment & Distribution Guide

## Pre-Deployment Checklist

- [ ] All tests pass: `cd rust && cargo test`
- [ ] Release build succeeds: `cargo build --release`
- [ ] Flutter app builds: `flutter build windows/macos/linux`
- [ ] Hash verification passes (test known values)
- [ ] No FFI errors in app runtime
- [ ] Documentation is up-to-date

## Platform-Specific Deployment

### Windows Deployment

#### Development

```
build/windows/runner/Release/
├── spacebar.exe                 # Main app
└── spacebar_crypto.dll          # FFI Bridge (required!)
```

#### Distribution (Portable)

```
spacebar/
├── spacebar.exe
├── spacebar_crypto.dll
└── [other Flutter runtime files]
```

**Installer (MSI/NSIS)**:

```xml
<!-- Include in installer: -->
File spacebar_crypto.dll
File spacebar.exe
```

**Packaging Commands**:

```bash
flutter build windows --release
# Copy entire Release directory
# Zip or create installer
```

#### Troubleshooting Windows Deployment

- Ensure VCREDIST (Visual C++ Runtime) is installed
- Check if `spacebar_crypto.dll` is in PATH or app directory
- Use Dependency Walker to check DLL dependencies

---

### macOS Deployment

#### Development

```
build/macos/Build/Products/Release/
└── spacebar.app/
    └── Contents/
        ├── MacOS/spacebar          # Main executable
        └── Libs/libspacebar_crypto.dylib  # FFI Bridge
```

#### Distribution (DMG)

```bash
flutter build macos --release

# Create DMG
mkdir spacebar_dist
cp -r build/macos/Build/Products/Release/spacebar.app spacebar_dist/
# Create symlink to Applications
ln -s /Applications spacebar_dist/

# Create DMG from folder
```

#### Code Signing

```bash
# Sign the library
codesign -s - build/macos/Build/Products/Release/spacebar.app/Contents/Libs/libspacebar_crypto.dylib

# Sign the app
codesign -s - build/macos/Build/Products/Release/spacebar.app
```

#### Notarization (for distribution)

```bash
# Get notary-tool (Xcode 13+)
xcrun notarytool submit spacebar.dmg --wait

# Or use altool (older)
xcrun altool --notarize-app -f spacebar.dmg
```

---

### Linux Deployment

#### Development

```
build/linux/x64/release/
├── spacebar                     # Main app
└── lib/libspacebar_crypto.so   # FFI Bridge
```

#### Distribution (AppImage)

```bash
flutter build linux --release

# Install linuxdeploy
wget https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage
chmod +x linuxdeploy-x86_64.AppImage

# Create AppImage
./linuxdeploy-x86_64.AppImage -e build/linux/x64/release/spacebar -d spacebar.desktop -i icon.png -o AppImage
```

#### Distribution (Snap)

```yaml
# snapcraft.yaml
name: spacebar
version: "0.1.0"
summary: Spacebar Application
description: Spacebar with Rust FFI bridge

grade: stable
confinement: strict

apps:
    spacebar:
        command: spacebar
        plugs: [home, system-observe]

parts:
    spacebar:
        plugin: nil
        stage-packages:
            - libc6
        override-build: |
            flutter build linux --release
            cp -r build/linux/x64/release/* $SNAPCRAFT_PART_INSTALL/
```

```bash
snap pack
```

#### Distribution (Flatpak)

```yaml
# com.example.spacebar.yaml
app-id: com.example.spacebar
runtime: org.freedesktop.Platform
runtime-version: "23.08"
sdk: org.freedesktop.Sdk

modules:
    - name: spacebar
      buildsystem: simple
      build-commands:
          - flutter build linux --release
          - install -D build/linux/x64/release/spacebar /app/bin/spacebar
          - install -D libspacebar_crypto.so /app/lib/libspacebar_crypto.so
```

```bash
flatpak-builder --user --install build com.example.spacebar.yaml
```

---

### iOS Deployment

#### Requirements

- Xcode 14+
- Apple Developer Account
- Code Signing Certificate

#### Build for iOS

```bash
flutter build ios --release

# Or for App Store
flutter build ipa --release
```

#### Rust Library Integration

- Automatically statically linked
- No separate library file to distribute
- Verify in Xcode:
  - Build Phases > Link Binary With Libraries
  - Should see libspacebar_crypto.a

#### App Store Distribution

```bash
# Build IPA
flutter build ipa --release

# Upload using Transporter
xcrun altool --upload-app -f build/ios/ipa/spacebar.ipa -u YOUR_APPLE_ID -p YOUR_PASSWORD
```

---

### Android Deployment

#### Requirements

- Android SDK 21+
- Gradle (managed by Flutter)

#### Build for Android

```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release

# Release Bundle (for Play Store)
flutter build appbundle --release
```

#### Rust Library Integration

- Automatically compiled with NDK
- Included in APK/AAB
- Verify in build output:
  - `apk/lib/arm64-v8a/libspacebar_crypto.so`
  - `apk/lib/armeabi-v7a/libspacebar_crypto.so`
  - `apk/lib/x86_64/libspacebar_crypto.so`

#### Google Play Distribution

```bash
# Ensure keystore is configured
# In android/key.properties:
storePassword=YOUR_PASSWORD
keyPassword=YOUR_PASSWORD
keyAlias=spacebar

# Build bundle
flutter build appbundle --release

# Upload via Play Console or:
bundletool build-apks --bundle=build/app/outputs/bundle/release/app-release.aab --output=app.apks
bundletool install-apks --apks=app.apks
```

---

## Cross-Platform Distribution

### GitHub Releases

```yaml
# .github/workflows/release.yml
name: Release

on:
    push:
        tags:
            - "v*"

jobs:
    build:
        runs-on: ${{ matrix.os }}
        strategy:
            matrix:
                os: [windows-latest, macos-latest, ubuntu-latest]

        steps:
            - uses: actions/checkout@v3

            - name: Install Rust
              uses: actions-rs/toolchain@v1
              with:
                  toolchain: stable

            - name: Setup Flutter
              uses: subosito/flutter-action@v2

            - name: Build
              run: |
                  flutter pub get
                  flutter build windows --release  # or macos/linux

            - name: Upload Release Asset
              uses: softprops/action-gh-release@v1
              with:
                  files: build/**/release/*
```

### Self-Hosted Distribution

**Structure**:

```
distribution.example.com/
├── windows/
│   └── spacebar-0.1.0.zip
├── macos/
│   └── spacebar-0.1.0.dmg
└── linux/
    └── spacebar-0.1.0.AppImage
```

### Update Mechanism

Consider implementing update checks:

```dart
// In your app
Future<void> checkForUpdates() async {
  final response = await http.get(
    Uri.parse('https://distribution.example.com/latest-version.json'),
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final latestVersion = data['version'];

    if (latestVersion != currentVersion) {
      // Notify user of update
    }
  }
}
```

---

## Library Distribution

### Separate Binary Distribution

If you want to distribute the Rust library separately:

```bash
# Build library
cd rust
cargo build --release

# Create distribution package
mkdir spacebar_crypto_dist/
cp target/release/spacebar_crypto.dll spacebar_crypto_dist/  # Windows
cp target/release/libspacebar_crypto.so spacebar_crypto_dist/ # Linux
cp target/release/libspacebar_crypto.dylib spacebar_crypto_dist/ # macOS

# Create archive
zip -r spacebar_crypto-0.1.0.zip spacebar_crypto_dist/

# Upload and manage versions
# Users can download and place in app directory
```

---

## Performance Optimization for Distribution

### Reduce Binary Size

#### Release Build Optimization

```toml
# Cargo.toml
[profile.release]
opt-level = 3
lto = true
codegen-units = 1
strip = true  # Strip symbols from binary
```

#### Flutter Release Build

```bash
flutter build windows --release --split-debug-info
```

### Expected Binary Sizes

| Platform | Library Size     | App (with Flutter) |
| -------- | ---------------- | ------------------ |
| Windows  | ~2-3 MB          | ~50+ MB            |
| macOS    | ~2-3 MB          | ~60+ MB            |
| Linux    | ~2-3 MB          | ~40+ MB            |
| iOS      | ~3-4 MB (static) | ~60+ MB            |
| Android  | ~2-3 MB per arch | ~40+ MB            |

---

## Security Considerations for Distribution

### Code Signing

**Windows**:

```batch
signtool sign /f certificate.pfx /p password /t http://timestamp.server spacebar.exe
```

**macOS**:

```bash
codesign -s "Developer ID Application" spacebar.app
```

**Linux**: (Usually not signed, but can use GPG)

```bash
gpg --detach-sign spacebar
```

### Checksum Verification

Provide checksums for integrity:

```bash
# Generate checksums
sha256sum spacebar-windows.zip > SHA256SUMS
sha256sum spacebar-macos.dmg >> SHA256SUMS
sha256sum spacebar-linux.AppImage >> SHA256SUMS

# Distribute SHA256SUMS file alongside binaries
# Users can verify:
sha256sum -c SHA256SUMS
```

### Privacy Policy

Include privacy policy mentioning:

- "Uses local hashing via Rust FFI bridge"
- "No data sent to external servers"
- "Hashing is performed locally on device"

---

## Deployment Checklist

### Pre-Release

- [ ] Version bumped in Cargo.toml
- [ ] Version bumped in pubspec.yaml
- [ ] CHANGELOG.md updated
- [ ] All tests passing
- [ ] Release notes written
- [ ] Hash verification working

### Build

- [ ] Windows build succeeds
- [ ] macOS build succeeds
- [ ] Linux build succeeds
- [ ] iOS build succeeds
- [ ] Android build succeeds

### Testing

- [ ] Smoke test on each platform
- [ ] Hash functions work correctly
- [ ] No runtime errors
- [ ] Performance acceptable

### Distribution

- [ ] Binaries uploaded
- [ ] Checksums generated
- [ ] Code signed (if required)
- [ ] Notarized (macOS)
- [ ] Release notes published
- [ ] Update mechanism triggered (if applicable)

### Post-Release

- [ ] Monitor for issues
- [ ] Update documentation
- [ ] Create GitHub release
- [ ] Update download links

---

## Troubleshooting Distribution Issues

| Issue                              | Solution                           |
| ---------------------------------- | ---------------------------------- |
| "Library not found" on user system | Ensure library is bundled with app |
| Code signature invalid             | Re-sign with correct certificate   |
| Update fails to install            | Verify version format (semver)     |
| App crashes on startup             | Check hash function availability   |
| Performance degradation            | Ensure release build was used      |

---

## References

- [Flutter Documentation](https://flutter.dev/docs)
- [Rust FFI Guide](https://doc.rust-lang.org/nomicon/ffi.html)
- [Code Signing (Apple)](https://developer.apple.com/documentation/code_signing)
- [Windows Code Signing](https://learn.microsoft.com/en-us/windows-hardware/drivers/install/code-signing)

---

**Last Updated**: May 2026 **Applicable to**: Spacebar 0.1.0+
