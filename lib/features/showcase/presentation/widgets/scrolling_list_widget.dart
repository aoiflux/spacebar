import 'package:flutter/material.dart';
import 'package:spacebar/features/showcase/presentation/widgets/showcase_card.dart';

class _ArtifactItem {
  const _ArtifactItem({
    required this.type,
    required this.icon,
    required this.color,
    required this.detail,
  });

  final String type;
  final String icon;
  final Color color;
  final String detail;

  factory _ArtifactItem.fromMap(Map<String, dynamic> map) {
    final type = map['type'] as String? ?? 'Item';
    final detail = (map['detail'] as String?)?.trim();
    return _ArtifactItem(
      type: type,
      icon: map['icon'] as String? ?? '📄',
      color: Color(map['color'] as int? ?? 0xFFE8EDF5),
      detail: detail == null || detail.isEmpty
          ? _artifactDetailFor(type)
          : detail,
    );
  }
}

String _artifactDetailFor(String type) {
  final normalized = type.toLowerCase();
  if (normalized.contains('event record')) {
    return 'Process or system activity timeline entry';
  }
  if (normalized.contains('registry')) {
    return 'Persistent key/value configuration artifact';
  }
  if (normalized.contains('extracted string')) {
    return 'Decoded text candidate from binary payload';
  }
  if (normalized.contains('pe section')) {
    return 'Portable Executable segment fingerprint';
  }
  if (normalized.contains('binary signature')) {
    return 'Byte-pattern match used for detection';
  }
  if (normalized.contains('sticky bit')) {
    return 'Flagged marker retained for triage context';
  }
  if (normalized.contains('timestamp')) {
    return 'Time-based indicator for sequence analysis';
  }
  return 'Low-level extracted artifact for investigation';
}

Color _readableAccent(Color base, {required bool isDark}) {
  final hsl = HSLColor.fromColor(base);
  final saturation = (hsl.saturation + 0.32).clamp(0.42, 0.9).toDouble();
  final lightness = isDark ? 0.68 : 0.34;
  return hsl.withSaturation(saturation).withLightness(lightness).toColor();
}

List<_ArtifactItem> _buildArtifactItems(List<Map<String, dynamic>> source) {
  final items = source.map(_ArtifactItem.fromMap).toList();
  if (items.isNotEmpty) {
    return items;
  }

  return const [
    _ArtifactItem(
      type: 'No artifacts',
      icon: '📄',
      color: Color(0xFFE8EDF5),
      detail: 'No extracted artifacts are currently available',
    ),
  ];
}

class _ArtifactLayout {
  const _ArtifactLayout({
    required this.expandedDialog,
    required this.compact,
    required this.spacious,
    required this.reducedMotion,
    required this.stripWidth,
    required this.previewHeight,
    required this.showPreview,
    required this.tightHeight,
    required this.queueGap,
    required this.sectionGap,
  });

  final bool compact;
  final bool spacious;
  final bool expandedDialog;
  final bool reducedMotion;
  final double stripWidth;
  final double previewHeight;
  final bool showPreview;
  final bool tightHeight;
  final double queueGap;
  final double sectionGap;

  factory _ArtifactLayout.fromConstraints(
    BoxConstraints constraints, {
    required bool isExpandedDialog,
  }) {
    final compact = constraints.maxWidth < 310 || constraints.maxHeight < 300;
    final spacious =
        constraints.maxWidth >= 520 && constraints.maxHeight >= 360;
    final reducedMotion = isExpandedDialog;
    final tightHeight = constraints.maxHeight < 220;

    return _ArtifactLayout(
      expandedDialog: isExpandedDialog,
      compact: compact,
      spacious: spacious,
      reducedMotion: reducedMotion,
      stripWidth: compact ? 58.0 : (tightHeight ? 62.0 : 72.0),
      previewHeight: compact ? 90.0 : (spacious ? 168.0 : 132.0),
      showPreview: constraints.maxHeight >= 200,
      tightHeight: tightHeight,
      queueGap: tightHeight ? 4.0 : 6.0,
      sectionGap: tightHeight ? 4.0 : 8.0,
    );
  }

