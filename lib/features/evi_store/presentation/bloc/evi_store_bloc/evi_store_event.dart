part of 'evi_store_bloc.dart';

@immutable
sealed class EviStoreEvent {}

final class EviStore extends EviStoreEvent {
  final String eviPath;
  EviStore({required this.eviPath});
}

final class EviStoreProgressUpdate extends EviStoreEvent {
  final ProgressUpdate progress;
  EviStoreProgressUpdate(this.progress);
}
