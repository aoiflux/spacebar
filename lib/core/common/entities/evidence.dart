import 'dart:collection';

class Evidence {
  final String fileName;
  final int totalSize;
  final int compressedSize;
  final HashMap<String, int> chunkMap;

  Evidence({
    required this.fileName,
    required this.totalSize,
    required this.compressedSize,
    required this.chunkMap,
  });
}
