import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spacebar/core/common/entities/evidence.dart';
import 'package:spacebar/core/utils/show_snackbar.dart';
import 'package:spacebar/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:spacebar/features/evi_list/presentation/bloc/evi_list_bloc.dart';
import 'package:spacebar/features/evi_list/presentation/widgets/evi_list_empty.dart';
import 'package:spacebar/features/evi_list/presentation/widgets/evi_list_evi_tile.dart';

class EviListPage extends StatefulWidget {
  const EviListPage({super.key});

  @override
  State<EviListPage> createState() => _EviListPageState();
}

class _EviListPageState extends State<EviListPage> {
  static const _tint = Color(0xFF2D7FF9);

  final Set<String> _selectedEviIds = <String>{};
  bool _selectionMode = false;

  void _goHome(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void _toggleSelectionMode(EviListState state) {
    if (state is! EviListLoaded || state.eviFiles.isEmpty) {
      showSnackBar(context, 'Load evidence first to enable file selection.');
      return;
    }

    setState(() {
      _selectionMode = !_selectionMode;
      if (!_selectionMode) {
        _selectedEviIds.clear();
      }
    });
  }

  void _selectAll(List<String> fileIds) {
    setState(() {
      _selectedEviIds
        ..clear()
        ..addAll(fileIds);
    });
  }

  void _toggleFileSelection(String fileId) {
    setState(() {
      if (_selectedEviIds.contains(fileId)) {
        _selectedEviIds.remove(fileId);
      } else {
        _selectedEviIds.add(fileId);
      }
    });
  }

  void _openDashboard(EviListState state) {
    if (state is! EviListLoaded) {
      showSnackBar(context, 'Load evidence first to view dashboard stats.');
      return;
    }

    final selectedIds = _selectedEviIds;
    if (_selectionMode && selectedIds.isEmpty) {
      showSnackBar(context, 'Select at least one evidence file for dashboard.');
      return;
    }

    final useSelection = _selectionMode && selectedIds.isNotEmpty;
    final eviFiles = useSelection
        ? state.eviFiles
              .where((evi) => selectedIds.contains(evi.fileId))
              .toList()
        : state.eviFiles;

    final partiFilesByEvi = <String, List<Evidence>>{};
    for (final evi in eviFiles) {
      final parti = state.partiFilesByEvi[evi.fileId];
      if (parti != null) {
        partiFilesByEvi[evi.fileId] = parti;
      }
    }

    final selectedPartiIds = partiFilesByEvi.values
        .expand((files) => files)
        .map((file) => file.fileId)
        .toSet();

    final idxFilesByParti = <String, List<Evidence>>{};
    for (final entry in state.idxFilesByParti.entries) {
      if (selectedPartiIds.contains(entry.key)) {
        idxFilesByParti[entry.key] = entry.value;
      }
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => DashboardPage(
          eviFiles: eviFiles,
          partiFilesByEvi: partiFilesByEvi,
          idxFilesByParti: idxFilesByParti,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<EviListBloc>();
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white.withValues(alpha: 0.85),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 20,
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9),
                gradient: const LinearGradient(
                  colors: [Color(0xFF2D7FF9), Color(0xFF1EA7FD)],
                ),
              ),
              child: const Icon(
                Icons.dataset_outlined,
                size: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              _selectionMode
                  ? 'Evidence List (${_selectedEviIds.length} selected)'
                  : 'Evidence List',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1C2430),
                letterSpacing: 0.1,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => _openDashboard(bloc.state),
            icon: const Icon(Icons.dashboard_outlined, color: _tint),
            tooltip: 'Dashboard',
          ),
          if (_selectionMode)
            IconButton(
              onPressed: () {
                final state = bloc.state;
                if (state is! EviListLoaded) return;
                _selectAll(state.eviFiles.map((evi) => evi.fileId).toList());
              },
              icon: const Icon(Icons.select_all_rounded, color: _tint),
              tooltip: 'Select all',
            ),
          IconButton(
            onPressed: () => _toggleSelectionMode(bloc.state),
            icon: Icon(
              _selectionMode ? Icons.close_rounded : Icons.checklist_rounded,
              color: _tint,
            ),
            tooltip: _selectionMode ? 'Exit selection mode' : 'Select files',
          ),
          IconButton(
            onPressed: () => _goHome(context),
            icon: const Icon(Icons.home_outlined, color: _tint),
            tooltip: 'Home',
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _selectedEviIds.clear();
                _selectionMode = false;
              });
              bloc.add(EviListLoad());
            },
            icon: const Icon(Icons.refresh_rounded, color: _tint),
            tooltip: 'Refresh',
          ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: _tint.withValues(alpha: 0.08)),
        ),
      ),
      body: BlocConsumer<EviListBloc, EviListState>(
        listener: (context, state) {
          if (state is EviListFailure) showSnackBar(context, state.msg);
          if (state is EviListLoaded && state.infoMessage != null) {
            showSnackBar(context, state.infoMessage!);
          }
        },
        builder: (context, state) {
          if (state is EviListInitial) {
            bloc.add(EviListLoad());
            return const Center(child: CircularProgressIndicator(color: _tint));
          }

          if (state is EviListLoading) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(color: _tint),
                  const SizedBox(height: 14),
                  Text(
                    state.msg,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF364254).withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is EviListFailure) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.08),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.error_outline_rounded,
                        size: 36,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Something went wrong',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1C2430),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      state.msg,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF364254).withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(height: 20),
                    FilledButton.tonal(
                      onPressed: () => bloc.add(EviListLoad()),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.red.withValues(alpha: 0.1),
                        foregroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: Colors.red.withValues(alpha: 0.25),
                          ),
                        ),
                      ),
                      child: const Text('Try again'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is EviListLoaded) {
            _selectedEviIds.retainWhere(
              (id) => state.eviFiles.any((evi) => evi.fileId == id),
            );

            if (state.eviFiles.isEmpty) {
              return EviListEmpty(onRefresh: () => bloc.add(EviListLoad()));
            }

            return ListView.builder(
              padding: const EdgeInsets.only(top: 10, bottom: 24),
              itemCount: state.eviFiles.length,
              itemBuilder: (context, index) {
                final evi = state.eviFiles[index];
                return EviListEviTile(
                  key: PageStorageKey('evi-${evi.fileId}'),
                  evi: evi,
                  partiFiles: state.partiFilesByEvi[evi.fileId],
                  partiLoading: state.partiLoadingIds.contains(evi.fileId),
                  idxFilesByParti: state.idxFilesByParti,
                  idxLoadingIds: state.idxLoadingIds,
                  selectionMode: _selectionMode,
                  selected: _selectedEviIds.contains(evi.fileId),
                  onSelectionToggle: () => _toggleFileSelection(evi.fileId),
                  onExpand: () => bloc.add(EviPartiLoad(eviFileId: evi.fileId)),
                  onPartiExpand: (partiId) =>
                      bloc.add(EviIdxLoad(partiFileId: partiId)),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
