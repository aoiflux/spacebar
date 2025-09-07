part of 'evi_bloc.dart';

@immutable
sealed class EviEvent {}

final class EviStore extends EviEvent {
  final String eviPath;
  EviStore({required this.eviPath});
}

final class EviList extends EviEvent {}
