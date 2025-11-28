import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spacebar/core/common/entities/evidence.dart';
import 'package:spacebar/features/evi_list/domain/entities/upload_progress.dart';
import 'package:spacebar/features/evi_list/domain/usecases/evi_get_evi_case.dart';
import 'package:spacebar/features/evi_list/domain/usecases/evi_store_case.dart';

part 'evi_event.dart';
part 'evi_state.dart';

class EviBloc extends Bloc<EviEvent, EviState> {
  final EviStoreCase _eviStoreCase;
  final EviFilesCase _eviFilesCase;

  EviBloc(this._eviFilesCase, this._eviStoreCase) : super(EviInitial()) {
    on<EviStore>(_eviStore);
    on<EviList>(_eviList);
  }

  Future<void> _eviStore(EviStore event, Emitter<EviState> emit) async {
    emit(EviHashingFile(event.eviPath));

    final res = await _eviStoreCase(
      EvidenceStoreParams(event.eviPath),
      onProgress: (progress, status) {
        if (status == UploadStatus.hashing) {
          emit(EviHashingFile(event.eviPath));
        } else if (status == UploadStatus.checkingExists) {
          emit(EviCheckingExists(event.eviPath, progress.sha256Hash));
        } else if (status == UploadStatus.uploading) {
          emit(EviUploading(
            event.eviPath,
            progress.uploadedBytes,
            progress.totalBytes,
            progress.uploadedChunks,
            progress.totalChunks,
          ));
        }
      },
    );

    res.fold(
      (fail) => emit(EviFailure(fail.message)),
      (evidence) => emit(EviStoreSuccess(evidence)),
    );
  }

  Future<void> _eviList(EviList event, Emitter<EviState> emit) async {
    emit(EviLoading());
    final res = await _eviFilesCase(EviFilesParams());
    res.fold(
      (fail) => emit(EviFailure(fail.message)),
      (evidenceList) => emit(EviListSuccess(evidenceList)),
    );
  }
}
