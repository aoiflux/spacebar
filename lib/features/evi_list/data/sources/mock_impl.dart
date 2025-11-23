import 'dart:collection';
import 'dart:io';
import 'package:logger/logger.dart';
import 'package:spacebar/features/evi_list/data/models/stream_evidence_model.dart';
import 'package:spacebar/features/evi_list/data/sources/grpc_impl.dart';

class MockImpl implements IEviRemoteDataSource {
  final Logger logger;
  static const int chunkSize = 1024 * 1024; // 1MB chunks

  MockImpl(this.logger);

  @override
  Future<EvidenceFileModel> appendIfExists(
    String filePath,
    String fileHash,
  ) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    logger.log(Level.info, 'Mock: Checking if file exists - $fileHash');

    // Always return that file doesn't exist (so it will upload)
    return EvidenceFileModel(
      fileName: filePath.split('/').last,
      filePath: filePath,
      totalSize: 0,
      sha256Hash: fileHash,
      compressedSize: 0,
      chunkMap: HashMap<String, int>(),
      exists: false,
      fullyUploaded: false,
    );
  }

  @override
  Future<EvidenceFileModel> streamFile({
    required String filePath,
    required String sha256Hash,
    required int fileSize,
    Function(int uploadedBytes, int uploadedChunks, int totalChunks)? onProgress,
  }) async {
    logger.log(Level.info, 'Mock: Starting file upload - $filePath');

    final file = File(filePath);
    final totalChunks = (fileSize / chunkSize).ceil();
    int uploadedBytes = 0;
    int uploadedChunks = 0;

    // Simulate chunked upload with progress
    final fileStream = file.openRead();
    final chunkMap = HashMap<String, int>();

    await for (var chunk in fileStream) {
      // Simulate upload delay
      await Future.delayed(const Duration(milliseconds: 100));

      uploadedBytes += chunk.length;
      uploadedChunks++;

      // Create mock chunk hash
      final chunkHash = 'chunk_${uploadedChunks}_${chunk.length}';
      chunkMap[chunkHash] = chunk.length;

      onProgress?.call(uploadedBytes, uploadedChunks, totalChunks);

      logger.log(
        Level.debug,
        'Mock: Uploaded chunk $uploadedChunks/$totalChunks',
      );
    }

    logger.log(Level.info, 'Mock: Upload complete - $filePath');

    return EvidenceFileModel(
      fileName: filePath.split('/').last,
      filePath: filePath,
      totalSize: fileSize,
      sha256Hash: sha256Hash,
      compressedSize: uploadedBytes,
      chunkMap: chunkMap,
      exists: true,
      fullyUploaded: true,
    );
  }
}
