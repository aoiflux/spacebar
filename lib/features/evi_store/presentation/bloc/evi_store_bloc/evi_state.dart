part of 'evi_bloc.dart';

@immutable
sealed class EviStoreState {
  const EviStoreState();
}

final class EviStoreInitial extends EviStoreState {}

final class EviStoreLoading extends EviStoreState {}

final class EviStoreSuccess extends EviStoreState {
  final Evidence evidence;
  const EviStoreSuccess(this.evidence);
}

final class EviStoreFailure extends EviStoreState {
  final String msg;
  const EviStoreFailure(this.msg);
}
