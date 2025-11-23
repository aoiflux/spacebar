import 'package:fpdart/fpdart.dart';
import 'package:spacebar/core/common/entities/evidence.dart';
import 'package:spacebar/core/error/except.dart';
import 'package:spacebar/core/error/failure.dart';
import 'package:spacebar/core/utils/file_hash_util.dart';
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

  @override
  Future<Either<Failure, Evidence>> getEvidenceFiles() {
    // TODO: implement getEvidenceFiles
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Evidence>> getIndexedFiles({
    required String partiFileId,
  }) {
    // TODO: implement getIndexedFiles
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Evidence>> getPartitionFiles({
    required String eviFileId,
  }) {
    // TODO: implement getPartitionFiles
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Evidence>> storeEvidence({
    required String eviPath,
    Function(UploadProgress, UploadStatus)? onProgress,
  }) async {
    return _getEvidence(() async {
      // Step 1: Calculate file hash
      onProgress?.call(
        UploadProgress(
          filePath: eviPath,
          totalBytes: 0,
          status: UploadStatus.hashing,
        ),
        UploadStatus.hashing,
      );

      final sha256Hash = await FileHashUtil.calculateSha256(eviPath);
      final fileSize = await FileHashUtil.getFileSize(eviPath);

      logger.log(Level.info, 'File hash: $sha256Hash, size: $fileSize');

      // Step 2: Check if file exists
      onProgress?.call(
        UploadProgress(
          filePath: eviPath,
          sha256Hash: sha256Hash,
          totalBytes: fileSize,
          status: UploadStatus.checkingExists,
        ),
        UploadStatus.checkingExists,
      );

      final existsResult = await rds.appendIfExists(eviPath, sha256Hash);

      // If file exists and is fully uploaded, return immediately
      if (existsResult.exists && existsResult.fullyUploaded) {
        logger.log(Level.info, 'File already exists and is fully uploaded');
        return existsResult;
      }

      // Step 3: Upload file
      onProgress?.call(
        UploadProgress(
          filePath: eviPath,
          sha256Hash: sha256Hash,
          totalBytes: fileSize,
          status: UploadStatus.uploading,
        ),
        UploadStatus.uploading,
      );

      final evidence = await rds.streamFile(
        filePath: eviPath,
        sha256Hash: sha256Hash,
        fileSize: fileSize,
        onProgress: (uploadedBytes, uploadedChunks, totalChunks) {
          onProgress?.call(
            UploadProgress(
              filePath: eviPath,
              sha256Hash: sha256Hash,
              totalBytes: fileSize,
              uploadedBytes: uploadedBytes,
              totalChunks: totalChunks,
              uploadedChunks: uploadedChunks,
              status: UploadStatus.uploading,
            ),
            UploadStatus.uploading,
          );
        },
      );

      logger.log(Level.info, 'File uploaded successfully');
      return evidence;
    });
  }
}
