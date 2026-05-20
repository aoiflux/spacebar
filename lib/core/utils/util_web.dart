import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:pointycastle/digests/sha3.dart';
import 'package:spacebar/core/common/models/picked_file_data.dart';
import 'package:spacebar/core/error/err.dart';
import 'package:spacebar/core/utils/crypto_ffi.dart';

String _hexToBase64(String hex) {
  final bytes = Uint8List(hex.length ~/ 2);
  for (int i = 0; i < bytes.length; i++) {
    bytes[i] = int.parse(hex.substring(i * 2, i * 2 + 2), radix: 16);
  }
  return base64Encode(bytes);
}

String _sha3Base64FromBytes(Uint8List bytes) {
  final digest = SHA3Digest(256);
  digest.update(bytes, 0, bytes.length);
  final out = Uint8List(digest.digestSize);
  digest.doFinal(out, 0);
  return base64Encode(out);
}

/// Web-specific: compute hash from browser file data.
///
/// Uses Rust/FRB first (bytes API), then falls back to Dart SHA3.
Future<Either<FileError, String>> getFileHashWeb(
  PickedFileData fileData,
) async {
  try {
    final platformFile = fileData.webFile;
    Uint8List? bytes = platformFile.bytes;
    if (bytes == null) {
      final readStream = platformFile.readStream;
      if (readStream == null) {
        return Left(
          FileError(
            'Cannot compute hash: both bytes and readStream are unavailable.',
          ),
        );
      }

      final builder = BytesBuilder(copy: false);
      await for (final stream in readStream) {
        builder.add(stream is Uint8List ? stream : Uint8List.fromList(stream));
      }
      bytes = builder.takeBytes();
    }

    try {
      debugPrint("Attempting FRB hash function call");
      final hex = await SpacebarCrypto.sha3HashBytes(bytes);
      return Right(_hexToBase64(hex));
    } catch (_) {
      debugPrint("Falling back to dart-based computation");
      return Right(_sha3Base64FromBytes(bytes));
    }
  } catch (e) {
    return Left(FileError(e.toString()));
  }
}
