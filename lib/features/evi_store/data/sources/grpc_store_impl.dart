import 'dart:collection';

import 'package:fixnum/fixnum.dart';
import 'package:logger/logger.dart';
import 'package:spacebar/core/common/models/evidence_file_model.dart';
import 'package:spacebar/core/common/models/picked_file_data.dart';
import 'package:spacebar/core/common/models/progress_state.dart';
import 'package:spacebar/core/utils/util_io.dart';
import 'package:spacebar/core/utils/util_web.dart';
import 'package:spacebar/features/evi_store/data/sources/stream_file_io.dart';
import 'package:spacebar/features/evi_store/data/sources/stream_file_web.dart';
import 'package:spacebar/features/evi_store/domain/repos/istorerepo.dart';
import 'package:spacebar/generated/dues.pbgrpc.dart';

abstract interface class IEviStoreRemoteDataSource {
  Future<EvidenceFileModel?> appendIfExists(
    PickedFileData fileData, {
    OnProgressChanged? onProgress,
  });
  Future<EvidenceFileModel> streamFile(
    String fileType,
    PickedFileData fileData, {
    OnProgressChanged? onProgress,
  });
}

class GrpcStoreImpl implements IEviStoreRemoteDataSource {
  final Logger logger;
  late final DuesServiceClient client;
  GrpcStoreImpl(this.logger, this.client);

  String _fileHash = "";

  @override
  Future<EvidenceFileModel?> appendIfExists(
    PickedFileData fileData, {
    OnProgressChanged? onProgress,
  }) async {
    onProgress?.call(ProgressUpdate(stage: ProgressStage.hashing));

    final fileHashResult = fileData.isWeb
        ? await getFileHashWeb(fileData)
        : await getFileHashDesktop(fileData);

    fileHashResult.match((l) => _fileHash = "", (r) => _fileHash = r);

    onProgress?.call(ProgressUpdate(stage: ProgressStage.hashDone));

    onProgress?.call(ProgressUpdate(stage: ProgressStage.appendCheck));

    AppendIfExistsReq req = AppendIfExistsReq(
      filePath: fileData.path ?? fileData.name,
      fileHash: _fileHash,
    );

    AppendIfExistsRes res = await client.appendIfExists(req);
    if (!res.exists) {
      return null;
    }

    HashMap<String, Int64> resMap = HashMap.from(res.eviFile.chunkMap);
    HashMap<String, int> chunkMap = HashMap();
    resMap.forEach((key, value) {
      chunkMap[key] = value.toInt();
    });
    EvidenceFileModel model = EvidenceFileModel(
      fileName: fileData.path ?? fileData.name,
      totalSize: res.eviFile.fileSize.toInt(),
      chunkMap: chunkMap,
      compressedSize: chunkMap.values.fold(0, (sum, size) => sum + size),
      fileId: res.eviFile.fileId,
    );
    return model;
  }

  @override
  Future<EvidenceFileModel> streamFile(
    String fileType,
    PickedFileData fileData, {
    OnProgressChanged? onProgress,
  }) async {
    // Prepare file metadata
    if (_fileHash.isEmpty) {
      onProgress?.call(ProgressUpdate(stage: ProgressStage.hashing));

      final fileHashResult = fileData.isWeb
          ? await getFileHashWeb(fileData)
          : await getFileHashDesktop(fileData);

      fileHashResult.match((l) => _fileHash = "", (r) => _fileHash = r);
      onProgress?.call(ProgressUpdate(stage: ProgressStage.hashDone));
    }

    onProgress?.call(ProgressUpdate(stage: ProgressStage.streaming));
    final requestStream = fileData.isWeb
        ? streamFileWeb(
            fileType: fileType,
            fileData: fileData,
            fileHash: _fileHash,
            logger: logger,
            onProgress: onProgress,
          )
        : streamFileDesktop(
            fileType: fileType,
            fileData: fileData,
            fileHash: _fileHash,
            logger: logger,
            onProgress: onProgress,
          );

    try {
      // Call the streaming RPC
      final res = await client.streamFile(requestStream);

      if (!res.done) {
        throw Exception('Streaming failed: ${res.err}');
      }

      if (res.err.isNotEmpty) {
        throw Exception('Server error: ${res.err}');
      }

      onProgress?.call(ProgressUpdate(stage: ProgressStage.streamDone));

      HashMap<String, Int64> resMap = HashMap.from(res.eviFile.chunkMap);
      HashMap<String, int> chunkMap = HashMap();
      resMap.forEach((key, value) {
        chunkMap[key] = value.toInt();
      });

      final model = EvidenceFileModel(
        fileName: fileData.path ?? fileData.name,
        totalSize: res.eviFile.fileSize.toInt(),
        chunkMap: chunkMap,
        compressedSize: chunkMap.values.fold(0, (sum, size) => sum + size),
        fileId: res.eviFile.fileId,
      );

      // Reset state for next call
      _fileHash = "";

      return model;
    } catch (e) {
      logger.e('Error streaming file: $e');
      _fileHash = "";
      rethrow;
    }
  }
}
