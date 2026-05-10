import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:spacebar/features/showcase/presentation/widgets/showcase_card.dart';

class _CaseNode {
  const _CaseNode({required this.id, required this.matches});
  final String id;
  final int matches;
}

class _EdgeLink {
  const _EdgeLink({
    required this.from,
    required this.to,
    required this.indicator,
  });

  final int from;
  final int to;
  final String indicator;
}

class NetworkGraphWidget extends StatefulWidget {
  final String title;
  final String description;
  final Map<String, dynamic> mockData;
  final Color? tint;

  const NetworkGraphWidget({
    super.key,
    required this.title,
    required this.description,
    required this.mockData,
    this.tint,
  });

  @override
  State<NetworkGraphWidget> createState() => _NetworkGraphWidgetState();
}

class _NetworkGraphWidgetState extends State<NetworkGraphWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _motionCtrl;
  int? _hoveredCase;

  @override
  void initState() {
    super.initState();
    _motionCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 9200),
    )..repeat();
  }

  @override
  void dispose() {
    _motionCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryTint = widget.tint ?? const Color(0xFFF59E0B);

    final casesRaw =
        (widget.mockData['cases'] as List?)?.cast<Map<String, dynamic>>() ??
        const [];
    final linksRaw =
        (widget.mockData['links'] as List?)?.cast<Map<String, dynamic>>() ??
        const [];
    final indicatorsRaw =
        (widget.mockData['shared_indicators'] as List?)?.cast<String>() ??
        const ['EXE hash', 'C2 domain', 'IP block', 'Persistence pattern'];

    final nodes = _buildNodes(casesRaw);
    final edges = _buildEdges(nodes.length, linksRaw, indicatorsRaw);

    final sharedArtifacts =
        widget.mockData['sharedArtifacts'] as int? ?? edges.length;
    final clusters = widget.mockData['clusters'] as int? ?? 1;
    final reuseHits = widget.mockData['reuseHits'] as int? ?? edges.length;
    final topIndicators = edges
        .map((e) => e.indicator)
        .where((s) => s.trim().isNotEmpty)
        .toList(growable: false);

    final riskScore =
        (45 + reuseHits * 4 + sharedArtifacts * 3 + edges.length * 5).clamp(
          0,
          100,
        );
    final confidence = riskScore >= 80
        ? 'High confidence'
        : (riskScore >= 60 ? 'Medium confidence' : 'Low confidence');
    final nextAction = riskScore >= 80
        ? 'Prioritize campaign-wide containment and block shared IOC set.'
        : 'Continue triage and enrich indicators before broad containment.';

    return ShowcaseCard(
      title: widget.title,
      description: widget.description,
      tint: primaryTint,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact =
              constraints.maxWidth < 320 || constraints.maxHeight < 300;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(compact ? 7 : 10),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF0B1324)
                        : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: primaryTint.withValues(alpha: 0.2)),
                  ),
                  child: AnimatedBuilder(
                    animation: _motionCtrl,
                    builder: (_, __) {
                      final loop = _motionCtrl.value;
                      final wave = (math.sin(loop * 2 * math.pi) + 1) / 2;
                      final mergeT = 0.42 + (wave * 0.08);
                      return _ClusterGraphPanel(
                        mergeT: mergeT,
                        flowT: loop,
                        sweepT: loop,
                        nodes: nodes,
                        edges: edges,
                        hoveredCase: _hoveredCase,
                        isDark: isDark,
                        tint: primaryTint,
                        compact: compact,
                        onHoverNode: (idx) =>
                            setState(() => _hoveredCase = idx),
                        onExitNode: () => setState(() => _hoveredCase = null),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 8),
              _BottomSummary(
                reuseHits: reuseHits,
                caseCount: nodes.length,
                sharedArtifacts: sharedArtifacts,
                clusters: clusters,
                compact: compact,
                isDark: isDark,
                tint: primaryTint,
                confidence: confidence,
                riskScore: riskScore,
                topIndicators: topIndicators,
                nextAction: nextAction,
              ),
            ],
          );
        },
      ),
    );
  }

  List<_CaseNode> _buildNodes(List<Map<String, dynamic>> source) {
    if (source.isEmpty) {
      return const [
        _CaseNode(id: 'Case A', matches: 12),
        _CaseNode(id: 'Case B', matches: 8),
        _CaseNode(id: 'Case C', matches: 5),
      ];
    }

    final list = source.take(3).map((c) {
      final id = c['id'] as String? ?? 'Case';
      final pretty = id.startsWith('case-') ? 'Case ${id.substring(5)}' : id;
      return _CaseNode(id: pretty, matches: c['matches'] as int? ?? 0);
    }).toList();

    while (list.length < 3) {
      list.add(
        _CaseNode(
          id: 'Case ${String.fromCharCode(65 + list.length)}',
          matches: 0,
        ),
      );
    }
    return list;
  }

  List<_EdgeLink> _buildEdges(
    int nodeCount,
    List<Map<String, dynamic>> links,
    List<String> indicators,
  ) {
    if (nodeCount < 3) return const [];

    if (links.isNotEmpty) {
      final out = <_EdgeLink>[];
      for (int i = 0; i < links.length && i < 3; i++) {
        final label =
            links[i]['artifact'] as String? ??
            indicators[i % indicators.length];
        final pair = i == 0
            ? const [0, 1]
            : (i == 1 ? const [0, 2] : const [1, 2]);
        out.add(_EdgeLink(from: pair[0], to: pair[1], indicator: label));
      }
      return out;
    }

    return [
      _EdgeLink(from: 0, to: 1, indicator: indicators[0 % indicators.length]),
      _EdgeLink(from: 0, to: 2, indicator: indicators[1 % indicators.length]),
      _EdgeLink(from: 1, to: 2, indicator: indicators[2 % indicators.length]),
    ];
  }
}

