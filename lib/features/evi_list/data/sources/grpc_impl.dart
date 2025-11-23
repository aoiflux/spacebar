import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'dart:typed_data';
import 'package:fixnum/fixnum.dart';
import 'package:logger/logger.dart';
import 'package:spacebar/core/error/except.dart';
import 'package:spacebar/core/utils/file_hash_util.dart';
import 'package:spacebar/features/evi_list/data/models/stream_evidence_model.dart';
import 'package:spacebar/generated/dues.pbgrpc.dart';

abstract interface class IEviRemoteDataSource {
  Future<EvidenceFileModel> appendIfExists(String filePath, String fileHash);
  Future<EvidenceFileModel> streamFile({
    required String filePath,
    required String sha256Hash,
    required int fileSize,
    Function(int uploadedBytes, int uploadedChunks, int totalChunks)? onProgress,
  });
}

class GrpcImpl implements IEviRemoteDataSource {
  final Logger logger;
  final DuesServiceClient client;
  
  static const int chunkSize = 1024 * 1024; // 1MB chunks

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

      // Create a minimal evidence model for existence check
      return EvidenceFileModel(
        fileName: filePath.split('/').last,
        filePath: filePath,
        totalSize: 0,
        sha256Hash: fileHash,
        compressedSize: 0,
        chunkMap: HashMap<String, int>(),
        exists: response.exists,
        fullyUploaded: response.appended,
      );
    } on TimeoutException {
      logger.log(Level.error, 'Connection timeout - is the backend server running?');
      throw ServerException(
          'Cannot connect to backend server at localhost:50051. Please start the indicer gRPC server.');
    } catch (e) {
      logger.log(Level.error, 'Error checking if file exists: $e');
      throw ServerException(
          'Backend connection error: ${e.toString()}. Make sure the indicer server is running on localhost:50051');
    }
  }

  @override
  Future<EvidenceFileModel> streamFile({
    required String filePath,
    required String sha256Hash,
    required int fileSize,
    Function(int uploadedBytes, int uploadedChunks, int totalChunks)? onProgress,
  }) async {
    try {
      final file = File(filePath);
      final totalChunks = (fileSize / chunkSize).ceil();
      int uploadedBytes = 0;
      int uploadedChunks = 0;

      // Create stream controller for requests
      final requestStream = Stream<StreamFileReq>.multi((controller) async {
        try {
          // First, send metadata
          final metadata = StreamFileMeta(
            filePath: filePath,
            fileSize: Int64(fileSize),
            fileType: _detectFileType(filePath),
            fileHash: sha256Hash,
          );

          controller.add(StreamFileReq(fileMeta: metadata));

          // Then stream file chunks
          final fileStream = file.openRead();
          await for (var chunk in fileStream) {
            final bytes = Uint8List.fromList(chunk);
            controller.add(StreamFileReq(file: bytes));

            uploadedBytes += bytes.length;
            uploadedChunks++;

            onProgress?.call(uploadedBytes, uploadedChunks, totalChunks);
          }

          controller.close();
        } catch (e) {
          controller.addError(e);
          controller.close();
        }
      });

      final response = await client
          .streamFile(requestStream)
          .timeout(const Duration(seconds: 30));

      if (response.err.isNotEmpty) {
        throw ServerException(response.err);
      }

      if (!response.done) {
        throw ServerException('Upload incomplete');
      }

      return EvidenceFileModel.fromProto(
        response.eviFile,
        filePath: filePath,
        sha256Hash: sha256Hash,
        totalSize: fileSize,
        exists: true,
        fullyUploaded: true,
      );
    } on TimeoutException {
      logger.log(Level.error, 'Upload timeout - backend server not responding');
      throw ServerException(
          'Upload timeout. Please ensure the indicer gRPC server is running on localhost:50051');
    } catch (e) {
      logger.log(Level.error, 'Error streaming file: $e');
      throw ServerException('Upload error: ${e.toString()}');
    }
  }

  String _detectFileType(String filePath) {
    final extension = filePath.split('.').last.toLowerCase();
    // Add more file type detection logic as needed
    if (extension == 'img' || extension == 'dd' || extension == 'raw') {
      return 'disk_image';
    }
    return 'unknown';
  }
}
