import 'package:logger/logger.dart';
import 'package:spacebar/features/evi_list/data/models/stream_evidence_model.dart';
import 'package:spacebar/generated/dues.pbgrpc.dart';

abstract interface class IEviRemoteDataSource {
  Future<EvidenceFileModel> appendIfExists(String filePath);
  Future<EvidenceFileModel> streamFile(String fileType, String filePath);
}

class GrpcImpl implements IEviRemoteDataSource {
  final Logger logger;
  late final DuesServiceClient client;
  GrpcImpl(this.client, this.logger);

  String _fileHash = "";
  int _fileSize = 0;

  @override
  Future<EvidenceFileModel> appendIfExists(String filePath) {
    AppendIfExistsReq req = AppendIfExistsReq(
      filePath: filePath,
      fileHash: _fileHash,
    );
    client.appendIfExists(req);
    throw UnimplementedError();
  }

  @override
  Future<EvidenceFileModel> streamFile(String fileType, String filePath) {
    throw UnimplementedError();
  }
}
