import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:fpdart/fpdart.dart';
import 'package:pointycastle/digests/sha3.dart';
import 'package:spacebar/core/common/models/picked_file_data.dart';
import 'package:spacebar/core/error/err.dart';

String _computeHashSync(String filePath) {
  final file = File(filePath);
  final digest = SHA3Digest(256);
  const chunkSize = 256 * 1024; // 256KB chunks

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

Future<Either<FileError, String>> getFileHashDesktop(
  PickedFileData fileData,
) async {
  try {
    final filePath = fileData.path!;
    final hash = await Isolate.run(() => _computeHashSync(filePath));
    return Right(hash);
  } catch (e) {
    return Left(FileError(e.toString()));
  }
}
