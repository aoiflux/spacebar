import 'dart:collection';
import 'dart:io';

import 'package:fixnum/fixnum.dart';
import 'package:fpdart/fpdart.dart';
import 'package:logger/logger.dart';
import 'package:spacebar/core/utils/util.dart';
import 'package:spacebar/features/evi_list/data/models/stream_evidence_model.dart';
import 'package:spacebar/generated/dues.pbgrpc.dart';

abstract interface class IEviRemoteDataSource {
  Future<EvidenceFileModel?> appendIfExists(String filePath);
  Future<EvidenceFileModel> streamFile(String fileType, String filePath);
}

class GrpcImpl implements IEviRemoteDataSource {
  final Logger logger;
  late final DuesServiceClient client;
  GrpcImpl(this.client, this.logger);

  String _fileHash = "";
  int _fileSize = 0;

  @override
  Future<EvidenceFileModel?> appendIfExists(String filePath) async {
    final fileHashResult = await getFileHash(filePath);
    fileHashResult.match((l) => _fileHash = "", (r) => _fileHash = r);

    _fileSize = getFileSize(filePath).getRight().getOrElse(() => 0);

    AppendIfExistsReq req = AppendIfExistsReq(
      filePath: filePath,
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
      fileName: filePath,
      totalSize: _fileSize,
      chunkMap: chunkMap,
      compressedSize: chunkMap.values.fold(0, (sum, size) => sum + size),
      fileId: res.eviFile.fileId,
    );
    return model;
  }

  @override
  Future<EvidenceFileModel> streamFile(String fileType, String filePath) async {
    // Prepare file metadata
    if (_fileHash.isEmpty) {
      final fileHashResult = await getFileHash(filePath);
      fileHashResult.match((l) => _fileHash = "", (r) => _fileHash = r);
    }
    if (_fileSize == 0) {
      _fileSize = getFileSize(filePath).getRight().getOrElse(() => 0);
    }

    final file = File(filePath);
    if (!await file.exists()) {
      throw Exception('File not found: $filePath');
    }

    // Create stream controller for sending requests
    Stream<StreamFileReq> generateRequests() async* {
      // First, send metadata
      final metadata = StreamFileMeta(
        filePath: filePath,
        fileSize: Int64(_fileSize),
        fileType: fileType,
        fileHash: _fileHash,
      );

      yield StreamFileReq(fileMeta: metadata);
      logger.d('Sent metadata: $filePath, size: $_fileSize, type: $fileType');

      // Then stream file chunks with 256KB chunk size
      const chunkSize = 256 * 1024; // 256KB chunks
      final raf = await file.open(mode: FileMode.read);

      try {
        final buffer = List<int>.filled(chunkSize, 0);
        int sentBytes = 0;
        int bytesRead;

        while ((bytesRead = await raf.readInto(buffer)) > 0) {
          yield StreamFileReq(file: buffer.sublist(0, bytesRead));
          sentBytes += bytesRead;

          // Optional: log progress
          if (sentBytes % (1024 * 1024) == 0 || sentBytes == _fileSize) {
            logger.d('Streamed: $sentBytes / $_fileSize bytes');
          }
        }
      } finally {
        await raf.close();
      }
      logger.d('File streaming completed: $filePath');
    }

    try {
      // Call the streaming RPC
      final res = await client.streamFile(generateRequests());

      if (!res.done) {
        throw Exception('Streaming failed: ${res.err}');
      }

      if (res.err.isNotEmpty) {
        throw Exception('Server error: ${res.err}');
      }

      HashMap<String, Int64> resMap = HashMap.from(res.eviFile.chunkMap);
      HashMap<String, int> chunkMap = HashMap();
      resMap.forEach((key, value) {
        chunkMap[key] = value.toInt();
      });

      final model = EvidenceFileModel(
        fileName: filePath,
        totalSize: _fileSize,
        chunkMap: chunkMap,
        compressedSize: chunkMap.values.fold(0, (sum, size) => sum + size),
        fileId: res.eviFile.fileId,
      );

      // Reset state for next call
      _fileHash = "";
      _fileSize = 0;

      return model;
    } catch (e) {
      logger.e('Error streaming file: $e');
      _fileHash = "";
      _fileSize = 0;
      rethrow;
    }
  }
}
