<<<<<<< Updated upstream
import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'dart:typed_data';
import 'package:fixnum/fixnum.dart';
import 'package:logger/logger.dart';
import 'package:spacebar/core/error/except.dart';
import 'package:spacebar/core/utils/file_hash_util.dart';
=======
import 'dart:io';
import 'dart:collection';
import 'dart:convert';
import 'dart:typed_data';
import 'package:fixnum/fixnum.dart';
import 'package:logger/logger.dart';
import 'package:pointycastle/digests/sha3.dart';
import 'package:spacebar/core/error/except.dart';
>>>>>>> Stashed changes
import 'package:spacebar/features/evi_list/data/models/stream_evidence_model.dart';
import 'package:spacebar/generated/dues.pbgrpc.dart';

abstract interface class IEviRemoteDataSource {
  Future<EvidenceFileModel> appendIfExists(String filePath, String fileHash);
<<<<<<< Updated upstream
  Future<EvidenceFileModel> streamFile({
    required String filePath,
    required String sha256Hash,
    required int fileSize,
    Function(int uploadedBytes, int uploadedChunks, int totalChunks)? onProgress,
  });
=======
  Future<EvidenceFileModel> streamFile(
    String fileType,
    String filePath,
    String fileHash,
    int fileSize,
  );
  Future<List<EvidenceFileModel>> getEviFiles();
>>>>>>> Stashed changes
}

class GrpcImpl implements IEviRemoteDataSource {
  final Logger logger;
  final DuesServiceClient client;
<<<<<<< Updated upstream
  
  static const int chunkSize = 1024 * 1024; // 1MB chunks

=======
>>>>>>> Stashed changes
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

<<<<<<< Updated upstream
      final response = await client
          .appendIfExists(req)
          .timeout(const Duration(seconds: 5));
=======
      final response = await client.appendIfExists(req);
>>>>>>> Stashed changes

      if (response.err.isNotEmpty) {
        throw ServerException(response.err);
      }

<<<<<<< Updated upstream
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
=======
      if (!response.exists) {
        throw ServerException('File does not exist in database');
      }

      if (!response.appended) {
        throw ServerException('File was not appended');
      }

      // Map the returned BaseFile to model
      return _mapBaseFileToModel(response.eviFile);
    } catch (e) {
      logger.e('Error in appendIfExists: $e');
      throw ServerException(e.toString());
>>>>>>> Stashed changes
    }
  }

  @override
<<<<<<< Updated upstream
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
=======
  Future<EvidenceFileModel> streamFile(
    String fileType,
    String filePath,
    String fileHash,
    int fileSize,
  ) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        throw ServerException('File not found: $filePath');
      }

      logger.i('Starting file stream for: $filePath');

      // Create an async generator for the stream
      Stream<StreamFileReq> requestStream() async* {
        // Send metadata first
        final meta = StreamFileMeta(
          filePath: filePath,
          fileSize: Int64(fileSize),
          fileType: fileType,
          fileHash: fileHash,
        );

        logger.i('Sending metadata: type=$fileType, size=$fileSize');
        yield StreamFileReq(fileMeta: meta);

        // Stream file chunks (64KB chunks)
        final fileStream = file.openRead();
        int chunkCount = 0;

        await for (var chunk in fileStream) {
          chunkCount++;
          yield StreamFileReq(file: chunk);
        }
        
        logger.i('Sent $chunkCount chunks');
      }

      // Call streamFile with the request stream
      logger.i('Calling streamFile RPC...');
      final response = await client.streamFile(requestStream());
      
      logger.i('Received response: done=${response.done}, err=${response.err}');
>>>>>>> Stashed changes

      if (response.err.isNotEmpty) {
        throw ServerException(response.err);
      }

      if (!response.done) {
<<<<<<< Updated upstream
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
=======
        throw ServerException('File upload incomplete');
      }

      if (!response.hasEviFile()) {
        throw ServerException('Response missing eviFile');
      }

      logger.i('Mapping response to model...');
      return _mapBaseFileToModel(response.eviFile);
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
      fileName: baseFile.filePath,
      fileId: baseFile.fileId,
      totalSize: totalSize,
      compressedSize: totalSize, // Actual compression info not in proto
      chunkMap: chunkMap,
    );
  }

  static Future<String> computeFileHash(String filePath) async {
    final file = File(filePath);
    final bytes = await file.readAsBytes();
    final digest = SHA3Digest(256);
    final hash = digest.process(Uint8List.fromList(bytes));
    return base64.encode(hash);
>>>>>>> Stashed changes
  }
}
