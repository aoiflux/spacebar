import 'dart:collection';

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

    HashMap<String, int> chunkMap = HashMap.from(res.eviFile.chunkMap);
    EvidenceFileModel model = EvidenceFileModel(
      fileName: filePath,
      totalSize: _fileSize,
      chunkMap: chunkMap,
      compressedSize: 0,
    );
    return model;
  }

  @override
  Future<EvidenceFileModel> streamFile(String fileType, String filePath) {
    throw UnimplementedError();
  }
}
