import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spacebar/core/common/entities/evidence.dart';
import 'package:spacebar/core/common/models/picked_file_data.dart';
import 'package:spacebar/core/common/models/progress_state.dart';
import 'package:spacebar/features/evi_store/domain/usecases/evi_store_case.dart';

part 'evi_store_event.dart';
part 'evi_store_state.dart';

class EviBloc extends Bloc<EviStoreEvent, EviStoreState> {
  final EviStoreCase _eviStoreCase;

  Future<void> _eviStore(EviStore event, Emitter<EviStoreState> emit) async {
    emit(EviStoreLoading(ProgressUpdate(stage: ProgressStage.init)));
    try {
      final res = await _eviStoreCase(
        EvidenceStoreParams(
          event.eviData,
          onProgress: (progress) {
            add(EviStoreProgressUpdate(progress));
          },
        ),
      );

      // Wait for final progress update to be visible before transitioning to success
      // This ensures users see the "✓ Upload complete" stage
      await Future.delayed(Duration(milliseconds: 100));

      res.fold(
        (fail) => emit(EviStoreFailure(fail.message)),
        (evidence) => emit(EviStoreSuccess(evidence)),
      );
    } catch (e) {
      emit(EviStoreFailure('Unexpected error: $e'));
    }
  }

  void _progressUpdate(
    EviStoreProgressUpdate event,
    Emitter<EviStoreState> emit,
  ) {
    emit(EviStoreLoading(event.progress));
  }

  EviBloc(this._eviStoreCase) : super(EviStoreInitial()) {
    on<EviStore>(_eviStore);
    on<EviStoreProgressUpdate>(_progressUpdate);
  }
}