class _ClusterGraphPanel extends StatelessWidget {
  const _ClusterGraphPanel({
    required this.mergeT,
    required this.flowT,
    required this.sweepT,
    required this.nodes,
    required this.edges,
    required this.hoveredCase,
    required this.isDark,
    required this.tint,
    required this.compact,
    required this.onHoverNode,
    required this.onExitNode,
  });

  final double mergeT;
  final double flowT;
  final double sweepT;
  final List<_CaseNode> nodes;
  final List<_EdgeLink> edges;
  final int? hoveredCase;
  final bool isDark;
  final Color tint;
  final bool compact;
  final ValueChanged<int> onHoverNode;
  final VoidCallback onExitNode;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        final positions = _positionsFor(size, mergeT);

        return Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: _ClusterPainter(
                  nodes: nodes,
                  edges: edges,
                  positions: positions,
                  hoveredCase: hoveredCase,
                  mergeT: mergeT,
                  flowT: flowT,
                  sweepT: sweepT,
                  tint: tint,
                  isDark: isDark,
                  compact: compact,
                ),
              ),
            ),
            for (int i = 0; i < nodes.length; i++)
              Positioned(
                left: positions[i].dx - (compact ? 20 : 24),
                top: positions[i].dy - (compact ? 20 : 24),
                width: compact ? 40 : 48,
                height: compact ? 40 : 48,
                child: Tooltip(
                  message:
                      '${nodes[i].id}: ${nodes[i].matches} shared indicators with campaign cluster',
                  waitDuration: const Duration(milliseconds: 200),
                  child: MouseRegion(
                    onEnter: (_) => onHoverNode(i),
                    onExit: (_) => onExitNode(),
                    child: const SizedBox.expand(),
                  ),
                ),
              ),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF7C3AED).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: const Color(0xFF7C3AED).withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  'One campaign, multiple incidents',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontSize: 8.8,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF7C3AED),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  List<Offset> _positionsFor(Size size, double t) {
    final center = Offset(size.width * 0.5, size.height * 0.53);
    final orbit = [
      Offset(size.width * 0.24, size.height * 0.32),
      Offset(size.width * 0.76, size.height * 0.32),
      Offset(size.width * 0.5, size.height * 0.78),
    ];
    return List<Offset>.generate(orbit.length, (i) {
      final start = orbit[i];
      return Offset.lerp(start, center, t * 0.5) ?? start;
    }, growable: false);
  }
}

