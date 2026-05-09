import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:spacebar/features/showcase/presentation/widgets/showcase_card.dart';

// ─── Data model ──────────────────────────────────────────────────────────────

enum _NodeType { storage, binary, threat, persistence, event, network }

class _NodeData {
  const _NodeData(this.id, this.label, this.type, this.x, this.y);
  final String id;
  final String label;
  final _NodeType type;
  final double x;
  final double y;
}

class _EdgeData {
  const _EdgeData(this.from, this.to, this.label);
  final String from;
  final String to;
  final String label;
}

const _kNodes = <_NodeData>[
  _NodeData('n1', 'Disk image', _NodeType.storage, 0.06, 0.14),
  _NodeData('n2', 'Partition', _NodeType.storage, 0.26, 0.08),
  _NodeData('n3', 'Indexed file', _NodeType.storage, 0.46, 0.14),
  _NodeData('n4', 'Executable', _NodeType.binary, 0.64, 0.08),
  _NodeData('n5', 'PE Section', _NodeType.binary, 0.84, 0.15),
  _NodeData('n6', 'Malware String', _NodeType.threat, 0.88, 0.49),
  _NodeData('n7', 'Registry Run Key', _NodeType.persistence, 0.64, 0.60),
  _NodeData('n8', 'Process Start', _NodeType.event, 0.44, 0.76),
  _NodeData('n9', 'Packet Flow', _NodeType.network, 0.22, 0.76),
  _NodeData('n10', 'Memory Region', _NodeType.threat, 0.06, 0.54),
];

const _kEdges = <_EdgeData>[
  _EdgeData('n1', 'n2', 'Contains'),
  _EdgeData('n2', 'n3', 'Indexes'),
  _EdgeData('n3', 'n4', 'Extracts'),
  _EdgeData('n4', 'n5', 'Contains'),
  _EdgeData('n5', 'n6', 'Similarity'),
  _EdgeData('n6', 'n7', 'Referenced By'),
  _EdgeData('n7', 'n8', 'Leads To'),
  _EdgeData('n4', 'n10', 'Observed In'),
  _EdgeData('n8', 'n9', 'Contacts'),
  _EdgeData('n10', 'n7', 'Linked To'),
];

Color _typeColor(_NodeType t) {
  switch (t) {
    case _NodeType.storage:
      return const Color(0xFF3B82F6);
    case _NodeType.binary:
      return const Color(0xFFF59E0B);
    case _NodeType.threat:
      return const Color(0xFFEF4444);
    case _NodeType.persistence:
      return const Color(0xFFF97316);
    case _NodeType.event:
      return const Color(0xFF10B981);
    case _NodeType.network:
      return const Color(0xFF06B6D4);
  }
}

String _typeLabel(_NodeType t) {
  switch (t) {
    case _NodeType.storage:
      return 'Storage';
    case _NodeType.binary:
      return 'Binary';
    case _NodeType.threat:
      return 'Threat';
    case _NodeType.persistence:
      return 'Persist';
    case _NodeType.event:
      return 'Event';
    case _NodeType.network:
      return 'Network';
  }
}

IconData _typeIcon(_NodeType t) {
  switch (t) {
    case _NodeType.storage:
      return Icons.storage_rounded;
    case _NodeType.binary:
      return Icons.code_rounded;
    case _NodeType.threat:
      return Icons.warning_amber_rounded;
    case _NodeType.persistence:
      return Icons.settings_rounded;
    case _NodeType.event:
      return Icons.bolt_rounded;
    case _NodeType.network:
      return Icons.wifi_rounded;
  }
}

// ─── Main Widget ─────────────────────────────────────────────────────────────

class GraphTimelineWidget extends StatefulWidget {
  final String title;
  final String description;
  final Map<String, dynamic> mockData;
  final Color? tint;

  const GraphTimelineWidget({
    super.key,
    required this.title,
    required this.description,
    required this.mockData,
    this.tint,
  });

  @override
  State<GraphTimelineWidget> createState() => _GraphTimelineWidgetState();
}

