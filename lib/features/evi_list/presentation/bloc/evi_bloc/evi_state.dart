part of 'evi_bloc.dart';

@immutable
sealed class EviState {
  const EviState();
}

final class EviInitial extends EviState {}

final class EviLoading extends EviState {}

final class EviSuccessStore extends EviState {
  final Evidence evidence;
  const EviSuccessStore(this.evidence);
}

final class EviSuccessList extends EviState {
  final List<Evidence> evidenceList;
  const EviSuccessList(this.evidenceList);
}

final class EviFailure extends EviState {
  final String msg;
  const EviFailure(this.msg);
}