class _ClusterPainter extends CustomPainter {
  const _ClusterPainter({
    required this.nodes,
    required this.edges,
    required this.positions,
    required this.hoveredCase,
    required this.mergeT,
    required this.flowT,
    required this.sweepT,
    required this.tint,
    required this.isDark,
    required this.compact,
  });

  final List<_CaseNode> nodes;
  final List<_EdgeLink> edges;
  final List<Offset> positions;
  final int? hoveredCase;
  final double mergeT;
  final double flowT;
  final double sweepT;
  final Color tint;
  final bool isDark;
  final bool compact;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.5, size.height * 0.53);

    // Cluster highlight in center
    canvas.drawCircle(
      center,
      (compact ? 22 : 28) + mergeT * 10,
      Paint()
        ..color = tint.withValues(alpha: 0.06 + mergeT * 0.04)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );
    final sweepStart = (sweepT * 2 * math.pi) - (math.pi / 2);
    final sweepRect = Rect.fromCircle(
      center: center,
      radius: (compact ? 22 : 28) + mergeT * 10,
    );
    canvas.drawArc(
      sweepRect,
      sweepStart,
      math.pi / 4.0,
      false,
      Paint()
        ..color = tint.withValues(alpha: 0.16)
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = compact ? 1.1 : 1.4,
    );
    canvas.drawCircle(
      center,
      compact ? 16 : 20,
      Paint()
        ..color = tint.withValues(alpha: 0.16)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4,
    );

    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    // Shared-indicator edges
    for (final edge in edges) {
      if (edge.from >= positions.length || edge.to >= positions.length)
        continue;
      final a = positions[edge.from];
      final b = positions[edge.to];

      final highlighted = hoveredCase == edge.from || hoveredCase == edge.to;
      final linePaint = Paint()
        ..color = highlighted
            ? tint.withValues(alpha: 0.7)
            : tint.withValues(alpha: 0.28 + 0.08 * mergeT)
        ..strokeWidth = highlighted ? 1.8 : 1.25
        ..style = PaintingStyle.stroke;

      canvas.drawLine(a, b, linePaint);

      // Animated packet flow makes linkage feel alive and directional.
      final packetT = (flowT + edge.from * 0.19 + edge.to * 0.13) % 1.0;
      final packet = Offset.lerp(a, b, packetT) ?? a;
      canvas.drawCircle(
        packet,
        compact ? 1.7 : 2.0,
        Paint()
          ..color = tint.withValues(alpha: 0.7)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.3),
      );

      final mid = Offset((a.dx + b.dx) / 2, (a.dy + b.dy) / 2);
      final labelBg = RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: mid,
          width: compact ? 64 : 82,
          height: compact ? 14 : 16,
        ),
        const Radius.circular(5),
      );
      canvas.drawRRect(
        labelBg,
        Paint()
          ..color = isDark ? const Color(0xFF111827) : Colors.white
          ..style = PaintingStyle.fill,
      );
      canvas.drawRRect(
        labelBg,
        Paint()
          ..color = tint.withValues(alpha: 0.24)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );
      textPainter.text = TextSpan(
        text: edge.indicator,
        style: TextStyle(
          fontSize: compact ? 7.2 : 8,
          fontWeight: FontWeight.w700,
          color: tint,
        ),
      );
      textPainter.layout(maxWidth: compact ? 60 : 78);
      textPainter.paint(
        canvas,
        Offset(mid.dx - textPainter.width / 2, mid.dy - textPainter.height / 2),
      );
    }

    // Case nodes
    for (int i = 0; i < nodes.length; i++) {
      final p = positions[i];
      final selected = hoveredCase == i;
      final radius = selected
          ? (compact ? 11.0 : 13.0)
          : (compact ? 9.0 : 11.0);

      canvas.drawCircle(
        p,
        radius + 6,
        Paint()
          ..color = tint.withValues(alpha: selected ? 0.28 : 0.12)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
      );
      canvas.drawCircle(
        p,
        radius,
        Paint()..color = selected ? tint : tint.withValues(alpha: 0.8),
      );

      textPainter.text = TextSpan(
        text: nodes[i].id,
        style: TextStyle(
          fontSize: compact ? 8.5 : 9.5,
          fontWeight: FontWeight.w800,
          color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF0F172A),
        ),
      );
      textPainter.layout(maxWidth: 90);
      textPainter.paint(
        canvas,
        Offset(p.dx - textPainter.width / 2, p.dy + radius + 5),
      );
    }

    // Center cluster label
    textPainter.text = TextSpan(
      text: 'Cluster',
      style: TextStyle(
        fontSize: compact ? 8 : 9,
        fontWeight: FontWeight.w800,
        color: isDark ? const Color(0xFFBFDBFE) : const Color(0xFF1D4ED8),
      ),
    );
    textPainter.layout(maxWidth: 60);
    textPainter.paint(
      canvas,
      Offset(
        center.dx - textPainter.width / 2,
        center.dy - textPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant _ClusterPainter old) {
    return old.mergeT != mergeT ||
        old.flowT != flowT ||
        old.sweepT != sweepT ||
        old.hoveredCase != hoveredCase ||
        old.positions != positions ||
        old.nodes != nodes ||
        old.edges != edges ||
        old.isDark != isDark;
  }
}

