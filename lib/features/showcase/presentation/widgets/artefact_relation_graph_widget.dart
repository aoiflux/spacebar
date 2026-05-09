import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:spacebar/features/showcase/presentation/widgets/showcase_card.dart';

class ArtefactRelationGraphWidget extends StatefulWidget {
  final String title;
  final String description;
  final Map<String, dynamic> mockData;
  final Color? tint;

  const ArtefactRelationGraphWidget({
    super.key,
    required this.title,
    required this.description,
    required this.mockData,
    this.tint,
  });

  @override
  State<ArtefactRelationGraphWidget> createState() =>
      _ArtefactRelationGraphWidgetState();
}

class _ArtefactRelationGraphWidgetState
    extends State<ArtefactRelationGraphWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final Set<int> _expanded = {0, 1, 2, 3};

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primary = widget.tint ?? const Color(0xFF8B5CF6);

    final hierarchy =
        (widget.mockData['hierarchy'] as List?)?.cast<Map<String, dynamic>>() ??
        const <Map<String, dynamic>>[];
    final nodes =
        (widget.mockData['nodes'] as List?)?.cast<String>() ?? const [];
    final edges =
        (widget.mockData['edges'] as List?)?.cast<Map<String, dynamic>>() ??
        const [];
    final clusters =
        (widget.mockData['clusters'] as List?)?.cast<String>() ?? const [];

    return ShowcaseCard(
      title: widget.title,
      description: widget.description,
      tint: primary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 112,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0B1324) : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: primary.withOpacity(0.24)),
            ),
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                return CustomPaint(
                  painter: _ArgMiniGraphPainter(
                    progress: _controller.value,
                    darkMode: isDark,
                    color: primary,
                    nodeCount: nodes.length,
                    edgeCount: edges.length,
                  ),
                  child: const SizedBox.expand(),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              final active = clusters.isEmpty
                  ? 0
                  : (_controller.value * clusters.length).floor() %
                        clusters.length;
              return Wrap(
                spacing: 6,
                runSpacing: 6,
                children: List.generate(clusters.length, (index) {
                  final isActive = index == active;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: isActive
                          ? primary.withOpacity(0.2)
                          : primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: isActive
                            ? primary.withOpacity(0.45)
                            : primary.withOpacity(0.2),
                      ),
                    ),
                    child: Text(
                      clusters[index],
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? const Color(0xFFE2E8F0)
                            : const Color(0xFF1E293B),
                      ),
                    ),
                  );
                }),
              );
            },
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: hierarchy.length,
              itemBuilder: (context, index) {
                final section = hierarchy[index];
                final label = section['label'] as String? ?? 'Section';
                final children =
                    (section['children'] as List?)?.cast<String>() ?? const [];

                final start = (index / (hierarchy.length + 1)).clamp(0.0, 0.8);
                final end = (start + 0.35).clamp(0.0, 1.0);
                final reveal = CurvedAnimation(
                  parent: _controller,
                  curve: Interval(start, end, curve: Curves.easeOut),
                );

                return AnimatedBuilder(
                  animation: reveal,
                  builder: (context, _) {
                    return Opacity(
                      opacity: reveal.value,
                      child: Transform.translate(
                        offset: Offset((1 - reveal.value) * 10, 0),
                        child: _ArgSection(
                          label: label,
                          children: children,
                          expanded: _expanded.contains(index),
                          onToggle: () {
                            setState(() {
                              if (_expanded.contains(index)) {
                                _expanded.remove(index);
                              } else {
                                _expanded.add(index);
                              }
                            });
                          },
                          color: primary,
                          darkMode: isDark,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ArgSection extends StatelessWidget {
  final String label;
  final List<String> children;
  final bool expanded;
  final VoidCallback onToggle;
  final Color color;
  final bool darkMode;

  const _ArgSection({
    required this.label,
    required this.children,
    required this.expanded,
    required this.onToggle,
    required this.color,
    required this.darkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(darkMode ? 0.12 : 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.24)),
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: onToggle,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Tooltip(
                      message: '$label category in ARG hierarchy',
                      child: Text(
                        label,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: darkMode
                              ? const Color(0xFFE2E8F0)
                              : const Color(0xFF1E293B),
                        ),
                      ),
                    ),
                  ),
                  Icon(
                    expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    size: 16,
                    color: color,
                  ),
                ],
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            child: expanded
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 8),
                    child: Column(
                      children: List.generate(children.length, (index) {
                        final item = children[index];
                        return Container(
                          margin: const EdgeInsets.only(top: 6),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: darkMode
                                ? const Color(0xFF0F172A)
                                : Colors.white.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(7),
                            border: Border.all(color: color.withOpacity(0.18)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: color.withOpacity(0.75),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 7),
                              Expanded(
                                child: Tooltip(
                                  message: 'Explain: $item',
                                  child: Text(
                                    item,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                          fontSize: 9,
                                          fontWeight: FontWeight.w600,
                                          color: darkMode
                                              ? const Color(0xFFCBD5E1)
                                              : const Color(0xFF334155),
                                        ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class _ArgMiniGraphPainter extends CustomPainter {
  final double progress;
  final bool darkMode;
  final Color color;
  final int nodeCount;
  final int edgeCount;

  _ArgMiniGraphPainter({
    required this.progress,
    required this.darkMode,
    required this.color,
    required this.nodeCount,
    required this.edgeCount,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()
      ..color = (darkMode ? const Color(0xFF334155) : const Color(0xFFCBD5E1))
          .withOpacity(0.22)
      ..strokeWidth = 0.7;

    for (double x = 0; x <= size.width; x += size.width / 6) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }

    final points = <Offset>[
      Offset(size.width * 0.16, size.height * 0.26),
      Offset(size.width * 0.36, size.height * 0.65),
      Offset(size.width * 0.57, size.height * 0.32),
      Offset(size.width * 0.79, size.height * 0.58),
    ];

    final edgePaint = Paint()
      ..color = color.withOpacity(0.5)
      ..strokeWidth = 1.6
      ..style = PaintingStyle.stroke;

    final edgeTotal = math.max(edgeCount, 2);
    for (int i = 0; i < edgeTotal; i++) {
      final from = points[i % points.length];
      final to = points[(i + 1) % points.length];
      final t = (progress * 1.2).clamp(0.0, 1.0);
      final dx = from.dx + (to.dx - from.dx) * t;
      final dy = from.dy + (to.dy - from.dy) * t;
      canvas.drawLine(from, Offset(dx, dy), edgePaint);
    }

    final nodeTotal = math.max(nodeCount, 3);
    for (int i = 0; i < nodeTotal; i++) {
      final p = points[i % points.length];
      final active = i == (progress * nodeTotal).floor() % nodeTotal;
      final r = active ? 7.5 : 5.2;

      canvas.drawCircle(
        p,
        r + (active ? 2.4 * math.sin(progress * math.pi * 2).abs() : 0),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2
          ..color = color.withOpacity(active ? 0.4 : 0.18),
      );
      canvas.drawCircle(
        p,
        r,
        Paint()..color = active ? color : color.withOpacity(0.75),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ArgMiniGraphPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.darkMode != darkMode ||
        oldDelegate.color != color ||
        oldDelegate.nodeCount != nodeCount ||
        oldDelegate.edgeCount != edgeCount;
  }
}
