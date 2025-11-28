import 'dart:io';
import 'package:fpdart/fpdart.dart';
import 'package:spacebar/core/common/entities/evidence.dart';
import 'package:spacebar/core/error/except.dart';
import 'package:spacebar/core/error/failure.dart';
import 'package:spacebar/core/utils/file_type_detector.dart';
import 'package:spacebar/features/evi_list/data/sources/grpc_impl.dart';
import 'package:spacebar/features/evi_list/domain/entities/upload_progress.dart';
import 'package:spacebar/features/evi_list/domain/repo/ievirepo.dart';
import 'package:logger/logger.dart';

class EviRepoImpl implements IEviRepo {
  final Logger logger;
  final IEviRemoteDataSource rds;
  const EviRepoImpl(this.rds, this.logger);

  Future<Either<Failure, Evidence>> _getEvidence(
    Future<Evidence> Function() fn,
  ) async {
    try {
      final evidence = await fn();
      return right(evidence);
    } on ServerException catch (e) {
      logger.log(Level.error, e);
      return left(Failure(e.message));
    }
  }

  Future<Either<Failure, List<Evidence>>> _getEvidenceList(
    Future<List<Evidence>> Function() fn,
  ) async {
    try {
      final evidenceList = await fn();
      return right(evidenceList);
    } on ServerException catch (e) {
      logger.log(Level.error, e);
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Evidence>>> getEvidenceFiles() async {
    return _getEvidenceList(() async {
      final files = await rds.getEviFiles();
      return files;
    });
  }

  @override
  Future<Either<Failure, List<Evidence>>> getIndexedFiles({
    required String partiFileId,
  }) async {
    return left(Failure('GetIndexedFiles not yet implemented on backend'));
  }

  @override
  Future<Either<Failure, List<Evidence>>> getPartitionFiles({
    required String eviFileId,
  }) async {
    return left(Failure('GetPartitionFiles not yet implemented on backend'));
  }

  @override
  Future<Either<Failure, Evidence>> storeEvidence({
    required String eviPath,
    Function(UploadProgress, UploadStatus)? onProgress,
  }) async {
    return _getEvidence(() async {
      onProgress?.call(
        UploadProgress(
          filePath: eviPath,
          totalBytes: 0,
          status: UploadStatus.hashing,
        ),
        UploadStatus.hashing,
      );

      final fileHash = await GrpcImpl.computeFileHash(eviPath);
      final fileSize = await _getFileSize(eviPath);

      logger.i('File hash: $fileHash, size: $fileSize');

      onProgress?.call(
        UploadProgress(
          filePath: eviPath,
          sha256Hash: fileHash,
          totalBytes: fileSize,
          status: UploadStatus.checkingExists,
        ),
        UploadStatus.checkingExists,
      );

      try {
        final existsResult = await rds.appendIfExists(eviPath, fileHash);
        
        logger.i('File already exists in database, path appended');
        return Evidence(
          fileName: existsResult.fileName,
          filePath: existsResult.filePath,
          fileId: existsResult.fileId,
          totalSize: existsResult.totalSize,
          sha256Hash: fileHash, // Use locally computed hash
          compressedSize: existsResult.compressedSize,
          chunkMap: existsResult.chunkMap,
        );
      } on ServerException catch (e) {
        logger.i('File does not exist, proceeding with upload: ${e.message}');
      }

      onProgress?.call(
        UploadProgress(
          filePath: eviPath,
          sha256Hash: fileHash,
          totalBytes: fileSize,
          status: UploadStatus.uploading,
        ),
        UploadStatus.uploading,
      );

      final fileType = FileTypeDetector.detectFileType(eviPath);

      final evidence = await rds.streamFile(
        fileType,
        eviPath,
        fileHash,
        fileSize,
        onProgress: (uploadedBytes, uploadedChunks, totalChunks) {
          onProgress?.call(
            UploadProgress(
              filePath: eviPath,
              sha256Hash: fileHash,
              totalBytes: fileSize,
              uploadedBytes: uploadedBytes,
              uploadedChunks: uploadedChunks,
              totalChunks: totalChunks,
              status: UploadStatus.uploading,
            ),
            UploadStatus.uploading,
          );
        },
      );

      logger.i('File uploaded successfully');
      return Evidence(
        fileName: evidence.fileName,
        filePath: evidence.filePath,
        fileId: evidence.fileId,
        totalSize: evidence.totalSize,
        sha256Hash: fileHash, // Use locally computed hash
        compressedSize: evidence.compressedSize,
        chunkMap: evidence.chunkMap,
      );
    });
  }

  Future<int> _getFileSize(String filePath) async {
    final file = await File(filePath).stat();
    return file.size;
  }
}
