import 'dart:collection';

import 'package:fixnum/fixnum.dart';
import 'package:logger/logger.dart';
import 'package:spacebar/core/common/models/evidence_file_model.dart';
import 'package:spacebar/features/evi_list/domain/repo/ievlistirepo.dart';
import 'package:spacebar/generated/dues.pbgrpc.dart';

abstract interface class IEviListRemoteDataSource {
  Future<List<EvidenceFileModel>> getEviFiles({OnProgressChanged? onProgress});
  Future<List<EvidenceFileModel>> getPartiFiles(
    String eviFileId, {
    OnProgressChanged? onProgress,
  });
  Future<List<EvidenceFileModel>> getIdxFiles(
    String partiFileId, {
    OnProgressChanged? onProgress,
  });
}

class GrpcListImpl implements IEviListRemoteDataSource {
  final Logger logger;
  late final DuesServiceClient client;
  GrpcListImpl(this.logger, this.client);

  List<EvidenceFileModel> _toEvidenceList(List<BaseFile> files) {
    return files.map((file) {
      final HashMap<String, Int64> resMap = HashMap.from(file.chunkMap);
      final HashMap<String, int> chunkMap = HashMap();
      resMap.forEach((key, value) {
        chunkMap[key] = value.toInt();
      });

      return EvidenceFileModel(
        fileName: file.filePath,
        totalSize: file.fileSize.toInt(),
        chunkMap: chunkMap,
        compressedSize: chunkMap.values.fold(0, (sum, size) => sum + size),
        fileId: file.fileId,
      );
    }).toList();
  }

  @override
  Future<List<EvidenceFileModel>> getEviFiles({
    OnProgressChanged? onProgress,
  }) async {
    try {
      final res = await client.getEviFiles(GetEviFilesReq());

      if (!res.done) {
        throw Exception('Get evi files failed: ${res.err}');
      }

      if (res.err.isNotEmpty) {
        throw Exception('Server error: ${res.err}');
      }

      return _toEvidenceList(res.eviFile);
    } catch (e) {
      logger.e('Error getting evi files: $e');
      rethrow;
    }
  }

  @override
  Future<List<EvidenceFileModel>> getPartiFiles(
    String eviFileId, {
    OnProgressChanged? onProgress,
  }) async {
    try {
      final req = GetPartiFilesReq(eviFileId: eviFileId);
      final res = await client.getPartiFiles(req);

      if (!res.done) {
        throw Exception('Get partition files failed: ${res.err}');
      }

      if (res.err.isNotEmpty) {
        throw Exception('Server error: ${res.err}');
      }

      return _toEvidenceList(res.partitionFile);
    } catch (e) {
      logger.e('Error getting partition files: $e');
      rethrow;
    }
  }

  @override
  Future<List<EvidenceFileModel>> getIdxFiles(
    String partiFileId, {
    OnProgressChanged? onProgress,
  }) async {
    try {
      final req = GetIdxFilesReq(partiFileId: partiFileId);
      final res = await client.getIdxFiles(req);

      if (!res.done) {
        throw Exception('Get indexed files failed: ${res.err}');
      }

      if (res.err.isNotEmpty) {
        throw Exception('Server error: ${res.err}');
      }

      return _toEvidenceList(res.indexedFile);
    } catch (e) {
      logger.e('Error getting indexed files: $e');
      rethrow;
    }
  }
}
