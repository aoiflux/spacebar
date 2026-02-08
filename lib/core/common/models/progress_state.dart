enum ProgressStage {
  init,
  hashing,
  hashDone,
  appendCheck,
  streaming,
  streamDone,
}

class ProgressUpdate {
  final ProgressStage stage;
  final double? progress; // 0-1 for streaming progress
  final String? message;

  ProgressUpdate({required this.stage, this.progress, this.message});

  @override
  String toString() =>
      'ProgressUpdate(stage: $stage, progress: $progress, message: $message)';
}
