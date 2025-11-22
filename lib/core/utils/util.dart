import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:fpdart/fpdart.dart';
import 'package:pointycastle/digests/sha3.dart';
import 'package:spacebar/core/error/err.dart';

Future<Either<FileError, String>> getFileHash(String filePath) async {
  try {
    final file = File(filePath);
    final digest = SHA3Digest(256);
    final inputStream = file.openRead();
    await for (final chunk in inputStream) {
      digest.update(Uint8List.fromList(chunk), 0, chunk.length);
    }
    final out = Uint8List(digest.digestSize);
    digest.doFinal(out, 0);
    final hash = base64Encode(out);

    return Right(hash);
  } catch (e) {
    return Left(FileError(e.toString()));
  }
}

Either<FileError, int> getFileSize(String filePath) {
  try {
    final file = File(filePath);
    final size = file.lengthSync();
    return Right(size);
  } catch (e) {
    return Left(FileError(e.toString()));
  }
}
