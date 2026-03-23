part of 'evi_list_bloc.dart';

@immutable
sealed class EviListEvent {}

final class EviListLoad extends EviListEvent {}

final class EviPartiLoad extends EviListEvent {
  final String eviFileId;
  EviPartiLoad({required this.eviFileId});
}

final class EviIdxLoad extends EviListEvent {
  final String partiFileId;
  EviIdxLoad({required this.partiFileId});
}
