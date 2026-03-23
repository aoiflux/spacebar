import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spacebar/core/utils/show_snackbar.dart';
import 'package:spacebar/features/evi_list/presentation/bloc/evi_list_bloc.dart';
import 'package:spacebar/features/evi_list/presentation/widgets/evi_list_empty.dart';
import 'package:spacebar/features/evi_list/presentation/widgets/evi_list_evi_tile.dart';

class EviListPage extends StatelessWidget {
  const EviListPage({super.key});

  static const _tint = Color(0xFF2D7FF9);

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
              'Evidence List',
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
            onPressed: () => bloc.add(EviListLoad()),
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
