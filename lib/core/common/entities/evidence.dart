import 'dart:collection';

class Evidence {
  final int totalSize;
  final int compressedSize;
  final List<FileHierarchy> flist;

  Evidence({
    required this.totalSize,
    required this.compressedSize,
    required this.flist,
  });
}

class FileHierarchy {
  final List<String> evis;
  final HashMap<String, List<String>> partitionMap;

  FileHierarchy({required this.evis, required this.partitionMap});
}
