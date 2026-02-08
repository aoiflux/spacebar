import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spacebar/core/common/entities/evidence.dart';
import 'package:spacebar/features/evi_store/domain/usecases/evi_store_case.dart';

part 'evi_event.dart';
part 'evi_state.dart';

class EviBloc extends Bloc<EviEvent, EviStoreState> {
  final EviStoreCase _eviStoreCase;

  Future<void> _eviStore(EviStore event, Emitter<EviStoreState> emit) async {
    emit(EviStoreLoading());
    final res = await _eviStoreCase(EvidenceStoreParams(event.eviPath));
    res.fold(
      (fail) => emit(EviStoreFailure(fail.message)),
      (evidence) => emit(EviStoreSuccess(evidence)),
    );
  }

  EviBloc(this._eviStoreCase) : super(EviStoreInitial()) {
    on<EviStore>(_eviStore);
  }
}
