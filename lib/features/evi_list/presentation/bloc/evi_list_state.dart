part of 'evi_list_bloc.dart';

@immutable
sealed class EviListState {
  const EviListState();
}

final class EviListInitial extends EviListState {}

final class EviListLoading extends EviListState {
  final String msg;
  const EviListLoading(this.msg);
}

final class EviListLoaded extends EviListState {
  final List<Evidence> eviFiles;
  final Map<String, List<Evidence>> partiFilesByEvi;
  final Map<String, List<Evidence>> idxFilesByParti;
  final Set<String> partiLoadingIds;
  final Set<String> idxLoadingIds;
  final String? infoMessage;

  const EviListLoaded({
    required this.eviFiles,
    required this.partiFilesByEvi,
    required this.idxFilesByParti,
    required this.partiLoadingIds,
    required this.idxLoadingIds,
    this.infoMessage,
  });

  EviListLoaded copyWith({
    List<Evidence>? eviFiles,
    Map<String, List<Evidence>>? partiFilesByEvi,
    Map<String, List<Evidence>>? idxFilesByParti,
    Set<String>? partiLoadingIds,
    Set<String>? idxLoadingIds,
    String? infoMessage,
    bool clearInfoMessage = false,
  }) {
    return EviListLoaded(
      eviFiles: eviFiles ?? this.eviFiles,
      partiFilesByEvi: partiFilesByEvi ?? this.partiFilesByEvi,
      idxFilesByParti: idxFilesByParti ?? this.idxFilesByParti,
      partiLoadingIds: partiLoadingIds ?? this.partiLoadingIds,
      idxLoadingIds: idxLoadingIds ?? this.idxLoadingIds,
      infoMessage: clearInfoMessage ? null : (infoMessage ?? this.infoMessage),
    );
  }
}

final class EviListFailure extends EviListState {
  final String msg;
  const EviListFailure(this.msg);
}
