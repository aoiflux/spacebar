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
    final digest = SHA3Digest(256);
    final yieldWatch = Stopwatch()..start();

    Future<void> maybeYield() async {
      // Keep hashing responsive by yielding at ~1 frame budget.
      if (yieldWatch.elapsedMilliseconds >= 8) {
        yieldWatch
          ..reset()
          ..start();
        await Future<void>.delayed(Duration.zero);
      }
    }

    final bytes = platformFile.bytes;
    if (bytes != null && bytes.isNotEmpty) {
      const chunkSize = 256 * 1024;
      for (int offset = 0; offset < bytes.length; offset += chunkSize) {
        final end =
            (offset + chunkSize < bytes.length) ? offset + chunkSize : bytes.length;
        digest.update(bytes, offset, end - offset);
        await maybeYield();
      }
    } else {
      final readStream = platformFile.readStream;
      if (readStream == null) {
        return Left(
          FileError(
            'Cannot compute hash: both bytes and readStream are unavailable.',
          ),
        );
      }

      await for (final stream in readStream) {
        final chunk = stream is Uint8List ? stream : Uint8List.fromList(stream);
        digest.update(chunk, 0, chunk.length);
        await maybeYield();
      }
    }

    final out = Uint8List(digest.digestSize);
    digest.doFinal(out, 0);

    return Right(base64Encode(out));
  } catch (e) {
    return Left(FileError(e.toString()));
  }
}
