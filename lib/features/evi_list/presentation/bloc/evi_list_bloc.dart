import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spacebar/core/common/entities/evidence.dart';
import 'package:spacebar/features/evi_list/domain/usecases/evi_get_evi_case.dart';
import 'package:spacebar/features/evi_list/domain/usecases/evi_get_idx_case.dart';
import 'package:spacebar/features/evi_list/domain/usecases/evi_get_parti_case.dart';

part 'evi_list_event.dart';
part 'evi_list_state.dart';

class EviListBloc extends Bloc<EviListEvent, EviListState> {
  final EviFilesCase _eviFilesCase;
  final PartiFilesCase _partiFilesCase;
  final IdxFilesCase _idxFilesCase;

  EviListBloc(this._eviFilesCase, this._partiFilesCase, this._idxFilesCase)
    : super(EviListInitial()) {
    on<EviListLoad>(_loadEviFiles);
    on<EviPartiLoad>(_loadPartiFiles);
    on<EviIdxLoad>(_loadIdxFiles);
  }

  Future<void> _loadEviFiles(
    EviListLoad event,
    Emitter<EviListState> emit,
  ) async {
    emit(EviListLoading('Loading evidence files...'));

    final result = await _eviFilesCase(EviFilesParams());
    result.fold(
      (failure) => emit(EviListFailure(failure.message)),
      (files) => emit(
        EviListLoaded(
          eviFiles: files,
          partiFilesByEvi: const {},
          idxFilesByParti: const {},
          partiLoadingIds: const {},
          idxLoadingIds: const {},
        ),
      ),
    );
  }

  Future<void> _loadPartiFiles(
    EviPartiLoad event,
    Emitter<EviListState> emit,
  ) async {
    final current = state;
    if (current is! EviListLoaded) {
      return;
    }

    if (current.partiFilesByEvi.containsKey(event.eviFileId) ||
        current.partiLoadingIds.contains(event.eviFileId)) {
      return;
    }

    final nextPartiLoadingIds = Set<String>.from(current.partiLoadingIds)
      ..add(event.eviFileId);
    emit(
      current.copyWith(
        partiLoadingIds: nextPartiLoadingIds,
        clearInfoMessage: true,
      ),
    );

    final result = await _partiFilesCase(PartiFilesParams(event.eviFileId));
    result.fold(
      (failure) {
        final restoredPartiLoadingIds = Set<String>.from(nextPartiLoadingIds)
          ..remove(event.eviFileId);
        emit(
          current.copyWith(
            partiLoadingIds: restoredPartiLoadingIds,
            infoMessage: failure.message,
          ),
        );
      },
      (files) {
        final nextPartiByEvi = Map<String, List<Evidence>>.from(
          current.partiFilesByEvi,
        )..[event.eviFileId] = files;

        final restoredPartiLoadingIds = Set<String>.from(nextPartiLoadingIds)
          ..remove(event.eviFileId);

        emit(
          current.copyWith(
            partiFilesByEvi: nextPartiByEvi,
            partiLoadingIds: restoredPartiLoadingIds,
            clearInfoMessage: true,
          ),
        );
      },
    );
  }

  Future<void> _loadIdxFiles(
    EviIdxLoad event,
    Emitter<EviListState> emit,
  ) async {
    final current = state;
    if (current is! EviListLoaded) {
      return;
    }

    if (current.idxFilesByParti.containsKey(event.partiFileId) ||
        current.idxLoadingIds.contains(event.partiFileId)) {
      return;
    }

    final nextIdxLoadingIds = Set<String>.from(current.idxLoadingIds)
      ..add(event.partiFileId);
    emit(
      current.copyWith(
        idxLoadingIds: nextIdxLoadingIds,
        clearInfoMessage: true,
      ),
    );

    final result = await _idxFilesCase(IdxFilesParams(event.partiFileId));
    result.fold(
      (failure) {
        final restoredIdxLoadingIds = Set<String>.from(nextIdxLoadingIds)
          ..remove(event.partiFileId);
        emit(
          current.copyWith(
            idxLoadingIds: restoredIdxLoadingIds,
            infoMessage: failure.message,
          ),
        );
      },
      (files) {
        final nextIdxByParti = Map<String, List<Evidence>>.from(
          current.idxFilesByParti,
        )..[event.partiFileId] = files;

        final restoredIdxLoadingIds = Set<String>.from(nextIdxLoadingIds)
          ..remove(event.partiFileId);

        emit(
          current.copyWith(
            idxFilesByParti: nextIdxByParti,
            idxLoadingIds: restoredIdxLoadingIds,
            clearInfoMessage: true,
          ),
        );
      },
    );
  }
}