class _GraphTimelineWidgetState extends State<GraphTimelineWidget>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late final AnimationController _flowCtrl;
  late final AnimationController _pulseCtrl;

  @override
  void initState() {
    super.initState();
    _flowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _flowCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final tint = widget.tint ?? const Color(0xFF6941C6);
    final selectedNode = _kNodes[_selectedIndex];

    final chains =
        (widget.mockData['relationChains'] as List?)
            ?.cast<Map<String, dynamic>>() ??
        const <Map<String, dynamic>>[];

    final chain = chains.firstWhere(
      (c) => (c['root'] as String? ?? '').toLowerCase().contains(
        selectedNode.label.toLowerCase(),
      ),
      orElse: () =>
          chains.isNotEmpty ? chains.first : const <String, dynamic>{},
    );
    final chainRoot = chain['root'] as String? ?? selectedNode.label;
    final chainSteps =
        (chain['steps'] as List?)?.cast<Map<String, dynamic>>() ??
        const <Map<String, dynamic>>[];

    final nodeCount = widget.mockData['nodes'] as int? ?? _kNodes.length;
    final edgeCount = widget.mockData['edges'] as int? ?? _kEdges.length;

    return ShowcaseCard(
      title: widget.title,
      description: widget.description,
      tint: tint,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Left: animated graph canvas ─────────────────────────────────
          Expanded(
            flex: 62,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _NodeTypeLegend(isDark: isDark),
                const SizedBox(height: 8),
                Expanded(
                  child: _GraphCanvas(
                    nodes: _kNodes,
                    edges: _kEdges,
                    selectedIndex: _selectedIndex,
                    flowCtrl: _flowCtrl,
                    pulseCtrl: _pulseCtrl,
                    isDark: isDark,
                    tint: tint,
                    onSelectNode: (i) => setState(() => _selectedIndex = i),
                  ),
                ),
                const SizedBox(height: 10),
                _StatsBar(
                  nodeCount: nodeCount,
                  edgeCount: edgeCount,
                  isDark: isDark,
                  tint: tint,
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          // ── Right: detail panel ─────────────────────────────────────────
          SizedBox(
            width: 192,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _NodeDetailHeader(node: selectedNode, isDark: isDark),
                const SizedBox(height: 12),
                _DetailSectionLabel('RELATION PATH', isDark: isDark),
                const SizedBox(height: 8),
                Expanded(
                  child: _ChainDetailPanel(
                    root: chainRoot,
                    steps: chainSteps,
                    selectedLabel: selectedNode.label,
                    isDark: isDark,
                    tint: tint,
                  ),
                ),
                const SizedBox(height: 10),
                _EvidenceSourceRow(
                  indexedFile:
                      widget.mockData['indexedFile'] as String? ??
                      'indexed_file_0142.bin',
                  memoryImage:
                      widget.mockData['memoryImage'] as String? ??
                      'memdump-win11-0410.raw',
                  packetCapture:
                      widget.mockData['packetCapture'] as String? ??
                      'capture-2026-05-10.pcapng',
                  isDark: isDark,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Graph canvas ─────────────────────────────────────────────────────────────

class _GraphCanvas extends StatelessWidget {
  const _GraphCanvas({
    required this.nodes,
    required this.edges,
    required this.selectedIndex,
    required this.flowCtrl,
    required this.pulseCtrl,
    required this.isDark,
    required this.tint,
    required this.onSelectNode,
  });

  final List<_NodeData> nodes;
  final List<_EdgeData> edges;
  final int selectedIndex;
  final AnimationController flowCtrl;
  final AnimationController pulseCtrl;
  final bool isDark;
  final Color tint;
  final ValueChanged<int> onSelectNode;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF070E1C) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: tint.withOpacity(0.18), width: 1.2),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = Size(constraints.maxWidth, constraints.maxHeight);
          return GestureDetector(
            onTapDown: (details) {
              final pos = details.localPosition;
              double minDist = double.infinity;
              int nearest = 0;
              for (int i = 0; i < nodes.length; i++) {
                final c = Offset(
                  nodes[i].x * size.width,
                  nodes[i].y * size.height,
                );
                final d = (pos - c).distance;
                if (d < minDist) {
                  minDist = d;
                  nearest = i;
                }
              }
              if (minDist < 44) onSelectNode(nearest);
            },
            child: AnimatedBuilder(
              animation: Listenable.merge([flowCtrl, pulseCtrl]),
              builder: (_, __) => CustomPaint(
                size: size,
                painter: _GraphPainter(
                  nodes: nodes,
                  edges: edges,
                  selectedId: nodes[selectedIndex].id,
                  flowT: flowCtrl.value,
                  pulseT: pulseCtrl.value,
                  isDark: isDark,
                  tint: tint,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─── Painter ──────────────────────────────────────────────────────────────────

class _GraphPainter extends CustomPainter {
  _GraphPainter({
    required this.nodes,
    required this.edges,
    required this.selectedId,
    required this.flowT,
    required this.pulseT,
    required this.isDark,
    required this.tint,
  });

  final List<_NodeData> nodes;
  final List<_EdgeData> edges;
  final String selectedId;
  final double flowT;
  final double pulseT;
  final bool isDark;
  final Color tint;

  static const _nr = 9.0; // default node radius
  static const _nrSel = 12.0; // selected node radius

  Offset _center(_NodeData n, Size s) => Offset(n.x * s.width, n.y * s.height);

  _NodeData? _byId(String id) {
    for (final n in nodes) {
      if (n.id == id) return n;
    }
    return null;
  }

  Offset _bezierPt(Offset a, Offset ctrl, Offset b, double t) {
    final mt = 1 - t;
    return Offset(
      mt * mt * a.dx + 2 * mt * t * ctrl.dx + t * t * b.dx,
      mt * mt * a.dy + 2 * mt * t * ctrl.dy + t * t * b.dy,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    _drawGrid(canvas, size);
    _drawSelectedGlow(canvas, size);
    _drawEdges(canvas, size);
    _drawNodes(canvas, size);
  }

  void _drawGrid(Canvas canvas, Size size) {
    final p = Paint()
      ..color = (isDark ? const Color(0xFF1E3A5F) : const Color(0xFFCBD5E1))
          .withOpacity(0.3)
      ..style = PaintingStyle.fill;
    const step = 22.0;
    for (double x = step; x < size.width; x += step) {
      for (double y = step; y < size.height; y += step) {
        canvas.drawCircle(Offset(x, y), 0.9, p);
      }
    }
  }

  void _drawSelectedGlow(Canvas canvas, Size size) {
    final sel = _byId(selectedId);
    if (sel == null) return;
    final c = _center(sel, size);
    canvas.drawCircle(
      c,
      60 + pulseT * 22,
      Paint()
        ..color = _typeColor(sel.type).withOpacity(0.055 + pulseT * 0.035)
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 36),
    );
  }

  void _drawEdges(Canvas canvas, Size size) {
    for (final edge in edges) {
      final fn = _byId(edge.from);
      final tn = _byId(edge.to);
      if (fn == null || tn == null) continue;

      final from = _center(fn, size);
      final to = _center(tn, size);
      final highlighted = edge.from == selectedId || edge.to == selectedId;

      // Perpendicular bezier control point
      final mid = Offset((from.dx + to.dx) / 2, (from.dy + to.dy) / 2);
      final dx = to.dx - from.dx;
      final dy = to.dy - from.dy;
      final perp = Offset(-dy, dx) * 0.18;
      final ctrl = mid + perp;

      final path = Path()
        ..moveTo(from.dx, from.dy)
        ..quadraticBezierTo(ctrl.dx, ctrl.dy, to.dx, to.dy);

      if (highlighted) {
        // Glow
        canvas.drawPath(
          path,
          Paint()
            ..color = tint.withOpacity(0.22)
            ..strokeWidth = 7
            ..style = PaintingStyle.stroke
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
        );
        // Solid line
        canvas.drawPath(
          path,
          Paint()
            ..color = tint.withOpacity(0.9)
            ..strokeWidth = 2.0
            ..style = PaintingStyle.stroke,
        );
        // Flow particle
        final pt = _bezierPt(from, ctrl, to, flowT);
        canvas.drawCircle(
          pt,
          5.5,
          Paint()
            ..color = Colors.white.withOpacity(0.85)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
        );
        canvas.drawCircle(pt, 3.0, Paint()..color = tint);

        // Edge label at 50% along bezier
        _drawEdgeLabel(canvas, edge.label, _bezierPt(from, ctrl, to, 0.5));
      } else {
        canvas.drawPath(
          path,
          Paint()
            ..color =
                (isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1))
                    .withOpacity(0.5)
            ..strokeWidth = 1.1
            ..style = PaintingStyle.stroke,
        );
      }
      // Arrowhead
      _drawArrow(canvas, from, ctrl, to, highlighted);
    }
  }

  void _drawArrow(
    Canvas canvas,
    Offset from,
    Offset ctrl,
    Offset to,
    bool highlighted,
  ) {
    final t1 = 0.80;
    final t2 = 0.86;
    final p1 = _bezierPt(from, ctrl, to, t1);
    final p2 = _bezierPt(from, ctrl, to, t2);
    final angle = math.atan2(p2.dy - p1.dy, p2.dx - p1.dx);
    const len = 7.0;
    const spread = 0.45;

    final arrowPath = Path()
      ..moveTo(p2.dx, p2.dy)
      ..lineTo(
        p2.dx - len * math.cos(angle - spread),
        p2.dy - len * math.sin(angle - spread),
      )
      ..lineTo(
        p2.dx - len * math.cos(angle + spread),
        p2.dy - len * math.sin(angle + spread),
      )
      ..close();

    canvas.drawPath(
      arrowPath,
      Paint()
        ..color = highlighted
            ? tint.withOpacity(0.9)
            : (isDark ? const Color(0xFF475569) : const Color(0xFF94A3B8))
                  .withOpacity(0.5)
        ..style = PaintingStyle.fill,
    );
  }

  void _drawEdgeLabel(Canvas canvas, String label, Offset pos) {
    final tp = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(
          fontSize: 8,
          fontWeight: FontWeight.w700,
          color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF0F172A),
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    const pad = 3.5;
    final bgRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: pos,
        width: tp.width + pad * 2 + 4,
        height: tp.height + pad * 2,
      ),
      const Radius.circular(4),
    );

    canvas.drawRRect(
      bgRect,
      Paint()
        ..color = isDark
            ? const Color(0xFF0D1526).withOpacity(0.92)
            : Colors.white.withOpacity(0.94),
    );
    canvas.drawRRect(
      bgRect,
      Paint()
        ..color = tint.withOpacity(0.35)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8,
    );
    tp.paint(canvas, pos - Offset(tp.width / 2, tp.height / 2));
  }

  void _drawNodes(Canvas canvas, Size size) {
    for (int i = 0; i < nodes.length; i++) {
      final node = nodes[i];
      final center = _center(node, size);
      final isSel = node.id == selectedId;
      final color = _typeColor(node.type);
      final r = isSel ? _nrSel : _nr;

      // Animated pulse ring
      if (isSel) {
        final pr = r + 5 + pulseT * 10;
        canvas.drawCircle(
          center,
          pr,
          Paint()
            ..color = color.withOpacity(0.12 + pulseT * 0.1)
            ..style = PaintingStyle.fill,
        );
        canvas.drawCircle(
          center,
          pr,
          Paint()
            ..color = color.withOpacity(0.45)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.0,
        );
      }

      // Glow halo
      canvas.drawCircle(
        center,
        r + 5,
        Paint()
          ..color = color.withOpacity(isSel ? 0.28 : 0.09)
          ..style = PaintingStyle.fill
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 7),
      );

      // Fill
      canvas.drawCircle(
        center,
        r,
        Paint()
          ..color = isSel
              ? color
              : (isDark
                    ? Color.lerp(color, const Color(0xFF0B1324), 0.6)!
                    : Color.lerp(color, Colors.white, 0.72)!),
      );

      // Border
      canvas.drawCircle(
        center,
        r,
        Paint()
          ..color = color.withOpacity(isSel ? 1.0 : 0.65)
          ..style = PaintingStyle.stroke
          ..strokeWidth = isSel ? 2.2 : 1.2,
      );

      // Label below node
      final tp = TextPainter(
        text: TextSpan(
          text: node.label,
          style: TextStyle(
            fontSize: 8.5,
            fontWeight: FontWeight.w700,
            color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF0F172A),
          ),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      )..layout(maxWidth: 78);

      final labelPos = Offset(center.dx - tp.width / 2, center.dy + r + 3.5);
      final bgRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          labelPos.dx - 3,
          labelPos.dy - 1,
          tp.width + 6,
          tp.height + 2,
        ),
        const Radius.circular(3),
      );
      canvas.drawRRect(
        bgRect,
        Paint()
          ..color = isDark
              ? const Color(0xFF080E1C).withOpacity(0.88)
              : Colors.white.withOpacity(0.9),
      );
      tp.paint(canvas, labelPos);
    }
  }

  @override
  bool shouldRepaint(covariant _GraphPainter old) =>
      old.selectedId != selectedId ||
      old.flowT != flowT ||
      old.pulseT != pulseT ||
      old.isDark != isDark;
}

// ─── Sub-widgets ──────────────────────────────────────────────────────────────

class _NodeTypeLegend extends StatelessWidget {
  const _NodeTypeLegend({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _NodeType.values.map((t) {
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _typeColor(t),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  _typeLabel(t),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? const Color(0xFF64748B)
                        : const Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _StatsBar extends StatelessWidget {
  const _StatsBar({
    required this.nodeCount,
    required this.edgeCount,
    required this.isDark,
    required this.tint,
  });
  final int nodeCount;
  final int edgeCount;
  final bool isDark;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatBadge(
          label: 'Nodes',
          value: '$nodeCount',
          color: tint,
          isDark: isDark,
        ),
        const SizedBox(width: 6),
        _StatBadge(
          label: 'Edges',
          value: '$edgeCount',
          color: const Color(0xFF10B981),
          isDark: isDark,
        ),
        const SizedBox(width: 6),
        _StatBadge(
          label: 'Sources',
          value: '3',
          color: const Color(0xFF06B6D4),
          isDark: isDark,
        ),
        const SizedBox(width: 6),
        _StatBadge(
          label: 'Clusters',
          value: '4',
          color: const Color(0xFFF59E0B),
          isDark: isDark,
        ),
      ],
    );
  }
}

class _StatBadge extends StatelessWidget {
  const _StatBadge({
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
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(isDark ? 0.12 : 0.07),
          borderRadius: BorderRadius.circular(7),
          border: Border.all(color: color.withOpacity(0.22)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontSize: 9,
                color: isDark
                    ? const Color(0xFF94A3B8)
                    : const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NodeDetailHeader extends StatelessWidget {
  const _NodeDetailHeader({required this.node, required this.isDark});
  final _NodeData node;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final color = _typeColor(node.type);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(isDark ? 0.12 : 0.07),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.28)),
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(color: color.withOpacity(0.6), width: 1.5),
            ),
            child: Icon(_typeIcon(node.type), size: 15, color: color),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  node.label,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: isDark
                        ? const Color(0xFFE2E8F0)
                        : const Color(0xFF0F172A),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _typeLabel(node.type).toUpperCase(),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontSize: 8,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.9,
                      color: color,
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
}

class _DetailSectionLabel extends StatelessWidget {
  const _DetailSectionLabel(this.text, {required this.isDark});
  final String text;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        fontSize: 9,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.2,
        color: isDark ? const Color(0xFF475569) : const Color(0xFF94A3B8),
      ),
    );
  }
}

class _ChainDetailPanel extends StatelessWidget {
  const _ChainDetailPanel({
    required this.root,
    required this.steps,
    required this.selectedLabel,
    required this.isDark,
    required this.tint,
  });
  final String root;
  final List<Map<String, dynamic>> steps;
  final String selectedLabel;
  final bool isDark;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF070E1C) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          _ChainStep(
            label: root,
            relation: null,
            isRoot: true,
            isDark: isDark,
            tint: tint,
          ),
          ...steps.map((step) {
            final rel = step['relation'] as String? ?? '→';
            final nodeName = step['node'] as String? ?? '-';
            final highlighted = nodeName.toLowerCase().contains(
              selectedLabel.toLowerCase(),
            );
            return _ChainStep(
              label: nodeName,
              relation: rel,
              isRoot: false,
              isDark: isDark,
              tint: tint,
              highlighted: highlighted,
            );
          }),
        ],
      ),
    );
  }
}

