import 'package:flutter/material.dart';
import 'package:spacebar/core/common/entities/evidence.dart';
import 'package:spacebar/core/utils/util.dart';

class DashboardPage extends StatelessWidget {
  final List<Evidence> eviFiles;
  final Map<String, List<Evidence>> partiFilesByEvi;
  final Map<String, List<Evidence>> idxFilesByParti;

  const DashboardPage({
    super.key,
    required this.eviFiles,
    required this.partiFilesByEvi,
    required this.idxFilesByParti,
  });

  @override
  Widget build(BuildContext context) {
    final stats = DashboardStats.fromData(
      eviFiles: eviFiles,
      partiFilesByEvi: partiFilesByEvi,
      idxFilesByParti: idxFilesByParti,
    );
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
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
                  colors: [Color(0xFF1B9AAA), Color(0xFF2D7FF9)],
                ),
              ),
              child: const Icon(
                Icons.dashboard_outlined,
                size: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Evidence Dashboard',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1C2430),
                letterSpacing: 0.1,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1180),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _HeroSummary(stats: stats),
                const SizedBox(height: 14),
                _MetricGrid(stats: stats),
                const SizedBox(height: 14),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final compact = constraints.maxWidth < 920;
                    if (compact) {
                      return Column(
                        children: [
                          _CoverageCard(stats: stats),
                          const SizedBox(height: 12),
                          _CompressionCard(stats: stats),
                        ],
                      );
                    }

                    return Row(
                      children: [
                        Expanded(child: _CoverageCard(stats: stats)),
                        const SizedBox(width: 12),
                        Expanded(child: _CompressionCard(stats: stats)),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 12),
                _TopFilesCard(stats: stats),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DashboardStats {
  final List<Evidence> allFiles;
  final int evidenceCount;
  final int partitionCount;
  final int idxCount;
  final int totalFiles;
  final int filesWithPartitions;
  final int partitionsWithIdx;
  final int totalChunks;
  final int totalOriginalBytes;
  final int totalCompressedBytes;
  final int totalSavedBytes;
  final int evidenceChunks;
  final int partitionChunks;
  final int idxChunks;
  final int evidenceOriginalBytes;
  final int partitionOriginalBytes;
  final int idxOriginalBytes;
  final double compressionRate;
  final double avgChunksPerFile;
  final int loadedPartitionRoots;
  final int loadedIdxRoots;
  final Evidence? largestFile;
  final Evidence? mostChunkedFile;

  const DashboardStats({
    required this.allFiles,
    required this.evidenceCount,
    required this.partitionCount,
    required this.idxCount,
    required this.totalFiles,
    required this.filesWithPartitions,
    required this.partitionsWithIdx,
    required this.totalChunks,
    required this.totalOriginalBytes,
    required this.totalCompressedBytes,
    required this.totalSavedBytes,
    required this.evidenceChunks,
    required this.partitionChunks,
    required this.idxChunks,
    required this.evidenceOriginalBytes,
    required this.partitionOriginalBytes,
    required this.idxOriginalBytes,
    required this.compressionRate,
    required this.avgChunksPerFile,
    required this.loadedPartitionRoots,
    required this.loadedIdxRoots,
    required this.largestFile,
    required this.mostChunkedFile,
  });

  int get filesWithoutPartitions => evidenceCount - filesWithPartitions;
  int get partitionsWithoutIdx => partitionCount - partitionsWithIdx;

  double get evidenceWithPartitionRate {
    if (evidenceCount == 0) return 0;
    return filesWithPartitions / evidenceCount;
  }

  double get partitionWithIdxRate {
    if (partitionCount == 0) return 0;
    return partitionsWithIdx / partitionCount;
  }

  static DashboardStats fromData({
    required List<Evidence> eviFiles,
    required Map<String, List<Evidence>> partiFilesByEvi,
    required Map<String, List<Evidence>> idxFilesByParti,
  }) {
    final partiFiles = partiFilesByEvi.values.expand((list) => list).toList();
    final idxFiles = idxFilesByParti.values.expand((list) => list).toList();
    final allFiles = <Evidence>[...eviFiles, ...partiFiles, ...idxFiles];

    final filesWithPartitions = eviFiles
        .where((evi) => (partiFilesByEvi[evi.fileId]?.isNotEmpty ?? false))
        .length;

    final partitionsWithIdx = partiFiles
        .where((parti) => (idxFilesByParti[parti.fileId]?.isNotEmpty ?? false))
        .length;

    final totalChunks = allFiles.fold<int>(
      0,
      (sum, file) => sum + file.chunkMap.length,
    );
    final evidenceChunks = eviFiles.fold<int>(
      0,
      (sum, file) => sum + file.chunkMap.length,
    );
    final partitionChunks = partiFiles.fold<int>(
      0,
      (sum, file) => sum + file.chunkMap.length,
    );
    final idxChunks = idxFiles.fold<int>(
      0,
      (sum, file) => sum + file.chunkMap.length,
    );

    final totalOriginalBytes = allFiles.fold<int>(
      0,
      (sum, file) => sum + file.totalSize,
    );
    final evidenceOriginalBytes = eviFiles.fold<int>(
      0,
      (sum, file) => sum + file.totalSize,
    );
    final partitionOriginalBytes = partiFiles.fold<int>(
      0,
      (sum, file) => sum + file.totalSize,
    );
    final idxOriginalBytes = idxFiles.fold<int>(
      0,
      (sum, file) => sum + file.totalSize,
    );
    final totalCompressedBytes = allFiles.fold<int>(
      0,
      (sum, file) => sum + file.compressedSize,
    );

    final rawRate = totalOriginalBytes == 0
        ? 0.0
        : 1 - (totalCompressedBytes / totalOriginalBytes);
    final compressionRate = rawRate.clamp(0.0, 1.0);

    Evidence? largestFile;
    Evidence? mostChunkedFile;
    for (final file in allFiles) {
      if (largestFile == null || file.totalSize > largestFile.totalSize) {
        largestFile = file;
      }
      if (mostChunkedFile == null ||
          file.chunkMap.length > mostChunkedFile.chunkMap.length) {
        mostChunkedFile = file;
      }
    }

    return DashboardStats(
      allFiles: allFiles,
      evidenceCount: eviFiles.length,
      partitionCount: partiFiles.length,
      idxCount: idxFiles.length,
      totalFiles: allFiles.length,
      filesWithPartitions: filesWithPartitions,
      partitionsWithIdx: partitionsWithIdx,
      totalChunks: totalChunks,
      totalOriginalBytes: totalOriginalBytes,
      totalCompressedBytes: totalCompressedBytes,
      totalSavedBytes: (totalOriginalBytes - totalCompressedBytes).clamp(
        0,
        totalOriginalBytes,
      ),
      evidenceChunks: evidenceChunks,
      partitionChunks: partitionChunks,
      idxChunks: idxChunks,
      evidenceOriginalBytes: evidenceOriginalBytes,
      partitionOriginalBytes: partitionOriginalBytes,
      idxOriginalBytes: idxOriginalBytes,
      compressionRate: compressionRate,
      avgChunksPerFile: allFiles.isEmpty ? 0 : totalChunks / allFiles.length,
      loadedPartitionRoots: partiFilesByEvi.length,
      loadedIdxRoots: idxFilesByParti.length,
      largestFile: largestFile,
      mostChunkedFile: mostChunkedFile,
    );
  }
}

class _HeroSummary extends StatelessWidget {
  final DashboardStats stats;

  const _HeroSummary({required this.stats});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final percent = (stats.compressionRate * 100).toStringAsFixed(1);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0F3557), Color(0xFF1B9AAA)],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x331B9AAA),
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Loaded Dataset Health',
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${stats.totalFiles} total files across evidence, partitions, and indexes',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: 16),
          _MiniChartsPanel(stats: stats),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 8,
            children: [
              _heroChip(Icons.folder_open, '${stats.totalFiles} files'),
              _heroChip(Icons.grid_view_rounded, '${stats.totalChunks} chunks'),
              _heroChip(Icons.savings_outlined, '$percent% compression gain'),
              _heroChip(
                Icons.compress_rounded,
                fmtBytes(stats.totalSavedBytes),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _heroChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withValues(alpha: 0.14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 14),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricGrid extends StatelessWidget {
  final DashboardStats stats;

  const _MetricGrid({required this.stats});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        _MetricCard(
          icon: Icons.inventory_2_outlined,
          label: 'Evidence Files',
          value: stats.evidenceCount.toString(),
          tint: const Color(0xFF2D7FF9),
        ),
        _MetricCard(
          icon: Icons.account_tree_outlined,
          label: 'Partition Files',
          value: stats.partitionCount.toString(),
          tint: const Color(0xFF0CA678),
        ),
        _MetricCard(
          icon: Icons.description_outlined,
          label: 'Indexed Files',
          value: stats.idxCount.toString(),
          tint: const Color(0xFF7048E8),
        ),
        _MetricCard(
          icon: Icons.grid_view_rounded,
          label: 'Total Chunks',
          value: stats.totalChunks.toString(),
          tint: const Color(0xFFB26A00),
        ),
        _MetricCard(
          icon: Icons.straighten_rounded,
          label: 'Original Size',
          value: fmtBytes(stats.totalOriginalBytes),
          tint: const Color(0xFF1B9AAA),
        ),
        _MetricCard(
          icon: Icons.compress_rounded,
          label: 'Compressed Size',
          value: fmtBytes(stats.totalCompressedBytes),
          tint: const Color(0xFF0E7490),
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color tint;

  const _MetricCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.tint,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 186,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: tint.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: tint.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: tint, size: 18),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1C2430),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: const Color(0xFF4A5566)),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniChartsPanel extends StatelessWidget {
  final DashboardStats stats;

  const _MiniChartsPanel({required this.stats});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Mini Charts',
      subtitle: 'Quick visual distribution of files, chunks, and storage.',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 920;

          if (compact) {
            return Column(
              children: [
                _StackedChartCard(
                  title: 'File Mix',
                  totalLabel: '${stats.totalFiles} total files',
                  items: [
                    _ChartItem(
                      label: 'Evidence',
                      value: stats.evidenceCount,
                      color: const Color(0xFF2D7FF9),
                    ),
                    _ChartItem(
                      label: 'Partition',
                      value: stats.partitionCount,
                      color: const Color(0xFF0CA678),
                    ),
                    _ChartItem(
                      label: 'Indexed',
                      value: stats.idxCount,
                      color: const Color(0xFF7048E8),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _StackedChartCard(
                  title: 'Chunk Mix',
                  totalLabel: '${stats.totalChunks} total chunks',
                  items: [
                    _ChartItem(
                      label: 'Evidence',
                      value: stats.evidenceChunks,
                      color: const Color(0xFF2D7FF9),
                    ),
                    _ChartItem(
                      label: 'Partition',
                      value: stats.partitionChunks,
                      color: const Color(0xFF0CA678),
                    ),
                    _ChartItem(
                      label: 'Indexed',
                      value: stats.idxChunks,
                      color: const Color(0xFF7048E8),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _StackedChartCard(
                  title: 'Storage Split',
                  totalLabel:
                      '${fmtBytes(stats.totalOriginalBytes)} original footprint',
                  items: [
                    _ChartItem(
                      label: 'Saved',
                      value: stats.totalSavedBytes,
                      color: const Color(0xFF1B9AAA),
                      valueLabel: fmtBytes(stats.totalSavedBytes),
                    ),
                    _ChartItem(
                      label: 'Stored',
                      value: stats.totalCompressedBytes,
                      color: const Color(0xFF0E7490),
                      valueLabel: fmtBytes(stats.totalCompressedBytes),
                    ),
                  ],
                ),
              ],
            );
          }

          return Row(
            children: [
              Expanded(
                child: _StackedChartCard(
                  title: 'File Mix',
                  totalLabel: '${stats.totalFiles} total files',
                  items: [
                    _ChartItem(
                      label: 'Evidence',
                      value: stats.evidenceCount,
                      color: const Color(0xFF2D7FF9),
                    ),
                    _ChartItem(
                      label: 'Partition',
                      value: stats.partitionCount,
                      color: const Color(0xFF0CA678),
                    ),
                    _ChartItem(
                      label: 'Indexed',
                      value: stats.idxCount,
                      color: const Color(0xFF7048E8),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StackedChartCard(
                  title: 'Chunk Mix',
                  totalLabel: '${stats.totalChunks} total chunks',
                  items: [
                    _ChartItem(
                      label: 'Evidence',
                      value: stats.evidenceChunks,
                      color: const Color(0xFF2D7FF9),
                    ),
                    _ChartItem(
                      label: 'Partition',
                      value: stats.partitionChunks,
                      color: const Color(0xFF0CA678),
                    ),
                    _ChartItem(
                      label: 'Indexed',
                      value: stats.idxChunks,
                      color: const Color(0xFF7048E8),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StackedChartCard(
                  title: 'Storage Split',
                  totalLabel:
                      '${fmtBytes(stats.totalOriginalBytes)} original footprint',
                  items: [
                    _ChartItem(
                      label: 'Saved',
                      value: stats.totalSavedBytes,
                      color: const Color(0xFF1B9AAA),
                      valueLabel: fmtBytes(stats.totalSavedBytes),
                    ),
                    _ChartItem(
                      label: 'Stored',
                      value: stats.totalCompressedBytes,
                      color: const Color(0xFF0E7490),
                      valueLabel: fmtBytes(stats.totalCompressedBytes),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _StackedChartCard extends StatelessWidget {
  final String title;
  final String totalLabel;
  final List<_ChartItem> items;

  const _StackedChartCard({
    required this.title,
    required this.totalLabel,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final total = items.fold<int>(0, (sum, item) => sum + item.value);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FBFF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFDDE6F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: const Color(0xFF253042),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            totalLabel,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: const Color(0xFF5D6A7E)),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: SizedBox(
              height: 10,
              child: Row(
                children: [
                  for (final item in items)
                    Expanded(
                      flex: total <= 0 ? 0 : item.value,
                      child: Container(color: item.color),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          for (final item in items)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: item.color,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Text(
                      item.label,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF3D4A5E),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    item.valueLabel ?? item.value.toString(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF3D4A5E),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    total <= 0
                        ? '0%'
                        : '${((item.value / total) * 100).toStringAsFixed(0)}%',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: const Color(0xFF6B7687),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _ChartItem {
  final String label;
  final int value;
  final Color color;
  final String? valueLabel;

  const _ChartItem({
    required this.label,
    required this.value,
    required this.color,
    this.valueLabel,
  });
}

class _CoverageCard extends StatelessWidget {
  final DashboardStats stats;

  const _CoverageCard({required this.stats});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Hierarchy Coverage',
      subtitle:
          'How much of the evidence tree has loaded children in this session.',
      child: Column(
        children: [
          _ProgressRow(
            label: 'Evidence files with partitions',
            details:
                '${stats.filesWithPartitions}/${stats.evidenceCount} files',
            progress: stats.evidenceWithPartitionRate,
            tint: const Color(0xFF0CA678),
          ),
          const SizedBox(height: 10),
          _ProgressRow(
            label: 'Partitions with Indexed children',
            details:
                '${stats.partitionsWithIdx}/${stats.partitionCount} partitions',
            progress: stats.partitionWithIdxRate,
            tint: const Color(0xFF7048E8),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _metaChip(
                Icons.visibility_outlined,
                '${stats.loadedPartitionRoots} evidence roots expanded',
              ),
              _metaChip(
                Icons.hub_outlined,
                '${stats.loadedIdxRoots} partition roots expanded',
              ),
              _metaChip(
                Icons.warning_amber_rounded,
                '${stats.filesWithoutPartitions} evidence files missing partitions',
              ),
              _metaChip(
                Icons.warning_amber_rounded,
                '${stats.partitionsWithoutIdx} partitions missing idx files',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _metaChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: const Color(0xFFEEF3FA),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: const Color(0xFF445066)),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF445066),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _CompressionCard extends StatelessWidget {
  final DashboardStats stats;

  const _CompressionCard({required this.stats});

  @override
  Widget build(BuildContext context) {
    final compressionPct = (stats.compressionRate * 100).toStringAsFixed(1);

    return _SectionCard(
      title: 'Storage Efficiency',
      subtitle: 'Compression and chunk profile across all loaded objects.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$compressionPct% overall compression gain',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: const Color(0xFF1C2430),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          _ProgressRow(
            label: 'Saved bytes',
            details:
                '${fmtBytes(stats.totalSavedBytes)} saved from ${fmtBytes(stats.totalOriginalBytes)}',
            progress: stats.compressionRate,
            tint: const Color(0xFF1B9AAA),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _metaValue(
                'Avg chunks / file',
                stats.avgChunksPerFile.toStringAsFixed(1),
              ),
              _metaValue(
                'Compressed footprint',
                fmtBytes(stats.totalCompressedBytes),
              ),
              _metaValue('Total files', stats.totalFiles.toString()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _metaValue(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD5DEEA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: Color(0xFF1C2430),
              fontSize: 13,
            ),
          ),
          Text(
            label,
            style: const TextStyle(color: Color(0xFF5A6578), fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _ProgressRow extends StatelessWidget {
  final String label;
  final String details;
  final double progress;
  final Color tint;

  const _ProgressRow({
    required this.label,
    required this.details,
    required this.progress,
    required this.tint,
  });

  @override
  Widget build(BuildContext context) {
    final clamped = progress.clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF253042),
                ),
              ),
            ),
            Text(
              details,
              style: Theme.of(
                context,
              ).textTheme.labelMedium?.copyWith(color: const Color(0xFF586579)),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(99),
          child: LinearProgressIndicator(
            value: clamped,
            minHeight: 8,
            backgroundColor: tint.withValues(alpha: 0.14),
            color: tint,
          ),
        ),
      ],
    );
  }
}

class _TopFilesCard extends StatelessWidget {
  final DashboardStats stats;

  const _TopFilesCard({required this.stats});

  @override
  Widget build(BuildContext context) {
    final bySize = [...stats.allFiles]
      ..sort((a, b) => b.totalSize.compareTo(a.totalSize));
    final top = bySize.take(5).toList();

    return _SectionCard(
      title: 'Top Files',
      subtitle: 'Largest loaded files and chunk-heavy candidates.',
      child: Column(
        children: [
          if (top.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text('No data loaded yet.'),
            )
          else
            ...top.map((file) => _TopFileTile(file: file)),
          const SizedBox(height: 6),
          if (stats.mostChunkedFile != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F8FF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFD9E6FA)),
              ),
              child: Text(
                'Most chunked file: ${stats.mostChunkedFile!.fileName} '
                '(${stats.mostChunkedFile!.chunkMap.length} chunks)',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF294161),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _TopFileTile extends StatelessWidget {
  final Evidence file;

  const _TopFileTile({required this.file});

  @override
  Widget build(BuildContext context) {
    final ratio = file.totalSize <= 0
        ? 0.0
        : (1 - (file.compressedSize / file.totalSize)).clamp(0.0, 1.0);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E7F1)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.insert_drive_file_outlined,
            color: Color(0xFF445066),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  file.fileName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF1C2430),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  file.fileId,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: const Color(0xFF5D6A7E),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            fmtBytes(file.totalSize),
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: const Color(0xFF253042),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFEDF5FF),
              borderRadius: BorderRadius.circular(99),
            ),
            child: Text(
              '${(ratio * 100).toStringAsFixed(0)}% saved',
              style: const TextStyle(
                color: Color(0xFF2D7FF9),
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFDDE6F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: const Color(0xFF1C2430),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            subtitle,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: const Color(0xFF5D6A7E)),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
