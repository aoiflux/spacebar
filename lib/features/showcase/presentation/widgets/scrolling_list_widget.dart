import 'dart:async';

import 'package:flutter/material.dart';
import 'package:spacebar/features/showcase/presentation/widgets/showcase_card.dart';

class _ArtifactItem {
  const _ArtifactItem({
    required this.type,
    required this.icon,
    required this.color,
  });

  final String type;
  final String icon;
  final Color color;

  factory _ArtifactItem.fromMap(Map<String, dynamic> map) {
    return _ArtifactItem(
      type: map['type'] as String? ?? 'Item',
      icon: map['icon'] as String? ?? '📄',
      color: Color(map['color'] as int? ?? 0xFFE8EDF5),
    );
  }
}

class ScrollingListWidget extends StatefulWidget {
  final String title;
  final String description;
  final List<Map<String, dynamic>> items;
  final Color? tint;

  const ScrollingListWidget({
    super.key,
    required this.title,
    required this.description,
    required this.items,
    this.tint,
  });

  @override
  State<ScrollingListWidget> createState() => _ScrollingListWidgetState();
}

class _ScrollingListWidgetState extends State<ScrollingListWidget>
    with TickerProviderStateMixin {
  late final AnimationController _flowCtrl;
  late final AnimationController _pulseCtrl;
  Timer? _rotateTimer;
  int _selected = 0;

  @override
  void initState() {
    super.initState();
    _flowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat(reverse: true);

    _rotateTimer = Timer.periodic(const Duration(milliseconds: 2300), (_) {
      if (!mounted || widget.items.isEmpty) return;
      setState(() => _selected = (_selected + 1) % widget.items.length);
    });
  }

  @override
  void dispose() {
    _flowCtrl.dispose();
    _pulseCtrl.dispose();
    _rotateTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tint = widget.tint ?? const Color(0xFF6941C6);
    final parsed = widget.items.map(_ArtifactItem.fromMap).toList();
    if (parsed.isEmpty) {
      parsed.add(
        const _ArtifactItem(
          type: 'No artifacts',
          icon: '📄',
          color: Color(0xFFE8EDF5),
        ),
      );
    }
    if (_selected >= parsed.length) {
      _selected = 0;
    }

    return ShowcaseCard(
      title: widget.title,
      description: widget.description,
      tint: tint,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact =
              constraints.maxWidth < 310 || constraints.maxHeight < 300;
          final stripWidth = compact ? 58.0 : 72.0;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SummaryRow(
                total: parsed.length,
                selected: parsed[_selected].type,
                isDark: isDark,
                tint: tint,
                compact: compact,
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      width: stripWidth,
                      child: AnimatedBuilder(
                        animation: _flowCtrl,
                        builder: (_, _) => _ExtractorStrip(
                          flowT: _flowCtrl.value,
                          pulseT: _pulseCtrl.value,
                          tint: tint,
                          isDark: isDark,
                          compact: compact,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView.separated(
                              physics: const BouncingScrollPhysics(),
                              itemCount: parsed.length,
                              separatorBuilder: (_, _) =>
                                  SizedBox(height: compact ? 5 : 7),
                              itemBuilder: (context, index) {
                                final item = parsed[index];
                                final active = index == _selected;
                                return _ArtifactCard(
                                  item: item,
                                  active: active,
                                  isDark: isDark,
                                  compact: compact,
                                  onTap: () =>
                                      setState(() => _selected = index),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: compact ? 74 : 96,
                            child: _ArtifactPreviewPanel(
                              item: parsed[_selected],
                              isDark: isDark,
                              compact: compact,
                            ),
                          ),
                        ],
                      ),
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

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.total,
    required this.selected,
    required this.isDark,
    required this.tint,
    required this.compact,
  });

  final int total;
  final String selected;
  final bool isDark;
  final Color tint;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final left = _StatChip(
      label: 'Extracted',
      value: '$total',
      color: tint,
      isDark: isDark,
    );
    final right = _StatChip(
      label: 'Focus',
      value: selected,
      color: const Color(0xFF0D7A5F),
      isDark: isDark,
    );

    if (compact) {
      return Wrap(spacing: 6, runSpacing: 6, children: [left, right]);
    }

    return Row(
      children: [
        left,
        const SizedBox(width: 6),
        Expanded(child: right),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.18 : 0.1),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.28)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: ',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: color,
              fontSize: 9,
            ),
          ),
          Text(
            value,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: color,
              fontSize: 9.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExtractorStrip extends StatelessWidget {
  const _ExtractorStrip({
    required this.flowT,
    required this.pulseT,
    required this.tint,
    required this.isDark,
    required this.compact,
  });

  final double flowT;
  final double pulseT;
  final Color tint;
  final bool isDark;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 4 : 6,
        vertical: compact ? 6 : 8,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0B1324) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
      ),
      child: CustomPaint(
        painter: _ExtractorStripPainter(
          flowT: flowT,
          pulseT: pulseT,
          tint: tint,
          isDark: isDark,
        ),
      ),
    );
  }
}

