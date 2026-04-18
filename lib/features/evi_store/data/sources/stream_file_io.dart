import 'dart:io';

import 'package:logger/logger.dart';
import 'package:spacebar/core/common/models/picked_file_data.dart';
import 'package:spacebar/core/common/models/progress_state.dart';
import 'package:spacebar/features/evi_store/domain/repos/istorerepo.dart';
import 'package:spacebar/generated/dues.pbgrpc.dart';

Stream<StreamFileReq> streamFileDesktop({
  required String fileType,
  required PickedFileData fileData,
  required String fileHash,
  required String metadataFilePath,
  bool stageToTempCopy = false,
  required Logger logger,
  OnProgressChanged? onProgress,
}) async* {
  final filePath = fileData.path;
  if (filePath == null || filePath.isEmpty) {
    throw Exception('File path is null or empty for desktop streaming.');
  }

  final sourceFile = File(filePath);
  if (!await sourceFile.exists()) {
    throw Exception('File not found: $filePath');
  }

  File file = sourceFile;
  Directory? stagedDir;
  if (stageToTempCopy) {
    stagedDir = await Directory.systemTemp.createTemp('spacebar_upload_');
    final safeName = fileData.name.trim().isNotEmpty
        ? fileData.name.trim()
        : 'upload.bin';
    final stagedPath = '${stagedDir.path}${Platform.pathSeparator}$safeName';
    logger.w('Staging upload file to temp copy: $stagedPath');
    file = await sourceFile.copy(stagedPath);
  }

  final metadata = StreamFileMeta(
    filePath: metadataFilePath,
    fileType: fileType,
    fileHash: fileHash,
  );

  try {
    final fileSize = await file.length();
    yield StreamFileReq(fileMeta: metadata);
    logger.d(
      'Sent metadata: ${metadata.filePath}, size: $fileSize, type: $fileType',
    );

    int sentBytes = 0;
    await for (final chunk in file.openRead(0, fileSize)) {
      if (chunk.isEmpty) {
        continue;
      }

      final List<int> bytes = chunk;
      yield StreamFileReq(file: bytes);
      sentBytes += bytes.length;

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

    logger.d('File streaming completed: ${metadata.filePath}');
  } finally {
    if (stagedDir != null) {
      try {
        await stagedDir.delete(recursive: true);
      } catch (_) {
        // Best-effort cleanup for temp staged upload files.
      }
    }
  }
}
