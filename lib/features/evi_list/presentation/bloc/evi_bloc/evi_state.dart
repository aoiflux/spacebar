part of 'evi_bloc.dart';

@immutable
sealed class EviState {}

final class EviInitial extends EviState {}

final class EviLoading extends EviState {}

final class EviHashingFile extends EviState {
  final String filePath;
  EviHashingFile(this.filePath);
}

final class EviCheckingExists extends EviState {
  final String filePath;
  final String sha256Hash;
  EviCheckingExists(this.filePath, this.sha256Hash);
}

final class EviUploading extends EviState {
  final String filePath;
  final int uploadedBytes;
  final int totalBytes;
  final int uploadedChunks;
  final int totalChunks;

  EviUploading(
    this.filePath,
    this.uploadedBytes,
    this.totalBytes,
    this.uploadedChunks,
    this.totalChunks,
  );

  double get progress => totalBytes > 0 ? uploadedBytes / totalBytes : 0.0;
}

final class EviStoreSuccess extends EviState {
  final Evidence evidence;
  EviStoreSuccess(this.evidence);
}

final class EviListSuccess extends EviState {
  final List<Evidence> evidenceList;
  EviListSuccess(this.evidenceList);
}

final class EviFailure extends EviState {
  final String msg;
  EviFailure(this.msg);
}
