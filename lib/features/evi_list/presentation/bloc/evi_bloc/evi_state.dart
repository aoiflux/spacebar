part of 'evi_bloc.dart';

@immutable
sealed class EviState {
  const EviState();
}

final class EviInitial extends EviState {}

final class EviLoading extends EviState {}

final class EviSuccess extends EviState {
  final Evidence evidence;
  const EviSuccess(this.evidence);
}

final class EviFailure extends EviState {
  final String msg;
  const EviFailure(this.msg);
}
