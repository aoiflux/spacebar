import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:fpdart/fpdart.dart';
import 'package:pointycastle/digests/sha3.dart';
import 'package:spacebar/core/common/models/picked_file_data.dart';
import 'package:spacebar/core/error/err.dart';
import 'package:spacebar/core/utils/crypto_ffi.dart';

// Dart fallback — runs synchronously inside an Isolate.
String _computeHashSync(String filePath) {
  final file = File(filePath);
  final digest = SHA3Digest(256);
  const chunkSize = 256 * 1024; // 256 KB chunks

  final raf = file.openSync(mode: FileMode.read);
  try {
    final buffer = Uint8List(chunkSize);
    int bytesRead;
    while ((bytesRead = raf.readIntoSync(buffer)) > 0) {
      digest.update(buffer, 0, bytesRead);
    }
  } finally {
    raf.closeSync();
  }

  final out = Uint8List(digest.digestSize);
  digest.doFinal(out, 0);
  return base64Encode(out);
}

// FRB returns hex; callers expect base64 — convert to keep the format stable.
String _hexToBase64(String hex) {
  final bytes = Uint8List(hex.length ~/ 2);
  for (int i = 0; i < bytes.length; i++) {
    bytes[i] = int.parse(hex.substring(i * 2, i * 2 + 2), radix: 16);
  }
  return base64Encode(bytes);
}

Future<Either<FileError, String>> getFileHashDesktop(
  PickedFileData fileData,
) async {
  try {
    final filePath = fileData.path!;

    // 1. Prefer native Rust via FRB (compiled for current platform).
    try {
      debugPrint("Attempting FRB hash function call");
      final hex = await SpacebarCrypto.sha3HashFile(filePath);
      return Right(_hexToBase64(hex));
    } catch (_) {}

    debugPrint("Falling back to dart-based computation");
    // 2. Pure-Dart fallback — offloaded to a separate Isolate.
    final hash = await Isolate.run(() => _computeHashSync(filePath));
    return Right(hash);
  } catch (e) {
    return Left(FileError(e.toString()));
  }
}
