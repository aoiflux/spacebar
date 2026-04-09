import 'dart:convert';
import 'dart:typed_data';

import 'package:fpdart/fpdart.dart';
import 'package:pointycastle/digests/sha3.dart';
import 'package:spacebar/core/common/models/picked_file_data.dart';
import 'package:spacebar/core/error/err.dart';

/// Web-specific: Compute hash from HTML File object using FileReader API
Future<Either<FileError, String>> getFileHashWeb(
  PickedFileData fileData,
) async {
  try {
    final platformFile = fileData.webFile;
    final readStream = platformFile.readStream!;

    final digest = SHA3Digest(256);

    await readStream.forEach((stream) {
      final bytes = Uint8List.fromList(stream);
      digest.update(bytes, 0, bytes.length);
    });

    final out = Uint8List(digest.digestSize);
    digest.doFinal(out, 0);

    return Right(base64Encode(out));
  } catch (e) {
    return Left(FileError(e.toString()));
  }
}
