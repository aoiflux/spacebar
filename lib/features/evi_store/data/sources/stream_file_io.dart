import 'dart:io';

import 'package:logger/logger.dart';
import 'package:spacebar/core/common/models/picked_file_data.dart';
import 'package:spacebar/core/common/models/progress_state.dart';
import 'package:spacebar/features/evi_store/domain/repo/ievirepo.dart';
import 'package:spacebar/generated/dues.pbgrpc.dart';

Stream<StreamFileReq> streamFileDesktop({
  required String fileType,
  required PickedFileData fileData,
  required String fileHash,
  required Logger logger,
  OnProgressChanged? onProgress,
}) async* {
  final filePath = fileData.path;
  if (filePath == null || filePath.isEmpty) {
    throw Exception('File path is null or empty for desktop streaming.');
  }

  final file = File(filePath);
  if (!await file.exists()) {
    throw Exception('File not found: $filePath');
  }

  final metadata = StreamFileMeta(
    filePath: filePath,
    fileType: fileType,
    fileHash: fileHash,
  );

  final fileSize = await file.length();
  yield StreamFileReq(fileMeta: metadata);
  logger.d(
    'Sent metadata: ${metadata.filePath}, size: $fileSize, type: $fileType',
  );

  const chunkSize = 256 * 1024;
  final raf = await file.open(mode: FileMode.read);

  try {
    final buffer = List<int>.filled(chunkSize, 0);
    int sentBytes = 0;
    int bytesRead;

    while ((bytesRead = await raf.readInto(buffer)) > 0) {
      yield StreamFileReq(file: buffer.sublist(0, bytesRead));
      sentBytes += bytesRead;

      final progress = fileSize > 0 ? sentBytes / fileSize : 0.0;
      onProgress?.call(
        ProgressUpdate(
          stage: ProgressStage.streaming,
          progress: progress,
          message: '${(sentBytes ~/ 1024)} / ${(fileSize ~/ 1024)} KB',
        ),
      );

      if (sentBytes % (1024 * 1024) == 0 || sentBytes == fileSize) {
        logger.d('Streamed: $sentBytes / $fileSize bytes');
      }
    }
  } finally {
    await raf.close();
  }

  logger.d('File streaming completed: ${metadata.filePath}');
}
