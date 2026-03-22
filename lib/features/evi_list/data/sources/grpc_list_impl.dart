import 'package:logger/logger.dart';
import 'package:spacebar/core/common/models/evidence_file_model.dart';
import 'package:spacebar/features/evi_list/domain/repo/ievlistirepo.dart';
import 'package:spacebar/generated/dues.pbgrpc.dart';

abstract interface class IEviListRemoteDataSource {
  Future<EvidenceFileModel?> getEviFiles({OnProgressChanged? onProgress});
  Future<EvidenceFileModel?> getPartiFiles(
    String eviFileId, {
    OnProgressChanged? onProgress,
  });
  Future<EvidenceFileModel?> getIdxFiles(
    String partiFileId, {
    OnProgressChanged? onProgress,
  });
}

class GrpcListImpl implements IEviListRemoteDataSource {
  final Logger logger;
  late final DuesServiceClient client;
  GrpcListImpl(this.logger, this.client);

  @override
  Future<EvidenceFileModel?> getEviFiles({OnProgressChanged? onProgress}) {
    // TODO: implement getEviFiles
    throw UnimplementedError();
  }

  @override
  Future<EvidenceFileModel?> getPartiFiles(
    String eviFileId, {
    OnProgressChanged? onProgress,
  }) {
    // TODO: implement getPartiFiles
    throw UnimplementedError();
  }

  @override
  Future<EvidenceFileModel?> getIdxFiles(
    String partiFileId, {
    OnProgressChanged? onProgress,
  }) {
    // TODO: implement getIdxFiles
    throw UnimplementedError();
  }
}
