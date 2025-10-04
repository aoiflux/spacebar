import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:flutter/material.dart';
import 'package:spacebar/core/error/err.dart';

void showSnackBar(BuildContext context, String msg) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(msg)));
}

Either<FileError, String> getFileHash(String filePath) {
  try {
    final file = File(filePath);
    return Right("");
  } catch (e) {
    return Left(FileError(e.toString()));
  }
}
