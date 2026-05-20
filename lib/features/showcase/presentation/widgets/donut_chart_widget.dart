import 'package:flutter/material.dart';
import 'package:spacebar/features/showcase/presentation/widgets/showcase_card.dart';

class DonutChartWidget extends StatelessWidget {
  final String title;
  final String description;
  final Map<String, dynamic> mockData;
  final Color? tint;

  const DonutChartWidget({
    super.key,
    required this.title,
    required this.description,
    required this.mockData,
    this.tint,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ratio = (mockData['ratio'] as num?)?.toDouble() ?? 40.0;
    final rawSize = mockData['rawSize'] as String? ?? 'N/A';
    final saved = mockData['saved'] as String? ?? 'N/A';

    return ShowcaseCard(
      title: title,
      description: description,
      tint: tint,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Donut chart
          Center(
            child: SizedBox(
              width: 120,
              height: 120,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Outer circle (saved)
                  CustomPaint(
                    size: const Size(120, 120),
                    painter: DonutPainter(
                      percentage: ratio / 100,
                      color: tint ?? const Color(0xFF0D7A5F),
                      backgroundColor: theme.dividerColor.withValues(alpha: 0.2),
                    ),
                  ),
                  // Center text
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${ratio.toStringAsFixed(0)}%',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: tint ?? const Color(0xFF0D7A5F),
                        ),
                      ),
                      Text(
                        'Saved',
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontSize: 10,
                          color: const Color(0xFF52637A),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _LegendItem(
                label: 'Raw Size',
                value: rawSize,
                color: theme.dividerColor.withValues(alpha: 0.4),
              ),
              _LegendItem(
                label: 'Saved',
                value: saved,
                color: tint ?? const Color(0xFF0D7A5F),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DonutPainter extends CustomPainter {
  final double percentage;
  final Color color;
  final Color backgroundColor;

  DonutPainter({
    required this.percentage,
    required this.color,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const strokeWidth = 12.0;

    // Background circle
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = backgroundColor
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke,
    );

    // Foreground arc (saved percentage)
    final rect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawArc(
      rect,
      -3.14159 / 2, // Start from top
      2 * 3.14159 * percentage, // Sweep angle
      false,
      Paint()
        ..color = color
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(DonutPainter oldDelegate) =>
      oldDelegate.percentage != percentage ||
      oldDelegate.color != color ||
      oldDelegate.backgroundColor != backgroundColor;
}

class _LegendItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _LegendItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 12,
              color: const Color(0xFF0F1C2E),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              fontSize: 10,
              color: const Color(0xFF52637A),
            ),
          ),
        ],
      ),
    );
  }
}