class _ChainStep extends StatelessWidget {
  const _ChainStep({
    required this.label,
    required this.relation,
    required this.isRoot,
    required this.isDark,
    required this.tint,
    this.highlighted = false,
  });
  final String label;
  final String? relation;
  final bool isRoot;
  final bool isDark;
  final Color tint;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final nodeColor = isRoot
        ? tint
        : (highlighted ? tint : const Color(0xFF64748B));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (relation != null) ...[
          Padding(
            padding: const EdgeInsets.only(left: 11),
            child: Row(
              children: [
                Container(
                  width: 1.5,
                  height: 10,
                  color: isDark
                      ? const Color(0xFF334155)
                      : const Color(0xFFCBD5E1),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    color: tint.withOpacity(0.09),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: tint.withOpacity(0.2)),
                  ),
                  child: Text(
                    relation!,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontSize: 8,
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF64748B),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        Container(
          margin: const EdgeInsets.only(top: 3, bottom: 3),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          decoration: BoxDecoration(
            color: highlighted
                ? tint.withOpacity(isDark ? 0.18 : 0.09)
                : (isDark
                      ? const Color(0xFF111827).withOpacity(0.6)
                      : const Color(0xFFF1F5F9)),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: highlighted
                  ? tint.withOpacity(0.38)
                  : (isDark
                        ? const Color(0xFF1E293B)
                        : const Color(0xFFE2E8F0)),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: nodeColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontSize: 10,
                    fontWeight: isRoot || highlighted
                        ? FontWeight.w800
                        : FontWeight.w600,
                    color: isDark
                        ? const Color(0xFFE2E8F0)
                        : const Color(0xFF0F172A),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _EvidenceSourceRow extends StatelessWidget {
  const _EvidenceSourceRow({
    required this.indexedFile,
    required this.memoryImage,
    required this.packetCapture,
    required this.isDark,
  });
  final String indexedFile;
  final String memoryImage;
  final String packetCapture;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SourceChip(
          icon: Icons.storage_rounded,
          label: indexedFile,
          color: const Color(0xFF3B82F6),
          isDark: isDark,
        ),
        const SizedBox(height: 4),
        _SourceChip(
          icon: Icons.memory_rounded,
          label: memoryImage,
          color: const Color(0xFF8B5CF6),
          isDark: isDark,
        ),
        const SizedBox(height: 4),
        _SourceChip(
          icon: Icons.wifi_rounded,
          label: packetCapture,
          color: const Color(0xFFEF4444),
          isDark: isDark,
        ),
      ],
    );
  }
}

class _SourceChip extends StatelessWidget {
  const _SourceChip({
    required this.icon,
    required this.label,
    required this.color,
    required this.isDark,
  });
  final IconData icon;
  final String label;
  final Color color;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(isDark ? 0.1 : 0.06),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.22)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? const Color(0xFF94A3B8)
                    : const Color(0xFF475569),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
