import 'package:flutter/material.dart';
import 'package:spacebar/features/showcase/presentation/widgets/showcase_card.dart';

class ScatterVisualWidget extends StatelessWidget {
  final String title;
  final String description;
  final Map<String, dynamic> mockData;
  final Color? tint;

  const ScatterVisualWidget({
    super.key,
    required this.title,
    required this.description,
    required this.mockData,
    this.tint,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final query = mockData['query'] as String? ?? 'query';
    final matches =
        (mockData['matches'] as List?)?.cast<Map<String, dynamic>>() ?? [];

    return ShowcaseCard(
      title: title,
      description: description,
      tint: tint,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            'Query: "$query"',
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 11,
              color: const Color(0xFF52637A),
            ),
          ),
          const SizedBox(height: 12),
          // Scatter plot simulation
          Expanded(
            child: CustomPaint(
              size: Size.infinite,
              painter: ScatterPlotPainter(
                matches: matches,
                color: tint ?? const Color(0xFF0B57D0),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Matches list
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: (tint ?? const Color(0xFF0B57D0)).withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: (tint ?? const Color(0xFF0B57D0)).withOpacity(0.1),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nearest matches:',
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF52637A),
                  ),
                ),
                const SizedBox(height: 6),
                ...List.generate(matches.length > 2 ? 2 : matches.length, (
                  index,
                ) {
                  final match = matches[index];
                  final caseId = match['case'] as String? ?? '';
                  final score = match['score'] as num? ?? 0;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: [
                        Text(
                          caseId,
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF0F1C2E),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${score.toStringAsFixed(0)}%',
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: tint ?? const Color(0xFF0B57D0),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ScatterPlotPainter extends CustomPainter {
  final List<Map<String, dynamic>> matches;
  final Color color;

  ScatterPlotPainter({required this.matches, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = color.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Draw background grid
    final gridPaint = Paint()
      ..color = Colors.grey.withOpacity(0.1)
      ..strokeWidth = 0.5;

    for (double i = 0; i <= size.width; i += size.width / 5) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), gridPaint);
    }
    for (double i = 0; i <= size.height; i += size.height / 5) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), gridPaint);
    }

    // Draw scattered points
    if (matches.isNotEmpty) {
      for (int i = 0; i < matches.length; i++) {
        final match = matches[i];
        final score = (match['score'] as num?)?.toDouble() ?? 50;
        final normalizedScore = (score - 50) / 50; // 0 to 1

        // Random-ish positioning based on index and score
        final x = (size.width * (i + 1) / (matches.length + 1));
        final y = size.height * (1 - normalizedScore / 2);

        // Draw halo
        canvas.drawCircle(Offset(x, y), 16, strokePaint);

        // Draw point
        canvas.drawCircle(Offset(x, y), 8, paint);
      }
    }
  }

  @override
  bool shouldRepaint(ScatterPlotPainter oldDelegate) =>
      oldDelegate.matches != matches || oldDelegate.color != color;
}
