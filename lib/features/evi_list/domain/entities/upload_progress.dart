enum UploadStatus {
  hashing,
  checkingExists,
  uploading,
  completed,
}

class UploadProgress {
  final String filePath;
  final String sha256Hash;
  final int totalBytes;
  final int uploadedBytes;
  final int totalChunks;
  final int uploadedChunks;
  final UploadStatus status;

  UploadProgress({
    required this.filePath,
    this.sha256Hash = '',
    required this.totalBytes,
    this.uploadedBytes = 0,
    this.totalChunks = 0,
    this.uploadedChunks = 0,
    required this.status,
  });

  UploadProgress copyWith({
    String? filePath,
    String? sha256Hash,
    int? totalBytes,
    int? uploadedBytes,
    int? totalChunks,
    int? uploadedChunks,
    UploadStatus? status,
  }) {
    return UploadProgress(
      filePath: filePath ?? this.filePath,
      sha256Hash: sha256Hash ?? this.sha256Hash,
      totalBytes: totalBytes ?? this.totalBytes,
      uploadedBytes: uploadedBytes ?? this.uploadedBytes,
      totalChunks: totalChunks ?? this.totalChunks,
      uploadedChunks: uploadedChunks ?? this.uploadedChunks,
      status: status ?? this.status,
    );
  }
}