  bool get effectiveCompact => compact || tightHeight;
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
  bool _stripAnimationsRunning = false;
  int _selected = 0;

  void _setStripAnimationsRunning(bool shouldRun) {
    if (_stripAnimationsRunning == shouldRun) {
      return;
    }
    _stripAnimationsRunning = shouldRun;

    if (shouldRun) {
      if (!_flowCtrl.isAnimating) {
        _flowCtrl.repeat();
      }
      if (!_pulseCtrl.isAnimating) {
        _pulseCtrl.repeat(reverse: true);
      }
      return;
    }

    if (_flowCtrl.isAnimating) {
      _flowCtrl.stop(canceled: false);
    }
    if (_pulseCtrl.isAnimating) {
      _pulseCtrl.stop(canceled: false);
    }
  }

  @override
  void initState() {
    super.initState();
    _flowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );
    _setStripAnimationsRunning(true);
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
    final parsed = _buildArtifactItems(widget.items);
    final selectedIndex = _selected.clamp(0, parsed.length - 1);
    final stripAnimation = Listenable.merge([_flowCtrl, _pulseCtrl]);

    return ShowcaseCard(
      title: widget.title,
      description: widget.description,
      tint: tint,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isExpandedDialog = ShowcaseExpansionScope.of(context);
          final layout = _ArtifactLayout.fromConstraints(
            constraints,
            isExpandedDialog: isExpandedDialog,
          );
          _setStripAnimationsRunning(!layout.reducedMotion);

          return _ArtifactWorkspace(
            items: parsed,
            selectedIndex: selectedIndex,
            isDark: isDark,
            tint: tint,
            layout: layout,
            stripAnimation: stripAnimation,
            flowT: _flowCtrl.value,
            pulseT: _pulseCtrl.value,
            onSelect: (index) => setState(() => _selected = index),
          );
        },
      ),
    );
  }
}

class _ArtifactWorkspace extends StatelessWidget {
  const _ArtifactWorkspace({
    required this.items,
    required this.selectedIndex,
    required this.isDark,
    required this.tint,
    required this.layout,
    required this.stripAnimation,
    required this.flowT,
    required this.pulseT,
    required this.onSelect,
  });

  final List<_ArtifactItem> items;
  final int selectedIndex;
  final bool isDark;
  final Color tint;
  final _ArtifactLayout layout;
  final Listenable stripAnimation;
  final double flowT;
  final double pulseT;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final selectedItem = items[selectedIndex];

