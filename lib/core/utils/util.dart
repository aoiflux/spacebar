import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:spacebar/core/error/err.dart';

Future<Either<FileError, String>> getFileHash(String filePath) async {
  try {
    final file = File(filePath);

    return Right("");
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

// TODO: Implement getCompressedSize function by converting PbMap into hashMap and summing up sizes
// Either<Error, int> getCompressedSize()