class _ExtractorStripPainter extends CustomPainter {
  const _ExtractorStripPainter({
    required this.flowT,
    required this.pulseT,
    required this.tint,
    required this.isDark,
  });

  final double flowT;
  final double pulseT;
  final Color tint;
  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final x = size.width / 2;
    final top = 12.0;
    final bottom = size.height - 12.0;

    canvas.drawLine(
      Offset(x, top),
      Offset(x, bottom),
      Paint()
        ..color = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)
        ..strokeWidth = 2,
    );

    final y1 = size.height * 0.2;
    final y2 = size.height * 0.5;
    final y3 = size.height * 0.8;
    for (final y in [y1, y2, y3]) {
      canvas.drawCircle(
        Offset(x, y),
        8,
        Paint()
          ..color = tint.withValues(alpha: 0.2)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
      );
      canvas.drawCircle(
        Offset(x, y),
        4.5,
        Paint()..color = tint.withValues(alpha: 0.95),
      );
    }

    final py = top + (bottom - top) * flowT;
    canvas.drawCircle(
      Offset(x, py),
      7,
      Paint()
        ..color = tint.withValues(alpha: 0.25)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );
    canvas.drawCircle(Offset(x, py), 3.2, Paint()..color = tint);

    final pulseR = 9 + pulseT * 4;
    canvas.drawCircle(
      Offset(x, y2),
      pulseR,
      Paint()
        ..color = tint.withValues(alpha: 0.1)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
  }

  @override
  bool shouldRepaint(covariant _ExtractorStripPainter old) {
    return old.flowT != flowT || old.pulseT != pulseT || old.isDark != isDark;
  }
}

class _ArtifactCard extends StatelessWidget {
  const _ArtifactCard({
    required this.item,
    required this.active,
    required this.isDark,
    required this.compact,
    required this.onTap,
  });

