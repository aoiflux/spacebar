import 'dart:collection';

class Evidence {
  final String fileName;
  final String filePath;
  final int totalSize;
  final String sha256Hash;
  final int compressedSize;
  final HashMap<String, int> chunkMap;
  final bool exists;
  final bool fullyUploaded;

  Evidence({
    required this.fileName,
    required this.filePath,
    required this.totalSize,
    required this.sha256Hash,
    required this.compressedSize,
    required this.chunkMap,
    this.exists = false,
    this.fullyUploaded = false,
  });
}
