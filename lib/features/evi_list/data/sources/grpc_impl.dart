import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:fixnum/fixnum.dart';
import 'package:logger/logger.dart';
import 'package:pointycastle/digests/sha3.dart';
import 'package:spacebar/core/error/except.dart';
import 'package:spacebar/features/evi_list/data/models/stream_evidence_model.dart';
import 'package:spacebar/generated/dues.pbgrpc.dart';

abstract interface class IEviRemoteDataSource {
  Future<EvidenceFileModel> appendIfExists(String filePath, String fileHash);
  Future<EvidenceFileModel> streamFile(
    String fileType,
    String filePath,
    String fileHash,
    int fileSize, {
    Function(int uploadedBytes, int uploadedChunks, int totalChunks)? onProgress,
  });
  Future<List<EvidenceFileModel>> getEviFiles();
}

class GrpcImpl implements IEviRemoteDataSource {
  final Logger logger;
  final DuesServiceClient client;

  static const int chunkSize = 1024 * 1024;

  GrpcImpl(this.client, this.logger);

  @override
  Future<EvidenceFileModel> appendIfExists(
    String filePath,
    String fileHash,
  ) async {
    try {
      final req = AppendIfExistsReq(
        filePath: filePath,
        fileHash: fileHash,
      );

      final response = await client
          .appendIfExists(req)
          .timeout(const Duration(seconds: 5));

      if (response.err.isNotEmpty) {
        throw ServerException(response.err);
      }

      if (!response.exists) {
        throw ServerException('File does not exist in database');
      }

      logger.i('File exists, appended=${response.appended}');
      return _mapBaseFileToModel(response.eviFile);
    } on TimeoutException {
      logger.e('Connection timeout - is the backend server running?');
      throw ServerException(
          'Cannot connect to backend server at localhost:50051. Please start the indicer gRPC server.');
    } catch (e) {
      logger.e('Error in appendIfExists: $e');
      throw ServerException(e.toString());
    }
  }

  @override
  Future<EvidenceFileModel> streamFile(
    String fileType,
    String filePath,
    String fileHash,
    int fileSize, {
    Function(int uploadedBytes, int uploadedChunks, int totalChunks)? onProgress,
  }) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        throw ServerException('File not found: $filePath');
      }

      final totalChunks = (fileSize / chunkSize).ceil();
      int uploadedBytes = 0;
      int uploadedChunks = 0;

      logger.i('Starting file stream for: $filePath');

      Stream<StreamFileReq> requestStream() async* {
        final meta = StreamFileMeta(
          filePath: filePath,
          fileSize: Int64(fileSize),
          fileType: fileType,
          fileHash: fileHash,
        );

        logger.i('Sending metadata: type=$fileType, size=$fileSize');
        yield StreamFileReq(fileMeta: meta);

        final fileStream = file.openRead();

        await for (var chunk in fileStream) {
          uploadedBytes += chunk.length;
          uploadedChunks++;
          yield StreamFileReq(file: chunk);

          onProgress?.call(uploadedBytes, uploadedChunks, totalChunks);
        }
      }

      final response = await client
          .streamFile(requestStream())
          .timeout(const Duration(seconds: 30));

      if (response.err.isNotEmpty) {
        throw ServerException(response.err);
      }

      if (!response.done) {
        throw ServerException('File upload incomplete');
      }

      if (!response.hasEviFile()) {
        throw ServerException('Response missing eviFile');
      }

      logger.i('Mapping response to model...');
      return _mapBaseFileToModel(response.eviFile);
    } on TimeoutException {
      logger.e('Upload timeout - backend server not responding');
      throw ServerException(
          'Upload timeout. Please ensure the indicer gRPC server is running on localhost:50051');
    } catch (e) {
      logger.e('Error in streamFile: $e');
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<EvidenceFileModel>> getEviFiles() async {
    try {
      final req = GetEviFilesReq();
      final response = await client.getEviFiles(req);

      if (response.err.isNotEmpty) {
        throw ServerException(response.err);
      }

      return response.eviFile.map(_mapBaseFileToModel).toList();
    } catch (e) {
      logger.e('Error in getEviFiles: $e');
      throw ServerException(e.toString());
    }
  }

  EvidenceFileModel _mapBaseFileToModel(BaseFile baseFile) {
    final chunkMap = HashMap<String, int>.from(
      baseFile.chunkMap.map((key, value) => MapEntry(key, value.toInt())),
    );

    final totalSize = chunkMap.values.fold<int>(0, (sum, size) => sum + size);

    return EvidenceFileModel(
      fileName: baseFile.filePath.split('/').last,
      filePath: baseFile.filePath,
      fileId: baseFile.fileId,
      totalSize: totalSize,
      sha256Hash: '',
      compressedSize: totalSize,
      chunkMap: chunkMap,
    );
  }

  static Future<String> computeFileHash(String filePath) async {
    final file = File(filePath);
    final bytes = await file.readAsBytes();
    final digest = SHA3Digest(256);
    final hash = digest.process(Uint8List.fromList(bytes));
    return base64.encode(hash);
  }
}
