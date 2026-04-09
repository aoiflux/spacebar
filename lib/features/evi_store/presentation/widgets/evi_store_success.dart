import 'dart:math';
import 'package:flutter/material.dart';
import 'package:spacebar/core/common/entities/evidence.dart';
import 'package:spacebar/core/utils/util.dart';
import 'package:spacebar/features/evi_list/presentation/pages/evi_list_page.dart';

class EviStoreSuccessView extends StatelessWidget {
  final Evidence evidence;

  const EviStoreSuccessView({super.key, required this.evidence});

  String _formatSignedBytes(int bytes) {
    if (bytes == 0) return '0 B';
    final prefix = bytes > 0 ? '+' : '-';
    return '$prefix${fmtBytes(bytes.abs())}';
  }

  double _getCompressionRatio() {
    if (evidence.totalSize == 0) return 0;
    return (1 - evidence.compressedSize / evidence.totalSize);
  }

  @override
  Widget build(BuildContext context) {
    final compressionRatio = _getCompressionRatio();
    final totalSize = evidence.totalSize;
    final compressedSize = evidence.compressedSize;
    final savedBytes = totalSize - compressedSize;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Success Icon with Badge
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                  size: 48,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '✓',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Success Message
          Text(
            'Evidence Stored Successfully',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            'Your file has been securely compressed and stored',
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // Main Content - Expanded to fit available space
          Expanded(
            child: ListView(
              children: [
                // Quick Stats Section
                _buildQuickStatsSection(context, savedBytes, compressionRatio),
                const SizedBox(height: 16),

                // Two Column Layout: Compression Gauge + File Details
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left Column: Compression Gauge
                    Expanded(
                      child: _buildCompressionGaugeCard(
                        context,
                        compressionRatio,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Right Column: File Details
                    Expanded(child: _buildDetailsCard(context)),
                  ],
                ),
                const SizedBox(height: 16),

                // Size Comparison Section
                _buildSizeComparisonSection(context),
                const SizedBox(height: 24),

                // Navigation Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const EviListPage()),
                      (route) => false,
                    ),
                    icon: const Icon(Icons.list_outlined),
                    label: const Text('View Evidence List'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStatsSection(
    BuildContext context,
    int savedBytes,
    double ratio,
  ) {
    final hasNegativeSavings = savedBytes < 0;

    return Row(
      children: [
        Expanded(
          child: _buildStatBox(
            context,
            icon: hasNegativeSavings
                ? Icons.warning_amber_rounded
                : Icons.trending_down,
            title: hasNegativeSavings ? 'Space Increased' : 'Space Saved',
            value: _formatSignedBytes(savedBytes),
            color: hasNegativeSavings ? Colors.red : Colors.green,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatBox(
            context,
            icon: Icons.flash_on,
            title: 'Efficiency',
            value: '${(ratio * 100).toStringAsFixed(0)}%',
            color: Colors.orange,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatBox(
            context,
            icon: Icons.layers_outlined,
            title: 'Chunks',
            value: evidence.chunkMap.length.toString(),
            color: Colors.blue,
          ),
        ),
      ],
    );
  }

  Widget _buildStatBox(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.15),
            color.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 6),
          Text(
            value,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCompressionGaugeCard(BuildContext context, double ratio) {
    final hasNegativeSavings = ratio < 0;
    final clampedSavedRatio = ratio.clamp(0.0, 1.0);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              Colors.blue.withValues(alpha: 0.05),
              Colors.blue.withValues(alpha: 0.02),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Compression',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Optimal',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
              LayoutBuilder(
                builder: (context, constraints) {
                  final gaugeSize = constraints.maxWidth * 0.2;

                  return SizedBox(
                    height: gaugeSize,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Visual Circular Gauge
                        SizedBox(
                          width: gaugeSize,
                          height: gaugeSize,
                          child: CustomPaint(
                            painter: _DualArcGaugePainter(
                              usedRatio: 1 - clampedSavedRatio,
                              savedRatio: clampedSavedRatio,
                              usedColor: Colors.grey,
                              savedColor: hasNegativeSavings
                                  ? Colors.red
                                  : Colors.green,
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.surfaceContainerHighest,
                            ),
                          ),
                        ),

                        // Center icon indicator
                        Icon(
                          hasNegativeSavings
                              ? Icons.warning_amber_rounded
                              : Icons.check_circle,
                          size: gaugeSize * 0.15,
                          color:
                              (hasNegativeSavings ? Colors.red : Colors.green)
                                  .withValues(alpha: 0.8),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              // Visual legend with icons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildGaugeLegend(
                    context,
                    color: Colors.grey,
                    icon: Icons.archive,
                    prefix: 'Used: ',
                    percentage: ((1 - ratio) * 100).toStringAsFixed(0),
                  ),
                  Container(
                    width: 1,
                    height: 30,
                    color: Colors.grey.withValues(alpha: 0.3),
                  ),
                  _buildGaugeLegend(
                    context,
                    color: hasNegativeSavings ? Colors.red : Colors.green,
                    icon: hasNegativeSavings
                        ? Icons.warning_amber_rounded
                        : Icons.savings,
                    prefix: hasNegativeSavings ? 'Overhead: ' : 'Saved: ',
                    percentage: (ratio.abs() * 100).toStringAsFixed(0),
                    isWarning: hasNegativeSavings,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGaugeLegend(
    BuildContext context, {
    required Color color,
    required IconData icon,
    required String prefix,
    required String percentage,
    bool isWarning = false,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
            ),
            Icon(icon, color: color, size: 24),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '$prefix${isWarning ? '+' : ''}$percentage%',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              Colors.purple.withValues(alpha: 0.05),
              Colors.purple.withValues(alpha: 0.02),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'File Details',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.purple.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${evidence.chunkMap.length} chunks',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colors.purple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // File Name
              _buildDetailRow(
                context,
                icon: Icons.insert_drive_file,
                label: 'File Name',
                value: evidence.fileName,
              ),

              const SizedBox(height: 12),

              // File ID
              _buildDetailRow(
                context,
                icon: Icons.fingerprint,
                label: 'File ID',
                value: evidence.fileId,
              ),

              const SizedBox(height: 16),

              Divider(color: Colors.grey.withValues(alpha: 0.2)),

              const SizedBox(height: 16),

              Text(
                'Size Breakdown',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),

              const SizedBox(height: 12),

              _buildSizeBreakdownRow(
                context,
                label: 'Original',
                value: fmtBytes(evidence.totalSize),
                color: Colors.grey,
              ),

              const SizedBox(height: 8),

              _buildSizeBreakdownRow(
                context,
                label: 'Compressed',
                value: fmtBytes(evidence.compressedSize),
                color: Colors.blue,
              ),

              const SizedBox(height: 8),

              _buildSizeBreakdownRow(
                context,
                label: evidence.totalSize >= evidence.compressedSize
                    ? 'Reduced By'
                    : 'Increased By',
                value: fmtBytes(
                  (evidence.totalSize - evidence.compressedSize).abs(),
                ),
                color: evidence.totalSize >= evidence.compressedSize
                    ? Colors.green
                    : Colors.red,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSizeComparisonSection(BuildContext context) {
    final totalSize = evidence.totalSize;
    final compressedSize = evidence.compressedSize;
    double ratio = 0;
    if (evidence.totalSize > 0) {
      ratio = compressedSize / totalSize;
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              Colors.orange.withValues(alpha: 0.05),
              Colors.orange.withValues(alpha: 0.02),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Storage Comparison',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${(ratio * 100).toStringAsFixed(0)}% used',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Original Size Bar
              _buildSizeBar(
                context,
                label: 'Original Size',
                percentage: 100,
                color: Colors.grey,
                value: fmtBytes(totalSize),
              ),
              const SizedBox(height: 12),
              // Compressed Size Bar
              _buildSizeBar(
                context,
                label: 'Compressed Size',
                percentage: (ratio * 100).toInt(),
                color: Colors.blue,
                value: fmtBytes(compressedSize),
              ),
              const SizedBox(height: 16),
              // Summary Row
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildSummaryMetric(
                      context,
                      label: 'Total Saved',
                      value: fmtBytes(totalSize - compressedSize),
                    ),
                    Container(
                      width: 1,
                      height: 30,
                      color: Colors.grey.withOpacity(0.3),
                    ),
                    _buildSummaryMetric(
                      context,
                      label: 'Ratio',
                      value: '${(ratio.toStringAsFixed(2))} : 1',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryMetric(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelSmall?.copyWith(color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildSizeBar(
    BuildContext context, {
    required String label,
    required int percentage,
    required Color color,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: Theme.of(context).textTheme.labelMedium),
            Text(
              '$percentage% • $value',
              style: Theme.of(
                context,
              ).textTheme.labelSmall?.copyWith(color: Colors.grey[600]),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percentage / 100,
            minHeight: 20,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
          ),
        ),
      ],
    );
  }

  Widget _buildSizeBreakdownRow(
    BuildContext context, {
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelSmall?.copyWith(color: Colors.grey[600]),
        ),
        const Spacer(),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.blueGrey, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Custom painter for dual-arc gauge
class _DualArcGaugePainter extends CustomPainter {
  final double usedRatio;
  final double savedRatio;
  final Color usedColor;
  final Color savedColor;
  final Color backgroundColor;

  _DualArcGaugePainter({
    required this.usedRatio,
    required this.savedRatio,
    required this.usedColor,
    required this.savedColor,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final strokeWidth = size.width * 0.12;

    // Background circle
    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius - strokeWidth / 2, bgPaint);

    // Used (compressed) arc
    final usedPaint = Paint()
      ..color = usedColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final usedSweepAngle = 2 * pi * usedRatio;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      -pi / 2, // Start from top
      usedSweepAngle,
      false,
      usedPaint,
    );

    // Saved arc
    final savedPaint = Paint()
      ..color = savedColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final savedSweepAngle = 2 * pi * savedRatio;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      -pi / 2 + usedSweepAngle, // Start after used arc
      savedSweepAngle,
      false,
      savedPaint,
    );

    // Add small dots at the start of each arc for visual appeal
    final dotRadius = strokeWidth * 0.15;

    // Dot at start (top)
    final startDotPaint = Paint()..color = usedColor;
    final startDotOffset = Offset(
      center.dx,
      center.dy - (radius - strokeWidth / 2),
    );
    canvas.drawCircle(startDotOffset, dotRadius, startDotPaint);

    // Dot at transition point
    final transitionAngle = -pi / 2 + usedSweepAngle;
    final transitionDotPaint = Paint()..color = savedColor;
    final transitionDotOffset = Offset(
      center.dx + (radius - strokeWidth / 2) * cos(transitionAngle),
      center.dy + (radius - strokeWidth / 2) * sin(transitionAngle),
    );
    canvas.drawCircle(transitionDotOffset, dotRadius, transitionDotPaint);
  }

  @override
  bool shouldRepaint(covariant _DualArcGaugePainter oldDelegate) {
    return oldDelegate.usedRatio != usedRatio ||
        oldDelegate.savedRatio != savedRatio;
  }
}
