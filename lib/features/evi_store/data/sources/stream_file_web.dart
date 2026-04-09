import 'dart:typed_data';

import 'package:logger/logger.dart';
import 'package:spacebar/core/common/models/picked_file_data.dart';
import 'package:spacebar/core/common/models/progress_state.dart';
import 'package:spacebar/features/evi_store/domain/repos/istorerepo.dart';
import 'package:spacebar/generated/dues.pbgrpc.dart';

Stream<StreamFileReq> streamFileWeb({
  required String fileType,
  required PickedFileData fileData,
  required String fileHash,
  required Logger logger,
  OnProgressChanged? onProgress,
}) async* {
  final platformFile = fileData.webFile;
  final Stream<List<int>> readStream = platformFile.readStream!;

  final metadata = StreamFileMeta(
    filePath: fileData.name,
    fileType: fileType,
    fileHash: fileHash,
  );

  final fileSize = platformFile.size;
  yield StreamFileReq(fileMeta: metadata);
  logger.d(
    'Sent metadata: ${metadata.filePath}, size: $fileSize, type: $fileType',
  );

  int sentBytes = 0;
  await for (final stream in readStream) {
    if (stream.isEmpty) {
      continue;
    }

    final bytes = Uint8List.fromList(stream);
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
}