  final _ArtifactItem item;
  final bool active;
  final bool isDark;
  final bool compact;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(
          vertical: compact ? 7 : 8,
          horizontal: compact ? 9 : 11,
        ),
        decoration: BoxDecoration(
          color: item.color.withValues(
            alpha: active ? (isDark ? 0.2 : 0.34) : 0.2,
          ),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: item.color.withValues(alpha: active ? 0.7 : 0.3),
            width: active ? 1.2 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(item.icon, style: TextStyle(fontSize: compact ? 15 : 17)),
            const SizedBox(width: 9),
            Expanded(
              child: Text(
                item.type,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: active ? FontWeight.w800 : FontWeight.w600,
                  color: isDark
                      ? const Color(0xFFE2E8F0)
                      : const Color(0xFF0F1C2E),
                  fontSize: compact ? 11 : 12,
                ),
              ),
            ),
            const SizedBox(width: 6),
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: active ? 8 : 6,
              height: active ? 8 : 6,
              decoration: BoxDecoration(
                color: item.color,
                shape: BoxShape.circle,
                boxShadow: active
                    ? [
                        BoxShadow(
                          color: item.color.withValues(alpha: 0.55),
                          blurRadius: 8,
                        ),
                      ]
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ArtifactPreviewPanel extends StatelessWidget {
  const _ArtifactPreviewPanel({
    required this.item,
    required this.isDark,
    required this.compact,
  });

  final _ArtifactItem item;
  final bool isDark;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final t = item.type.toLowerCase();
    Widget visual;

    if (t.contains('registry')) {
      visual = _RegistryPreview(
        isDark: isDark,
        color: item.color,
        compact: compact,
      );
    } else if (t.contains('pe section')) {
      visual = _PeSectionPreview(
        isDark: isDark,
        color: item.color,
        compact: compact,
      );
    } else if (t.contains('binary signature')) {
      visual = _SignaturePreview(
        isDark: isDark,
        color: item.color,
        compact: compact,
      );
    } else if (t.contains('extracted string')) {
      visual = _StringPreview(
        isDark: isDark,
        color: item.color,
        compact: compact,
      );
    } else if (t.contains('event record')) {
      visual = _EventPreview(
        isDark: isDark,
        color: item.color,
        compact: compact,
      );
    } else if (t.contains('sticky bit')) {
      visual = _StickyBitPreview(
        isDark: isDark,
        color: item.color,
        compact: compact,
      );
    } else {
      visual = _TimestampPreview(
        isDark: isDark,
        color: item.color,
        compact: compact,
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical: compact ? 6 : 8,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0B1324) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.type,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontSize: compact ? 9 : 9.5,
              fontWeight: FontWeight.w800,
              color: item.color,
            ),
          ),
          const SizedBox(height: 6),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 240),
              reverseDuration: const Duration(milliseconds: 180),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              layoutBuilder: (currentChild, previousChildren) {
                return Stack(
                  alignment: Alignment.centerLeft,
                  children: [...previousChildren, ?currentChild],
                );
              },
              transitionBuilder: (child, animation) {
                final offsetTween = Tween<Offset>(
                  begin: const Offset(0.04, 0),
                  end: Offset.zero,
                );
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: offsetTween.animate(animation),
                    child: child,
                  ),
                );
              },
              child: KeyedSubtree(key: ValueKey(item.type), child: visual),
            ),
          ),
        ],
      ),
    );
  }
}

class _RegistryPreview extends StatelessWidget {
  const _RegistryPreview({
    required this.isDark,
    required this.color,
    required this.compact,
  });
  final bool isDark;
  final Color color;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? const Color(0xFF0F172A) : Colors.white;
    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(compact ? 4 : 6),
              child: Text(
                'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Run',
                maxLines: compact ? 1 : 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontSize: compact ? 7.2 : 8,
                  color: isDark
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF64748B),
                ),
              ),
            ),
          ),
          Container(width: 1, color: color.withValues(alpha: 0.2)),
          Expanded(
            child: Container(
              margin: EdgeInsets.all(compact ? 3 : 4),
              padding: EdgeInsets.symmetric(
                horizontal: compact ? 4 : 6,
                vertical: compact ? 3 : 4,
              ),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                'Updater = "C:\\Users\\Public\\updater.exe"',
                maxLines: compact ? 1 : 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontSize: compact ? 7.2 : 8,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PeSectionPreview extends StatelessWidget {
  const _PeSectionPreview({
    required this.isDark,
    required this.color,
    required this.compact,
  });
  final bool isDark;
  final Color color;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    Widget bar(String label, double w, bool active) {
      return Container(
        height: compact ? 7 : 9,
        width: double.infinity,
        decoration: BoxDecoration(
          color: active
              ? color.withValues(alpha: 0.75)
              : color.withValues(alpha: isDark ? 0.24 : 0.2),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(widthFactor: w, child: Container()),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          '.text',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            fontSize: compact ? 7 : 8,
            color: color,
          ),
        ),
        bar('.text', 0.88, true),
        Text(
          '.rdata',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            fontSize: compact ? 7 : 8,
            color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
          ),
        ),
        bar('.rdata', 0.62, false),
        Text(
          '.data',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            fontSize: compact ? 7 : 8,
            color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
          ),
        ),
        bar('.data', 0.41, false),
      ],
    );
  }
}

