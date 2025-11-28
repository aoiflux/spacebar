import 'dart:collection';
import 'package:spacebar/core/common/entities/evidence.dart';
import 'package:spacebar/generated/dues.pb.dart';

class EvidenceFileModel extends Evidence {
  EvidenceFileModel({
    required super.fileName,
    required super.filePath,
    required super.fileId,
    required super.totalSize,
    required super.sha256Hash,
    required super.compressedSize,
    required super.chunkMap,
  });

  factory EvidenceFileModel.fromProto(
    BaseFile baseFile, {
    String? filePath,
    String? fileId,
    String? sha256Hash,
    int? totalSize,
  }) {
    final chunkMap = HashMap<String, int>();
    baseFile.chunkMap.forEach((key, value) {
      chunkMap[key] = value.toInt();
    });

    final fileName = baseFile.filePath.split('/').last;
    final compressedSize = chunkMap.values.fold<int>(0, (sum, size) => sum + size);

    return EvidenceFileModel(
      fileName: fileName,
      filePath: filePath ?? baseFile.filePath,
      fileId: fileId ?? baseFile.fileId,
      totalSize: totalSize ?? compressedSize,
      sha256Hash: sha256Hash ?? '',
      compressedSize: compressedSize,
      chunkMap: chunkMap,
    );
  }
}
