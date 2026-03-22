import 'package:spacebar/core/common/entities/evidence.dart';

class EvidenceFileModel extends Evidence {
  EvidenceFileModel({
    required super.fileName,
    required super.fileId,
    required super.totalSize,
    required super.compressedSize,
    required super.chunkMap,
  });
}
