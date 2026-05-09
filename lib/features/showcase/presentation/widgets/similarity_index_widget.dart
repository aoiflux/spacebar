import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:spacebar/features/showcase/presentation/widgets/showcase_card.dart';

class _MethodSignal {
  const _MethodSignal({
    required this.id,
    required this.label,
    required this.weight,
    required this.color,
  });

  final String id;
  final String label;
  final int weight;
  final Color color;
}

class _FileBubble {
  const _FileBubble({
    required this.file,
    required this.score,
    required this.matchedBy,
    required this.repackagedLikelihood,
  });

  final String file;
  final int score;
  final List<String> matchedBy;
  final int repackagedLikelihood;
}

const _defaultMethods = <_MethodSignal>[
  _MethodSignal(
    id: 'exact_hash',
    label: 'Exact hash',
    weight: 100,
    color: Color(0xFFDC2626),
  ),
  _MethodSignal(
    id: 'chunk_exact',
    label: 'Chunk match',
    weight: 88,
    color: Color(0xFFEA580C),
  ),
  _MethodSignal(
    id: 'chunk_partial_simhash',
    label: 'Partial simhash',
    weight: 72,
    color: Color(0xFFD97706),
  ),
  _MethodSignal(
    id: 'topk_full_simhash',
    label: 'Top-K simhash',
    weight: 78,
    color: Color(0xFF7C3AED),
  ),
  _MethodSignal(
    id: 'vector_match',
    label: 'Vector embedding',
    weight: 69,
    color: Color(0xFF0EA5E9),
  ),
];

const _defaultRelated = <_FileBubble>[
  _FileBubble(
    file: 'payload_updater_v4.bin',
    score: 96,
    matchedBy: ['exact_hash', 'chunk_exact', 'topk_full_simhash'],
    repackagedLikelihood: 98,
  ),
  _FileBubble(
    file: 'invoice_reader_patch.exe',
    score: 87,
    matchedBy: ['chunk_exact', 'chunk_partial_simhash', 'vector_match'],
    repackagedLikelihood: 91,
  ),
  _FileBubble(
    file: 'svc_update_signed.dat',
    score: 81,
    matchedBy: ['chunk_partial_simhash', 'topk_full_simhash', 'vector_match'],
    repackagedLikelihood: 86,
  ),
  _FileBubble(
    file: 'archive_patch_2026.bin',
    score: 74,
    matchedBy: ['topk_full_simhash', 'vector_match'],
    repackagedLikelihood: 62,
  ),
];

class SimilarityIndexWidget extends StatefulWidget {
  final String title;
  final String description;
  final Map<String, dynamic> mockData;
  final Color? tint;

  const SimilarityIndexWidget({
    super.key,
    required this.title,
    required this.description,
    required this.mockData,
    this.tint,
  });

  @override
  State<SimilarityIndexWidget> createState() => _SimilarityIndexWidgetState();
}