    if (layout.expandedDialog) {
      return _ExpandedArtifactWorkspace(
        items: items,
        selectedIndex: selectedIndex,
        selectedItem: selectedItem,
        isDark: isDark,
        onSelect: onSelect,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SummaryRow(
          total: items.length,
          selected: selectedItem.type,
          isDark: isDark,
          tint: tint,
          compact: layout.compact,
        ),
        const SizedBox(height: 8),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: layout.stripWidth,
                child: _ArtifactStripPanel(
                  animate: !layout.reducedMotion,
                  animation: stripAnimation,
                  flowT: flowT,
                  pulseT: pulseT,
                  tint: tint,
                  isDark: isDark,
                  compact: layout.compact,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: RepaintBoundary(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SectionCaption(
                        title: 'Artifact Queue',
                        subtitle: 'Tap any row to inspect details',
                        compact: layout.effectiveCompact,
                        isDark: isDark,
                        subtitleMaxLines: layout.tightHeight ? 1 : 2,
                      ),
                      SizedBox(height: layout.queueGap),
                      Expanded(
                        child: ListView.separated(
                          physics: layout.reducedMotion
                              ? const ClampingScrollPhysics()
                              : const BouncingScrollPhysics(),
                          itemCount: items.length,
                          separatorBuilder: (_, _) =>
                              SizedBox(height: layout.effectiveCompact ? 4 : 6),
                          itemBuilder: (context, index) {
                            final item = items[index];
                            final isActive = index == selectedIndex;
                            return _ArtifactCard(
                              item: item,
                              active: isActive,
                              isDark: isDark,
                              compact: layout.effectiveCompact,
                              spacious: layout.spacious,
                              reducedMotion: layout.reducedMotion,
                              onTap: () => onSelect(index),
                            );
                          },
                        ),
                      ),
                      if (layout.showPreview) ...[
                        SizedBox(height: layout.sectionGap),
                        _SectionCaption(
                          title: 'Selected Artifact Preview',
                          subtitle: selectedItem.detail,
                          compact: layout.effectiveCompact,
                          isDark: isDark,
                          subtitleMaxLines: layout.tightHeight
                              ? 1
                              : (layout.spacious ? 3 : 2),
                        ),
                        SizedBox(height: layout.queueGap),
                        Flexible(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight: layout.previewHeight,
                            ),
                            child: _ArtifactPreviewPanel(
                              item: selectedItem,
                              isDark: isDark,
                              compact: layout.effectiveCompact,
                              spacious: layout.spacious,
                              reducedMotion: layout.reducedMotion,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ExpandedArtifactWorkspace extends StatelessWidget {
  const _ExpandedArtifactWorkspace({
    required this.items,
    required this.selectedIndex,
    required this.selectedItem,
    required this.isDark,
    required this.onSelect,
  });

  final List<_ArtifactItem> items;
  final int selectedIndex;
  final _ArtifactItem selectedItem;
  final bool isDark;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          width: 280,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionCaption(
                title: 'Artifact Queue',
                subtitle: '${items.length} items',
                compact: false,
                isDark: isDark,
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.separated(
                  physics: const ClampingScrollPhysics(),
                  itemCount: items.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 6),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final active = index == selectedIndex;
                    return _ArtifactCard(
                      item: item,
                      active: active,
                      isDark: isDark,
                      compact: false,
                      spacious: true,
                      reducedMotion: true,
                      onTap: () => onSelect(index),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionCaption(
                title: 'Selected Artifact Preview',
                subtitle: selectedItem.detail,
                compact: false,
                isDark: isDark,
                subtitleMaxLines: 2,
              ),
              const SizedBox(height: 8),
              Expanded(
                child: _ArtifactPreviewPanel(
                  item: selectedItem,
                  isDark: isDark,
                  compact: false,
                  spacious: true,
                  reducedMotion: true,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ArtifactStripPanel extends StatelessWidget {
  const _ArtifactStripPanel({
    required this.animate,
    required this.animation,
    required this.flowT,
    required this.pulseT,
    required this.tint,
    required this.isDark,
    required this.compact,
  });

  final bool animate;
  final Listenable animation;
  final double flowT;
  final double pulseT;
  final Color tint;
  final bool isDark;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: animate
          ? AnimatedBuilder(
              animation: animation,
              builder: (_, _) => _ExtractorStrip(
                flowT: flowT,
                pulseT: pulseT,
                tint: tint,
                isDark: isDark,
                compact: compact,
              ),
            )
          : _ExtractorStrip(
              flowT: 0.5,
              pulseT: 0.25,
              tint: tint,
              isDark: isDark,
              compact: compact,
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
      label: 'Artifacts',
      value: '$total',
      color: tint,
      isDark: isDark,
      expand: false,
    );
    final right = _StatChip(
      label: 'Selected',
      value: selected,
      color: const Color(0xFF0D7A5F),
      isDark: isDark,
      expand: true,
    );

    if (compact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [left, const SizedBox(height: 6), right],
      );
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
    required this.expand,
  });

  final String label;
  final String value;
  final Color color;
  final bool isDark;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: expand ? double.infinity : null,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.18 : 0.1),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.28)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            '$label: ',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: color,
              fontSize: 11,
            ),
          ),
          Expanded(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: color,
                fontSize: 11.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCaption extends StatelessWidget {
  const _SectionCaption({
    required this.title,
    required this.subtitle,
    required this.compact,
    required this.isDark,
    this.subtitleMaxLines = 1,
  });

  final String title;
  final String subtitle;
  final bool compact;
  final bool isDark;
  final int subtitleMaxLines;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            fontSize: compact ? 10.5 : 11.5,
            fontWeight: FontWeight.w800,
            color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF0F172A),
          ),
        ),
        Text(
          subtitle,
          maxLines: subtitleMaxLines,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            fontSize: compact ? 9.2 : 10.2,
            fontWeight: FontWeight.w600,
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
          ),
        ),
      ],
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final targetHeight = compact ? 150.0 : 220.0;
        final stripHeight = constraints.maxHeight < targetHeight
            ? constraints.maxHeight
            : targetHeight;

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
          child: Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              height: stripHeight,
              width: double.infinity,
              child: CustomPaint(
                painter: _ExtractorStripPainter(
                  flowT: flowT,
                  pulseT: pulseT,
                  tint: tint,
                  isDark: isDark,
                ),
              ),
            ),
          ),
        );
      },
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
    required this.spacious,
    required this.reducedMotion,
    required this.onTap,
  });

  final _ArtifactItem item;
  final bool active;
  final bool isDark;
  final bool compact;
  final bool spacious;
  final bool reducedMotion;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = _readableAccent(item.color, isDark: isDark);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: reducedMotion
            ? Duration.zero
            : const Duration(milliseconds: 220),
        curve: reducedMotion ? Curves.linear : Curves.easeOutCubic,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.type,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: active ? FontWeight.w800 : FontWeight.w700,
                      color: isDark
                          ? const Color(0xFFE2E8F0)
                          : const Color(0xFF0F1C2E),
                      fontSize: compact ? 11.2 : (spacious ? 13.0 : 12.4),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.detail,
                    maxLines: spacious ? 2 : 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF64748B),
                      fontSize: compact ? 9.2 : (spacious ? 10.6 : 10),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: compact ? 4 : 6),
            if (active && !compact)
              Container(
                margin: const EdgeInsets.only(right: 4),
                padding: EdgeInsets.symmetric(
                  horizontal: compact ? 4 : 5,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: item.color.withValues(alpha: isDark ? 0.28 : 0.34),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  'ACTIVE',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontSize: compact ? 7 : 8,
                    letterSpacing: 0.4,
                    fontWeight: FontWeight.w800,
                    color: accent,
                  ),
                ),
              ),
            AnimatedContainer(
              duration: reducedMotion
                  ? Duration.zero
                  : const Duration(milliseconds: 220),
              width: active ? 8 : 6,
              height: active ? 8 : 6,
              decoration: BoxDecoration(
                color: item.color,
                shape: BoxShape.circle,
                boxShadow: active && !reducedMotion
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
    required this.spacious,
    required this.reducedMotion,
  });

  final _ArtifactItem item;
  final bool isDark;
  final bool compact;
  final bool spacious;
  final bool reducedMotion;

  @override
  Widget build(BuildContext context) {
    final t = item.type.toLowerCase();
    final accent = _readableAccent(item.color, isDark: isDark);
    Widget visual;

    if (t.contains('registry')) {
      visual = _RegistryPreview(
        isDark: isDark,
        color: accent,
        compact: compact,
      );
    } else if (t.contains('pe section')) {
      visual = _PeSectionPreview(
        isDark: isDark,
        color: accent,
        compact: compact,
      );
    } else if (t.contains('binary signature')) {
      visual = _SignaturePreview(
        isDark: isDark,
        color: accent,
        compact: compact,
      );
    } else if (t.contains('extracted string')) {
      visual = _StringPreview(isDark: isDark, color: accent, compact: compact);
    } else if (t.contains('event record')) {
      visual = _EventPreview(isDark: isDark, color: accent, compact: compact);
    } else if (t.contains('sticky bit')) {
      visual = _StickyBitPreview(
        isDark: isDark,
        color: accent,
        compact: compact,
      );
    } else {
      visual = _TimestampPreview(
        isDark: isDark,
        color: accent,
        compact: compact,
      );
    }

    return LayoutBuilder(
      builder: (context, panelConstraints) {
        final tinyPanel = panelConstraints.maxHeight < 72;
        final densePanel = panelConstraints.maxHeight < 180;
        final verticalPadding = tinyPanel ? 4.0 : (compact ? 8.0 : 10.0);

        Widget headerRow() {
          return Row(
            children: [
              Text(item.icon, style: TextStyle(fontSize: compact ? 14 : 16)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Preview: ${item.type}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontSize: compact ? 11 : (spacious ? 13.2 : 12.4),
                    fontWeight: FontWeight.w800,
                    color: accent,
                  ),
                ),
              ),
            ],
          );
        }

        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 9 : 11,
            vertical: verticalPadding,
          ),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0A1221) : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isDark
                  ? accent.withValues(alpha: 0.7)
                  : accent.withValues(alpha: 0.45),
              width: 1.2,
            ),
          ),
          child: tinyPanel
              ? Align(alignment: Alignment.centerLeft, child: headerRow())
              : densePanel
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    headerRow(),
                    const SizedBox(height: 3),
                    Text(
                      item.detail,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontSize: compact ? 9.2 : 10,
                        height: 1.2,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? const Color(0xFFCBD5E1)
                            : const Color(0xFF475569),
                      ),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    headerRow(),
                    const SizedBox(height: 4),
                    Text(
                      item.detail,
                      maxLines: compact ? 2 : (spacious ? 4 : 3),
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontSize: compact ? 9.6 : (spacious ? 11.2 : 10.6),
                        height: 1.25,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? const Color(0xFFCBD5E1)
                            : const Color(0xFF475569),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: compact ? 6 : 8,
                          vertical: compact ? 5 : 6,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF0F172A)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: accent.withValues(alpha: 0.42),
                          ),
                        ),
                        child: reducedMotion
                            ? KeyedSubtree(
                                key: ValueKey(item.type),
                                child: visual,
                              )
                            : AnimatedSwitcher(
                                duration: const Duration(milliseconds: 240),
                                reverseDuration: const Duration(
                                  milliseconds: 180,
                                ),
                                switchInCurve: Curves.easeOutCubic,
                                switchOutCurve: Curves.easeInCubic,
                                layoutBuilder:
                                    (currentChild, previousChildren) {
                                      return Stack(
                                        alignment: Alignment.centerLeft,
                                        children: [
                                          ...previousChildren,
                                          ?currentChild,
                                        ],
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
                                child: KeyedSubtree(
                                  key: ValueKey(item.type),
                                  child: visual,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
        );
      },
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
                  fontSize: compact ? 8.2 : 9,
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
                  fontSize: compact ? 8.2 : 9,
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
    Widget bar(double w, bool active, bool dense) {
      return Container(
        height: dense ? 5 : (compact ? 7 : 9),
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

    return LayoutBuilder(
      builder: (context, constraints) {
        final dense = compact || constraints.maxHeight <= 44;
        final labelHeight = dense ? 8.0 : 11.0;
        final labelFontSize = dense ? 7.0 : (compact ? 8.0 : 9.0);
        final spacer = dense ? 1.0 : 2.0;

        Widget label(String text, Color textColor) {
          return SizedBox(
            height: labelHeight,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.clip,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontSize: labelFontSize,
                  height: 1,
                  color: textColor,
                ),
              ),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            label('.text', color),
            SizedBox(height: spacer),
            bar(0.88, true, dense),
            SizedBox(height: spacer),
            label(
              '.rdata',
              isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
            ),
            SizedBox(height: spacer),
            bar(0.62, false, dense),
            SizedBox(height: spacer),
            label(
              '.data',
              isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
            ),
            SizedBox(height: spacer),
            bar(0.41, false, dense),
          ],
        );
      },
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
            fontSize: compact ? 8.2 : 9,
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
            fontSize: compact ? 8.6 : 9.6,
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
              fontSize: compact ? 8.6 : 9.6,
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
                fontSize: compact ? 8 : 9,
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
              fontSize: compact ? 8.8 : 9.8,
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
                fontSize: compact ? 8.8 : 9.8,
                color: color,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Text(
            '/tmp/drop/',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontSize: compact ? 8.4 : 9.4,
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
                fontSize: compact ? 8.6 : 9.6,
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
