import 'package:spacebar/generated/rust/frb_generated.dart' show RustLib;
import 'package:spacebar/generated/rust/lib.dart' as rust_api;

/// Native Rust hashing via flutter_rust_bridge.
///
/// Returns a **lowercase hex** string on success; throws if the native
/// library is unavailable (e.g. bindings not yet generated).
/// Platform-specific fallbacks live in util_io.dart / util_web.dart.
class SpacebarCrypto {
  static Future<void>? _initFuture;

  static Future<void> _ensureInitialized() async {
    _initFuture ??= RustLib.init();
    try {
      await _initFuture;
    } catch (_) {
      _initFuture = null;
      rethrow;
    }
  }

  /// SHA3-256 hash of the file at [filePath].
  /// Throws [UnimplementedError] until `flutter_rust_bridge_codegen generate`
  /// has been run and the generated bindings are wired in.
  static Future<String> sha3HashFile(String filePath) =>
      _nativeSha3Hash(filePath);

  /// SHA3-256 hash of raw bytes.
  static Future<String> sha3HashBytes(List<int> data) =>
      _nativeSha3HashBytes(data);

  /// BLAKE3 hash of the file at [filePath]. Reserved for future use.
  static Future<String> blake3HashFile(String filePath) =>
      _nativeBlake3Hash(filePath);

  // ---------------------------------------------------------------------------
  // Native FRB calls.
  // ---------------------------------------------------------------------------

  static Future<String> _nativeSha3Hash(String filePath) async {
    try {
      await _ensureInitialized();
      return await rust_api.sha3Hash(filePath: filePath);
    } catch (e) {
      throw CryptoException('Native SHA3 hashing failed: $e');
    }
  }

  static Future<String> _nativeBlake3Hash(String filePath) async {
    try {
      await _ensureInitialized();
      return await rust_api.blake3Hash(filePath: filePath);
    } catch (e) {
      throw CryptoException('Native BLAKE3 hashing failed: $e');
    }
  }

  static Future<String> _nativeSha3HashBytes(List<int> data) async {
    try {
      await _ensureInitialized();
      return await rust_api.sha3HashBytes(data: data);
    } catch (e) {
      throw CryptoException('Native SHA3 bytes hashing failed: $e');
    }
  }
}

/// Exception thrown when a hashing operation fails.
class CryptoException implements Exception {
  final String message;

  const CryptoException(this.message);

  @override
  String toString() => 'CryptoException: $message';
}