class _BottomSummary extends StatelessWidget {
  const _BottomSummary({
    required this.reuseHits,
    required this.caseCount,
    required this.sharedArtifacts,
    required this.clusters,
    required this.compact,
    required this.isDark,
    required this.tint,
    required this.confidence,
    required this.riskScore,
    required this.topIndicators,
    required this.nextAction,
  });

  final int reuseHits;
  final int caseCount;
  final int sharedArtifacts;
  final int clusters;
  final bool compact;
  final bool isDark;
  final Color tint;
  final String confidence;
  final int riskScore;
  final List<String> topIndicators;
  final String nextAction;

  @override
  Widget build(BuildContext context) {
    final chips = [
      _MetricPill(
        label: 'Reuse Hits',
        value: '$reuseHits',
        color: tint,
        isDark: isDark,
      ),
      _MetricPill(
        label: 'Cases',
        value: '$caseCount',
        color: const Color(0xFF0D7A5F),
        isDark: isDark,
      ),
      _MetricPill(
        label: 'Shared IOC',
        value: '$sharedArtifacts',
        color: const Color(0xFF0EA5E9),
        isDark: isDark,
      ),
      _MetricPill(
        label: 'Clusters',
        value: '$clusters',
        color: const Color(0xFF7C3AED),
        isDark: isDark,
      ),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
      decoration: BoxDecoration(
        color: tint.withValues(alpha: isDark ? 0.12 : 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: tint.withValues(alpha: 0.22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          compact
              ? Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    ...chips,
                    _RiskBadge(confidence: confidence, riskScore: riskScore),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ...chips,
                    _RiskBadge(confidence: confidence, riskScore: riskScore),
                  ],
                ),
          const SizedBox(height: 7),
          Text(
            'Shared indicators: ${topIndicators.take(3).join(' · ')}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontSize: 9.2,
              fontWeight: FontWeight.w700,
              color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Recommended next step: $nextAction',
            maxLines: compact ? 2 : 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontSize: 8.8,
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF52637A),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _RiskBadge extends StatelessWidget {
  const _RiskBadge({required this.confidence, required this.riskScore});

  final String confidence;
  final int riskScore;

  @override
  Widget build(BuildContext context) {
    final high = riskScore >= 80;
    final medium = riskScore >= 60 && riskScore < 80;
    final color = high
        ? const Color(0xFFDC2626)
        : (medium ? const Color(0xFFD97706) : const Color(0xFF0D7A5F));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.28)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 5),
          Text(
            'Risk $riskScore · $confidence',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontSize: 9,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricPill extends StatelessWidget {
  const _MetricPill({
    required this.label,
    required this.value,
    required this.color,
    required this.isDark,
  });

  final String label;
  final String value;
  final Color color;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.14 : 0.1),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: ',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontSize: 9.5,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