class _SignaturePreview extends StatelessWidget {
  const _SignaturePreview({
    required this.isDark,
    required this.color,
    required this.compact,
  });
  final bool isDark;
  final Color color;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    Widget byte(String b, {bool hit = false}) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: compact ? 4 : 5, vertical: 2),
        decoration: BoxDecoration(
          color: hit
              ? color.withValues(alpha: 0.24)
              : (isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: hit ? color.withValues(alpha: 0.55) : Colors.transparent,
          ),
        ),
        child: Text(
          b,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            fontSize: compact ? 7 : 8,
            fontWeight: FontWeight.w700,
            color: hit
                ? color
                : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
          ),
        ),
      );
    }

    return Wrap(
      spacing: compact ? 3 : 4,
      runSpacing: compact ? 3 : 4,
      children: [
        byte('4D'),
        byte('5A'),
        byte('90'),
        byte('00', hit: true),
        byte('03', hit: true),
        byte('00', hit: true),
        byte('00'),
        byte('00'),
        byte('50', hit: true),
        byte('45', hit: true),
      ],
    );
  }
}

class _StringPreview extends StatelessWidget {
  const _StringPreview({
    required this.isDark,
    required this.color,
    required this.compact,
  });
  final bool isDark;
  final Color color;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6 : 8,
        vertical: compact ? 5 : 6,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: color.withValues(alpha: 0.28)),
      ),
      child: RichText(
        maxLines: compact ? 1 : 2,
        overflow: TextOverflow.ellipsis,
        text: TextSpan(
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            fontSize: compact ? 7.5 : 8.5,
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
          ),
          children: [
            const TextSpan(text: '"POST /api/v1/'),
            TextSpan(
              text: 'beacon',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w800,
                backgroundColor: color.withValues(alpha: 0.15),
              ),
            ),
            const TextSpan(text: '?id=7f4a..."'),
          ],
        ),
      ),
    );
  }
}

class _EventPreview extends StatelessWidget {
  const _EventPreview({
    required this.isDark,
    required this.color,
    required this.compact,
  });
  final bool isDark;
  final Color color;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6 : 8,
        vertical: compact ? 5 : 6,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Wrap(
        spacing: 6,
        runSpacing: 4,
        alignment: WrapAlignment.spaceBetween,
        children: [
          Text(
            'EventID 4688',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontSize: compact ? 7.5 : 8.5,
              fontWeight: FontWeight.w700,
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: compact ? 4 : 5,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'process_start',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontSize: compact ? 7 : 8,
                color: color,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StickyBitPreview extends StatelessWidget {
  const _StickyBitPreview({
    required this.isDark,
    required this.color,
    required this.compact,
  });
  final bool isDark;
  final Color color;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6 : 8,
        vertical: compact ? 5 : 6,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Wrap(
        spacing: 4,
        runSpacing: 4,
        children: [
          Text(
            '-rwxrwxr',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontSize: compact ? 8 : 9,
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
              fontWeight: FontWeight.w700,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 1),
            padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(3),
            ),
            child: Text(
              't',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontSize: compact ? 8 : 9,
                color: color,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Text(
            '/tmp/drop/',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontSize: compact ? 7.5 : 8.5,
              color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimestampPreview extends StatelessWidget {
  const _TimestampPreview({
    required this.isDark,
    required this.color,
    required this.compact,
  });
  final bool isDark;
  final Color color;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6 : 8,
        vertical: compact ? 5 : 6,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Icon(Icons.schedule_rounded, size: compact ? 11 : 13, color: color),
          SizedBox(width: compact ? 4 : 6),
          Expanded(
            child: Text(
              '2026-05-10 14:21:33.504 UTC',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontSize: compact ? 7.5 : 8.5,
                fontWeight: FontWeight.w700,
                color: isDark
                    ? const Color(0xFF94A3B8)
                    : const Color(0xFF64748B),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
