import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spacebar/core/common/entities/evidence.dart';
import 'package:spacebar/features/evi_list/domain/usecases/evi_get_evi_case.dart';
import 'package:spacebar/features/evi_list/domain/usecases/evi_store_case.dart';

part 'evi_event.dart';
part 'evi_state.dart';

class EviBloc extends Bloc<EviEvent, EviState> {
  final EviStoreCase _eviStoreCase;
  final EviFilesCase _eviFilesCase;

  Future<void> _eviStore(EviStore event, Emitter<EviState> emit) async {
    emit(EviLoading());
    final res = await _eviStoreCase(EvidenceStoreParams(event.eviPath));
    res.fold(
      (fail) => emit(EviFailure(fail.message)),
      (evidence) => emit(EviSuccessStore(evidence)),
    );
  }

  Future<void> _eviList(EviList event, Emitter<EviState> emit) async {
    emit(EviLoading());
    final res = await _eviFilesCase(EviFilesParams());
    res.fold(
      (fail) => emit(EviFailure(fail.message)),
      (evidence) => emit(EviSuccessList(evidence)),
    );
  }

  EviBloc(this._eviFilesCase, this._eviStoreCase) : super(EviInitial()) {
    on<EviStore>(_eviStore);
    on<EviList>(_eviList);
  }
}
