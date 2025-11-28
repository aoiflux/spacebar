import 'dart:collection';

class Evidence {
  final String fileName;
  final String filePath;
  final String fileId;
  final int totalSize;
  final String sha256Hash;
  final int compressedSize;
  final HashMap<String, int> chunkMap;

  Evidence({
    required this.fileName,
    required this.filePath,
    required this.fileId,
    required this.totalSize,
    required this.sha256Hash,
    required this.compressedSize,
    required this.chunkMap,
  });
}