class _SimilarityIndexWidgetState extends State<SimilarityIndexWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int? _hoveredBubble;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tint = widget.tint ?? const Color(0xFFEF4444);
    final isDark = theme.brightness == Brightness.dark;

    final methodsRaw =
        (widget.mockData['methods'] as List?)?.cast<Map<String, dynamic>>() ??
        const [];
    final methods = methodsRaw.isEmpty
        ? _defaultMethods
        : methodsRaw
              .map((m) {
                final colorHex = m['color'] as int?;
                return _MethodSignal(
                  id: m['id'] as String? ?? 'method',
                  label:
                      m['label'] as String? ?? m['id'] as String? ?? 'method',
                  weight: (m['weight'] as num? ?? 50).toInt().clamp(0, 100),
                  color: colorHex != null ? Color(colorHex) : tint,
                );
              })
              .toList(growable: false);

    final relatedRaw =
        (widget.mockData['relatedFiles'] as List?)
            ?.cast<Map<String, dynamic>>() ??
        const [];
    final related =
        relatedRaw.isEmpty
              ? _defaultRelated
              : relatedRaw
                    .map((r) {
                      return _FileBubble(
                        file: r['file'] as String? ?? 'unknown.bin',
                        score: (r['score'] as num? ?? 0).toInt().clamp(0, 100),
                        matchedBy:
                            (r['matchedBy'] as List?)?.cast<String>() ??
                            const <String>[],
                        repackagedLikelihood:
                            (r['repackagedLikelihood'] as num? ?? 0)
                                .toInt()
                                .clamp(0, 100),
                      );
                    })
                    .toList(growable: false)
          ..sort((a, b) => b.score.compareTo(a.score));

    final strongCount = related.where((f) => f.score >= 85).length;
    final avgScore = related.isEmpty
        ? 0
        : (related.fold<int>(0, (s, f) => s + f.score) / related.length)
              .round();

    return ShowcaseCard(
      title: widget.title,
      description: widget.description,
      tint: tint,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SummaryBanner(
            relatedCount: related.length,
            strongCount: strongCount,
            avgScore: avgScore,
            tint: tint,
            isDark: isDark,
          ),
          const SizedBox(height: 10),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  children: [
                    // Bubble visualization with file labels
                    Expanded(
                      flex: 2,
                      child: AnimatedBuilder(
                        animation: _controller,
                        builder: (context, _) {
                          return MouseRegion(
                            onExit: (_) =>
                                setState(() => _hoveredBubble = null),
                            child: CustomPaint(
                              painter: _BubbleOverlapPainter(
                                bubbles: related,
                                methods: methods,
                                animation: _controller.value,
                                hoveredIndex: _hoveredBubble,
                                isDark: isDark,
                                tint: tint,
                              ),
                              size: Size.infinite,
                              child: Stack(
                                children: [
                                  for (int i = 0; i < related.length; i++)
                                    MouseRegion(
                                      onEnter: (_) =>
                                          setState(() => _hoveredBubble = i),
                                      onExit: (_) =>
                                          setState(() => _hoveredBubble = null),
                                      child: Positioned.fill(
                                        child: Container(),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    // File details table
                    Expanded(
                      flex: 1,
                      child: SingleChildScrollView(
                        child: _FileDetailsTable(
                          files: related,
                          methods: methods,
                          hoveredIndex: _hoveredBubble,
                          isDark: isDark,
                          onHoverFile: (index) =>
                              setState(() => _hoveredBubble = index),
                          onUnhoverFile: () =>
                              setState(() => _hoveredBubble = null),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryBanner extends StatelessWidget {
  const _SummaryBanner({
    required this.relatedCount,
    required this.strongCount,
    required this.avgScore,
    required this.tint,
    required this.isDark,
  });

  final int relatedCount;
  final int strongCount;
  final int avgScore;
  final Color tint;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: tint.withOpacity(isDark ? 0.13 : 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: tint.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: tint, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$relatedCount related files',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: isDark
                        ? const Color(0xFFE2E8F0)
                        : const Color(0xFF1E293B),
                  ),
                ),
                Text(
                  '$strongCount strong · avg $avgScore%',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? const Color(0xFFA1A7B5)
                        : const Color(0xFF64748B),
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

class _BubbleOverlapPainter extends CustomPainter {
  const _BubbleOverlapPainter({
    required this.bubbles,
    required this.methods,
    required this.animation,
    required this.hoveredIndex,
    required this.isDark,
    required this.tint,
  });

  final List<_FileBubble> bubbles;
  final List<_MethodSignal> methods;
  final double animation;
  final int? hoveredIndex;
  final bool isDark;
  final Color tint;

  Color _blendColors(List<Color> colors) {
    if (colors.isEmpty) return const Color(0xFF6B7280);
    if (colors.length == 1) return colors.first;
    // Average RGB components
    int r = 0, g = 0, b = 0;
    for (final c in colors) {
      r += c.red;
      g += c.green;
      b += c.blue;
    }
    return Color.fromARGB(
      255,
      (r ~/ colors.length).clamp(0, 255),
      (g ~/ colors.length).clamp(0, 255),
      (b ~/ colors.length).clamp(0, 255),
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (bubbles.isEmpty) return;

    // Compute bubble positions with spacing to show overlaps
    final positions = _computePositions(size);

    // Draw connections between overlapping files
    for (int i = 0; i < bubbles.length; i++) {
      for (int j = i + 1; j < bubbles.length; j++) {
        final p1 = positions[i];
        final r1 = _bubbleRadius(bubbles[i].score);
        final p2 = positions[j];
        final r2 = _bubbleRadius(bubbles[j].score);

        final dist = (p2 - p1).distance;
        if (dist < r1 + r2 + 20) {
          // Overlapping or close
          final intersects = dist < r1 + r2;
          canvas.drawLine(
            p1,
            p2,
            Paint()
              ..color = tint.withOpacity(intersects ? 0.3 : 0.12)
              ..strokeWidth = intersects ? 1.5 : 0.8,
          );
        }
      }
    }

    // Draw bubbles
    for (int i = 0; i < bubbles.length; i++) {
      final bubble = bubbles[i];
      final pos = positions[i];
      final radius = _bubbleRadius(bubble.score);

      // Matched method colors
      final matchColors = bubble.matchedBy
          .map(
            (id) => methods
                .firstWhere((m) => m.id == id, orElse: () => methods.first)
                .color,
          )
          .toList();
      final blendedColor = _blendColors(matchColors);

      // Hover/animation pulse
      final isHovered = hoveredIndex == i;
      final pulse =
          0.95 + (math.sin((animation + i * 0.15) * 2 * math.pi) + 1) * 0.05;
      final animRadius = radius * (isHovered ? 1.12 : pulse);

      // Shadow
      if (isHovered) {
        canvas.drawCircle(
          pos,
          animRadius + 2,
          Paint()
            ..color = blendedColor.withOpacity(0.15)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
        );
      }

      // Main bubble with gradient effect
      canvas.drawCircle(
        pos,
        animRadius,
        Paint()
          ..color = blendedColor.withOpacity(isHovered ? 0.85 : 0.72)
          ..style = PaintingStyle.fill,
      );

      // Highlight ring if strong match
      if (bubble.score >= 85) {
        canvas.drawCircle(
          pos,
          animRadius,
          Paint()
            ..color = const Color(0xFFDC2626).withOpacity(0.4)
            ..strokeWidth = 1.2
            ..style = PaintingStyle.stroke,
        );
      }

      // Score badge inside
      final scorePaint = TextPainter(
        text: TextSpan(
          text: '${bubble.score}%',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 11,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      scorePaint.layout();
      scorePaint.paint(
        canvas,
        pos - Offset(scorePaint.width / 2, scorePaint.height / 2),
      );

      // Filename label below (always visible)
      final namePaint = TextPainter(
        text: TextSpan(
          text: bubble.file.length > 20
              ? bubble.file.substring(0, 17) + '..'
              : bubble.file,
          style: TextStyle(
            color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF0F172A),
            fontWeight: FontWeight.w700,
            fontSize: 9,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      namePaint.layout();
      namePaint.paint(
        canvas,
        pos + Offset(-namePaint.width / 2, animRadius + 10),
      );
    }
  }

  List<Offset> _computePositions(Size size) {
    if (bubbles.isEmpty) return [];
    if (bubbles.length == 1) {
      return [Offset(size.width / 2, size.height / 2)];
    }

    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final positions = <Offset>[];

    // Arrange by score in a loose circular pattern with some spacing
    for (int i = 0; i < bubbles.length; i++) {
      final angle = (i / bubbles.length) * 2 * math.pi;
      final distance = 40 + (bubbles[i].score / 100) * 30;
      final x = centerX + distance * math.cos(angle);
      final y = centerY + distance * math.sin(angle);
      positions.add(Offset(x, y));
    }

    return positions;
  }

  double _bubbleRadius(int score) {
    return 16 + (score / 100) * 20;
  }

  @override
  bool shouldRepaint(_BubbleOverlapPainter old) =>
      old.animation != animation || old.hoveredIndex != hoveredIndex;
}

class _FileDetailsTable extends StatelessWidget {
  const _FileDetailsTable({
    required this.files,
    required this.methods,
    required this.hoveredIndex,
    required this.isDark,
    required this.onHoverFile,
    required this.onUnhoverFile,
  });

  final List<_FileBubble> files;
  final List<_MethodSignal> methods;
  final int? hoveredIndex;
  final bool isDark;
  final Function(int) onHoverFile;
  final VoidCallback onUnhoverFile;

  Color _getMethodColor(String methodId) {
    return methods.firstWhere((m) => m.id == methodId).color;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0B1324) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: files.asMap().entries.map((entry) {
          final index = entry.key;
          final file = entry.value;
          final isHovered = hoveredIndex == index;

          return MouseRegion(
            onEnter: (_) => onHoverFile(index),
            onExit: (_) => onUnhoverFile(),
            child: Container(
              margin: const EdgeInsets.only(bottom: 4),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              decoration: BoxDecoration(
                color: isHovered
                    ? (isDark
                          ? const Color(0xFF1E293B)
                          : const Color(0xFFEFF6FF))
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  // File name
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          file.file,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                fontSize: 8.5,
                                fontWeight: FontWeight.w700,
                                color: isDark
                                    ? const Color(0xFFE2E8F0)
                                    : const Color(0xFF0F172A),
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 4),
                  // Similarity score
                  SizedBox(
                    width: 35,
                    child: Text(
                      '${file.score}%',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontSize: 8.5,
                        fontWeight: FontWeight.w800,
                        color: file.score >= 85
                            ? const Color(0xFFDC2626)
                            : (isDark
                                  ? const Color(0xFFCBD5E1)
                                  : const Color(0xFF64748B)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  // Method badges
                  Expanded(
                    flex: 1,
                    child: Wrap(
                      spacing: 2,
                      children: file.matchedBy.map((methodId) {
                        return Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _getMethodColor(methodId),
                            shape: BoxShape.circle,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(width: 4),
                  // Repackaged likelihood
                  SizedBox(
                    width: 30,
                    child: Text(
                      '${file.repackagedLikelihood}%',
                      textAlign: TextAlign.right,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontSize: 8,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF64748B),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
