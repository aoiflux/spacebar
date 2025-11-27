import 'dart:collection';

class Evidence {
  final String fileName;
<<<<<<< Updated upstream
  final String filePath;
=======
  final String fileId;
>>>>>>> Stashed changes
  final int totalSize;
  final String sha256Hash;
  final int compressedSize;
  final HashMap<String, int> chunkMap;
  final bool exists;
  final bool fullyUploaded;

  Evidence({
    required this.fileName,
<<<<<<< Updated upstream
    required this.filePath,
=======
    required this.fileId,
>>>>>>> Stashed changes
    required this.totalSize,
    required this.sha256Hash,
    required this.compressedSize,
    required this.chunkMap,
    this.exists = false,
    this.fullyUploaded = false,
  });
}
