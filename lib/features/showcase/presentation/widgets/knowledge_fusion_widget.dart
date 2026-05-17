import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:spacebar/features/showcase/presentation/widgets/showcase_card.dart';

class _ForensicPalette {
  static const Color primary = Color(0xFF4A90E2);
  static const Color secondary = Color(0xFF50E3C2);
  static const Color accent = Color(0xFFF5A623);
  static const Color backgroundDark = Color(0xFF0D1117);
  static const Color backgroundLight = Color(0xFFF7F9FC);
  static const Color cardSurface = Color(0xFF1C2128);
  static const Color graphLine = Color(0x4050E3C2);
  static const Color darkTextPrimary = Color(0xFFF3F7FC);
  static const Color darkTextSecondary = Color(0xFFC8D5E6);
  static const Color darkTextMuted = Color(0xFF9FB1C8);
  static const Color lightTextPrimary = Color(0xFF10253C);
  static const Color lightTextSecondary = Color(0xFF34506D);
  static const Color lightTextMuted = Color(0xFF5D7894);
}

class KnowledgeFusionWidget extends StatefulWidget {
  const KnowledgeFusionWidget({
    super.key,
    required this.title,
    required this.description,
    this.tint,
  });

  final String title;
  final String description;
  final Color? tint;

  @override
  State<KnowledgeFusionWidget> createState() => _KnowledgeFusionWidgetState();
}

class _KnowledgeFusionWidgetState extends State<KnowledgeFusionWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _motionCtrl;
  bool _motionRunning = false;

  void _setMotionRunning(bool shouldRun) {
    if (_motionRunning == shouldRun) {
      return;
    }
    _motionRunning = shouldRun;
    if (shouldRun) {
      _motionCtrl.repeat();
      return;
    }
    _motionCtrl.stop(canceled: false);
  }

  @override
  void initState() {
    super.initState();
    _motionCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    );
    _setMotionRunning(true);
  }

  @override
  void dispose() {
    _motionCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isExpanded = ShowcaseExpansionScope.of(context);
    _setMotionRunning(!isExpanded);
    final phase = _motionCtrl.value;

    return ShowcaseCard(
      title: widget.title,
      description: widget.description,
      tint: widget.tint,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 900;
          final gap = compact ? 10.0 : 14.0;
          final visualHeight = compact ? 78.0 : 94.0;
          final animate = !isExpanded;

          return Stack(
            children: [
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(
                    painter: _BackplanePainter(
                      phase: phase,
                      isDark: Theme.of(context).brightness == Brightness.dark,
                      showEdges: isExpanded,
                    ),
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: _FeatureColumn(
                      compact: compact,
                      icon: Icons.account_tree_rounded,
                      accentColor: _ForensicPalette.primary,
                      title: 'Enrichment Engine',
                      subtitle:
                          'Evidence -> Partition -> Indexed File (leaf actual file)',
                      accents: const [
                        'Hierarchy first',
                        'Indexed file is leaf',
                        'One path = one indexed file',
                      ],
                      signals: const [
                        _SignalDatum('path', '/users/a.bin', 0.9),
                        _SignalDatum('hash', 'sha256:2b..9f', 0.86),
                        _SignalDatum('mime', 'application/pdf', 0.78),
                        _SignalDatum('flags', 'deleted=false', 0.72),
                      ],
                      stages: const [
                        'Evidence node discovered',
                        'Partition attached to evidence',
                        'Indexed file attached to partition (leaf)',
                        'Indexed file stores size, entropy, mime, tags, flags',
                      ],
                      visualHeight: visualHeight,
                      visual: _EnrichmentVisual(
                        animation: _motionCtrl,
                        phase: phase,
                        animate: animate,
                      ),
                      phase: phase,
                      animate: animate,
                      isExpanded: isExpanded,
                    ),
                  ),
                  SizedBox(width: gap),
                  VerticalDivider(
                    width: 1,
                    thickness: 1,
                    color: Theme.of(
                      context,
                    ).dividerColor.withValues(alpha: 0.55),
                  ),
                  SizedBox(width: gap),
                  Expanded(
                    child: _FeatureColumn(
                      compact: compact,
                      icon: Icons.hub_rounded,
                      accentColor: _ForensicPalette.secondary,
                      title: 'Micro-Artefact Intelligence',
                      subtitle: 'Important signals are inside file content',
                      accents: const [
                        'Content snippets',
                        'Token highlights',
                        'Evidence-first extraction',
                      ],
                      signals: const [
                        _SignalDatum('url hit', 'https://x.io', 0.81),
                        _SignalDatum('registry', 'Run\\Updater', 0.76),
                        _SignalDatum('task', 'schtasks /create', 0.64),
                        _SignalDatum('ioc score', '0.84', 0.84),
                      ],
                      stages: const [
                        'Open file content stream',
                        'Detect meaningful text patterns',
                        'Extract snippets with context offsets',
                        'Persist artefacts linked to source file',
                      ],
                      visualHeight: visualHeight,
                      visual: _MicroArtefactVisual(
                        animation: _motionCtrl,
                        phase: phase,
                        animate: animate,
                      ),
                      phase: phase,
                      animate: animate,
                      isExpanded: isExpanded,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _FeatureColumn extends StatelessWidget {
  const _FeatureColumn({
    required this.compact,
    required this.icon,
    required this.accentColor,
    required this.title,
    required this.subtitle,
    required this.accents,
    required this.signals,
    required this.stages,
    required this.visualHeight,
    required this.visual,
    required this.phase,
    required this.animate,
    required this.isExpanded,
  });

  final bool compact;
  final IconData icon;
  final Color accentColor;
  final String title;
  final String subtitle;
  final List<String> accents;
  final List<_SignalDatum> signals;
  final List<String> stages;
  final double visualHeight;
  final Widget visual;
  final double phase;
  final bool animate;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final titleColor = isDark
        ? _ForensicPalette.darkTextPrimary
        : _ForensicPalette.lightTextPrimary;
    final subtitleColor = isDark
        ? _ForensicPalette.darkTextSecondary
        : _ForensicPalette.lightTextSecondary;
    final metaColor = isDark
        ? _ForensicPalette.darkTextMuted
        : _ForensicPalette.lightTextMuted;

    return LayoutBuilder(
      builder: (context, constraints) {
        final tightHeight = constraints.maxHeight < 300;
        final veryTightHeight = constraints.maxHeight < 255;
        final resolvedVisualHeight = veryTightHeight
            ? 54.0
            : (tightHeight ? 66.0 : visualHeight);
        final stageCount = veryTightHeight
            ? 1
            : (tightHeight ? 2 : stages.length);
        final subtitleLines = veryTightHeight ? 1 : (isExpanded ? 3 : 2);
        final sectionGap = veryTightHeight ? 4.0 : 8.0;
        final compactVisualHeight = veryTightHeight
            ? 34.0
            : (tightHeight ? 42.0 : 54.0);

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isDark
                ? _ForensicPalette.cardSurface.withValues(alpha: 0.76)
                : Colors.white.withValues(alpha: 0.8),
            border: Border.all(
              color: accentColor.withValues(alpha: isExpanded ? 0.45 : 0.2),
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                      _ForensicPalette.cardSurface.withValues(alpha: 0.92),
                      _ForensicPalette.backgroundDark.withValues(alpha: 0.84),
                    ]
                  : [
                      Colors.white,
                      _ForensicPalette.backgroundLight.withValues(alpha: 0.84),
                    ],
            ),
            boxShadow: [
              BoxShadow(
                color: accentColor.withValues(alpha: isDark ? 0.12 : 0.08),
                blurRadius: isExpanded ? 22 : 12,
                spreadRadius: isExpanded ? 1 : 0,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          padding: EdgeInsets.all(veryTightHeight ? 8 : 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 3,
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  gradient: LinearGradient(
                    colors: [
                      accentColor.withValues(alpha: 0.9),
                      accentColor.withValues(alpha: 0.15),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  AnimatedRotation(
                    turns: isExpanded ? 0.25 : 0.0,
                    duration: const Duration(milliseconds: 280),
                    curve: Curves.easeInOutCubic,
                    child: Icon(icon, size: 16, color: accentColor),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: compact ? 14 : 15,
                        color: titleColor,
                        height: 1.1,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                maxLines: subtitleLines,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: subtitleColor,
                  fontSize: compact ? 12 : 13,
                  height: 1.42,
                  fontFamily: 'JetBrainsMono',
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: sectionGap),
              Expanded(
                child: isExpanded
                    ? _ExpandedCapabilityBody(
                        compact: compact,
                        isDark: isDark,
                        accents: accents,
                        signals: signals,
                        stages: stages,
                        stageCount: stageCount,
                        phase: phase,
                        animate: animate,
                        visualHeight: resolvedVisualHeight,
                        visual: visual,
                        sectionGap: sectionGap,
                      )
                    : _CompactCapabilityBody(
                        compact: compact,
                        visual: visual,
                        visualHeight: compactVisualHeight,
                        signals: signals,
                        isDark: isDark,
                        accentColor: accentColor,
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ExpandedCapabilityBody extends StatelessWidget {
  const _ExpandedCapabilityBody({
    required this.compact,
    required this.isDark,
    required this.accents,
    required this.signals,
    required this.stages,
    required this.stageCount,
    required this.phase,
    required this.animate,
    required this.visualHeight,
    required this.visual,
    required this.sectionGap,
  });

  final bool compact;
  final bool isDark;
  final List<String> accents;
  final List<_SignalDatum> signals;
  final List<String> stages;
  final int stageCount;
  final double phase;
  final bool animate;
  final double visualHeight;
  final Widget visual;
  final double sectionGap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final showAccents = accents.isNotEmpty;
    final showSignals = signals.isNotEmpty;
    final chipTextColor = isDark
        ? _ForensicPalette.darkTextPrimary
        : _ForensicPalette.lightTextPrimary;

    return RepaintBoundary(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: visualHeight, child: visual),
          if (showAccents) ...[
            SizedBox(height: sectionGap),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: accents
                  .map(
                    (label) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF122034)
                            : const Color(0xFFE8F1FB),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: isDark
                              ? const Color(0xFF3B5574)
                              : const Color(0xFFB8D0EB),
                        ),
                      ),
                      child: Text(
                        label,
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: compact ? 10.5 : 11,
                          color: chipTextColor,
                        ),
                      ),
                    ),
                  )
                  .toList(growable: false),
            ),
          ],
          if (showSignals) ...[
            SizedBox(height: sectionGap),
            _SignalGrid(
              compact: compact,
              signals: signals,
              phase: phase,
              animate: animate,
            ),
          ],
          SizedBox(height: sectionGap),
          Expanded(
            child: ListView.separated(
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: stageCount,
              separatorBuilder: (_, _) => SizedBox(height: compact ? 3 : 4),
              itemBuilder: (context, index) {
                return _StageRow(
                  label: stages[index],
                  compact: compact,
                  isDark: isDark,
                  phase: phase,
                  index: index,
                  animate: animate,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CompactCapabilityBody extends StatelessWidget {
  const _CompactCapabilityBody({
    required this.compact,
    required this.visual,
    required this.visualHeight,
    required this.signals,
    required this.isDark,
    required this.accentColor,
  });

  final bool compact;
  final Widget visual;
  final double visualHeight;
  final List<_SignalDatum> signals;
  final bool isDark;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final quickSignals = signals.take(2).toList(growable: false);
    final signalLabelColor = isDark
        ? _ForensicPalette.darkTextMuted
        : _ForensicPalette.lightTextMuted;
    final signalValueColor = isDark
        ? _ForensicPalette.darkTextPrimary
        : _ForensicPalette.lightTextPrimary;

    return SizedBox.expand(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: accentColor.withValues(alpha: 0.24)),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [
                          accentColor.withValues(alpha: 0.12),
                          const Color(0x00000000),
                        ]
                      : [
                          accentColor.withValues(alpha: 0.08),
                          Colors.white.withValues(alpha: 0.28),
                        ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: accentColor.withValues(alpha: isDark ? 0.18 : 0.08),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    visual,
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            (isDark ? const Color(0xFF0B1220) : Colors.white)
                                .withValues(alpha: 0.18),
                            (isDark ? const Color(0xFF0B1220) : Colors.white)
                                .withValues(alpha: 0.82),
                          ],
                          stops: const [0.0, 0.55, 1.0],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 10,
                      right: 10,
                      bottom: 10,
                      child: Row(
                        children: [
                          ...quickSignals.map(
                            (signal) => Expanded(
                              child: Container(
                                margin: EdgeInsets.only(
                                  right: signal == quickSignals.last ? 0 : 6,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 7,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color:
                                      (isDark
                                              ? const Color(0xFF101A2B)
                                              : Colors.white)
                                          .withValues(alpha: 0.86),
                                  border: Border.all(
                                    color: accentColor.withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      signal.label,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: theme.textTheme.labelSmall
                                          ?.copyWith(
                                            fontSize: compact ? 9.5 : 10,
                                            fontWeight: FontWeight.w700,
                                            color: signalLabelColor,
                                          ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      signal.value,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            fontSize: compact ? 10.5 : 11.5,
                                            fontFamily: 'JetBrainsMono',
                                            fontWeight: FontWeight.w800,
                                            color: signalValueColor,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.88),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: accentColor.withValues(alpha: 0.35),
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Expand for full forensic view',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontSize: compact ? 10.5 : 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                    color: isDark
                        ? _ForensicPalette.darkTextSecondary
                        : _ForensicPalette.lightTextSecondary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BackplanePainter extends CustomPainter {
  const _BackplanePainter({
    required this.phase,
    required this.isDark,
    required this.showEdges,
  });

  final double phase;
  final bool isDark;
  final bool showEdges;

  @override
  void paint(Canvas canvas, Size size) {
    if (!showEdges) {
      return;
    }
    final edgePaint = Paint()
      ..color = _ForensicPalette.graphLine.withValues(
        alpha: isDark ? 0.34 : 0.2,
      )
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke;

    final y = size.height * 0.52;
    final start = Offset(size.width * 0.12, y);
    final mid = Offset(size.width * 0.5, y - 10);
    final end = Offset(size.width * 0.88, y + 6);

    final p = Path()
      ..moveTo(start.dx, start.dy)
      ..quadraticBezierTo(mid.dx, mid.dy, end.dx, end.dy);
    canvas.drawPath(p, edgePaint);

    final t = (phase * 1.3) % 1.0;
    final marker = Offset.lerp(start, end, t)!;
    canvas.drawCircle(
      marker,
      2.8,
      Paint()..color = _ForensicPalette.secondary.withValues(alpha: 0.75),
    );
  }

  @override
  bool shouldRepaint(covariant _BackplanePainter oldDelegate) {
    return oldDelegate.phase != phase ||
        oldDelegate.isDark != isDark ||
        oldDelegate.showEdges != showEdges;
  }
}

class _SignalDatum {
  const _SignalDatum(this.label, this.value, this.baseProgress);

  final String label;
  final String value;
  final double baseProgress;
}

class _SignalGrid extends StatelessWidget {
  const _SignalGrid({
    required this.compact,
    required this.signals,
    required this.phase,
    required this.animate,
  });

  final bool compact;
  final List<_SignalDatum> signals;
  final double phase;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final labelColor = isDark
        ? _ForensicPalette.darkTextSecondary
        : _ForensicPalette.lightTextSecondary;
    final valueColor = isDark
        ? _ForensicPalette.darkTextPrimary
        : _ForensicPalette.lightTextPrimary;

    return SizedBox(
      height: compact ? 70 : 80,
      child: GridView.builder(
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: signals.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 6,
          crossAxisSpacing: 6,
          childAspectRatio: 2.85,
        ),
        itemBuilder: (_, index) {
          final datum = signals[index];
          final wave = 0.07 * math.sin((phase * 2 * math.pi) + index * 0.9);
          final progress = animate
              ? (datum.baseProgress + wave).clamp(0.0, 1.0)
              : datum.baseProgress;

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF142338) : const Color(0xFFEAF3FE),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isDark
                    ? const Color(0xFF3D5A79)
                    : const Color(0xFFBFD6ED),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        datum.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontSize: compact ? 10 : 10.5,
                          fontWeight: FontWeight.w700,
                          color: labelColor,
                        ),
                      ),
                    ),
                    Text(
                      datum.value,
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: compact ? 10.5 : 11,
                        color: valueColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    minHeight: 4,
                    value: progress,
                    backgroundColor: isDark
                        ? const Color(0xFF2A3B53)
                        : const Color(0xFFD2E3F3),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isDark
                          ? Color.lerp(
                              const Color(0xFF8EC7FF),
                              _ForensicPalette.accent,
                              0.22,
                            )!
                          : const Color(0xFF2D79C6),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StageRow extends StatelessWidget {
  const _StageRow({
    required this.label,
    required this.compact,
    required this.isDark,
    required this.phase,
    required this.index,
    required this.animate,
  });

  final String label;
  final bool compact;
  final bool isDark;
  final double phase;
  final int index;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final beat = animate
        ? (0.45 + 0.55 * (0.5 + 0.5 * math.sin((phase * 2 * math.pi) + index)))
        : 0.72;
    final dotColor = Color.lerp(
      isDark ? const Color(0xFF466588) : const Color(0xFF86AFD8),
      isDark ? const Color(0xFF9ED0FF) : const Color(0xFF2A6FB1),
      beat,
    )!;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 3),
          child: Container(
            width: compact ? 10 : 11,
            height: compact ? 10 : 11,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: dotColor.withValues(alpha: 0.35),
                  blurRadius: animate ? 6 : 2,
                  spreadRadius: animate ? 0.5 : 0,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            label,
            maxLines: compact ? 1 : 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: compact ? 11.5 : 12.5,
              height: 1.38,
              fontWeight: FontWeight.w500,
              color: isDark
                  ? _ForensicPalette.darkTextSecondary
                  : _ForensicPalette.lightTextSecondary,
            ),
          ),
        ),
      ],
    );
  }
}

class _EnrichmentVisual extends StatelessWidget {
  const _EnrichmentVisual({
    required this.animation,
    required this.phase,
    required this.animate,
  });

  final Listenable animation;
  final double phase;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fixedPhase = animate ? phase : 0.42;

    if (!animate) {
      return RepaintBoundary(
        child: CustomPaint(
          painter: _EnrichmentPainter(isDark: isDark, phase: fixedPhase),
          child: const SizedBox.expand(),
        ),
      );
    }

    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: animation,
        builder: (_, _) {
          return CustomPaint(
            painter: _EnrichmentPainter(isDark: isDark, phase: fixedPhase),
            child: const SizedBox.expand(),
          );
        },
      ),
    );
  }
}

class _MicroArtefactVisual extends StatelessWidget {
  const _MicroArtefactVisual({
    required this.animation,
    required this.phase,
    required this.animate,
  });

  final Listenable animation;
  final double phase;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fixedPhase = animate ? phase : 0.56;

    if (!animate) {
      return RepaintBoundary(
        child: CustomPaint(
          painter: _MicroArtefactPainter(isDark: isDark, phase: fixedPhase),
          child: const SizedBox.expand(),
        ),
      );
    }

    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: animation,
        builder: (_, _) {
          return CustomPaint(
            painter: _MicroArtefactPainter(isDark: isDark, phase: fixedPhase),
            child: const SizedBox.expand(),
          );
        },
      ),
    );
  }
}

class _EnrichmentPainter extends CustomPainter {
  const _EnrichmentPainter({required this.isDark, required this.phase});

  final bool isDark;
  final double phase;

  @override
  void paint(Canvas canvas, Size size) {
    final base = RRect.fromRectAndRadius(
      Offset.zero & size,
      const Radius.circular(12),
    );
    canvas.drawRRect(
      base,
      Paint()
        ..color = isDark ? const Color(0xFF121D2B) : const Color(0xFFEFF6FE),
    );

    for (var i = 0; i < 3; i++) {
      final layerTop = size.height * (0.38 + i * 0.08);
      final layer = RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.31, layerTop, size.width * 0.22, 8),
        const Radius.circular(4),
      );
      canvas.drawRRect(
        layer,
        Paint()
          ..color = (isDark ? const Color(0xFF36506D) : const Color(0xFFC6D9EC))
              .withValues(alpha: 0.72 - (i * 0.12)),
      );
    }

    final edgePaint = Paint()
      ..color = isDark ? const Color(0xFF4C6483) : const Color(0xFF9CB7D5)
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round;
    final nodeFill = Paint()
      ..color = isDark ? const Color(0xFF1F324B) : const Color(0xFFDDEBFA);
    final nodeStroke = Paint()
      ..color = isDark ? const Color(0xFF5A789C) : const Color(0xFFA7C4E1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final nodes = [
      Rect.fromLTWH(
        size.width * 0.05,
        size.height * 0.16,
        size.width * 0.22,
        16,
      ),
      Rect.fromLTWH(
        size.width * 0.32,
        size.height * 0.16,
        size.width * 0.22,
        16,
      ),
      Rect.fromLTWH(
        size.width * 0.59,
        size.height * 0.16,
        size.width * 0.22,
        16,
      ),
      Rect.fromLTWH(
        size.width * 0.77,
        size.height * 0.41,
        size.width * 0.18,
        18,
      ),
    ];
    const labels = ['EVIDENCE', 'PARTITION', 'INDEXED FILE'];

    for (var i = 0; i < 2; i++) {
      final y = nodes[i].center.dy;
      final start = Offset(nodes[i].right, y);
      final end = Offset(nodes[i + 1].left - 4, y);
      final mid = Offset((start.dx + end.dx) / 2, y);
      canvas.drawLine(start, mid, edgePaint);
      canvas.drawLine(mid, end, edgePaint);
    }

    for (var i = 0; i < 3; i++) {
      final rr = RRect.fromRectAndRadius(nodes[i], const Radius.circular(6));
      if (i == 2) {
        for (var sheet = 0; sheet < 3; sheet++) {
          final shadowRect = RRect.fromRectAndRadius(
            nodes[i].shift(Offset(-sheet * 3.0, sheet * 2.0)),
            const Radius.circular(6),
          );
          canvas.drawRRect(
            shadowRect,
            Paint()
              ..color =
                  (isDark ? const Color(0xFF1A283D) : const Color(0xFFD7E8F8))
                      .withValues(alpha: 0.45 - (sheet * 0.1)),
          );
        }
      }
      canvas.drawRRect(rr, nodeFill);
      canvas.drawRRect(rr, nodeStroke);
      _paintText(
        canvas,
        labels[i],
        Offset(nodes[i].left + 5, nodes[i].top + 3),
        TextStyle(
          color: isDark ? const Color(0xFFD1E4F9) : const Color(0xFF254A70),
          fontSize: i == 2 ? 7.6 : 8.5,
          fontWeight: FontWeight.w800,
        ),
      );
    }

    final attrs = ['size', 'mime', 'entropy', 'tags', 'is_deleted'];
    for (var i = 0; i < attrs.length; i++) {
      final chip = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.06 + i * (size.width * 0.17),
          size.height * 0.63,
          size.width * 0.145,
          14,
        ),
        const Radius.circular(7),
      );
      canvas.drawRRect(
        chip,
        Paint()
          ..color = isDark ? const Color(0xFF20334B) : const Color(0xFFD9E9FA),
      );
      _paintText(
        canvas,
        attrs[i],
        Offset(chip.left + 6, chip.top + 2.5),
        TextStyle(
          color: isDark ? const Color(0xFFBBD2EE) : const Color(0xFF315577),
          fontSize: 8,
          fontWeight: FontWeight.w700,
        ),
      );
    }

    final pulse = (phase * 1.35) % 1.0;
    final pulseX = size.width * (0.07 + 0.83 * pulse);
    canvas.drawCircle(
      Offset(pulseX, size.height * 0.52),
      3.6,
      Paint()
        ..color = isDark ? const Color(0xFF82C4FF) : const Color(0xFF236DB4),
    );
  }

  @override
  bool shouldRepaint(covariant _EnrichmentPainter oldDelegate) {
    return oldDelegate.phase != phase || oldDelegate.isDark != isDark;
  }
}

class _MicroArtefactPainter extends CustomPainter {
  const _MicroArtefactPainter({required this.isDark, required this.phase});

  final bool isDark;
  final double phase;

  @override
  void paint(Canvas canvas, Size size) {
    final base = RRect.fromRectAndRadius(
      Offset.zero & size,
      const Radius.circular(12),
    );
    canvas.drawRRect(
      base,
      Paint()
        ..color = isDark ? const Color(0xFF171A2E) : const Color(0xFFF1F0FF),
    );

    final sheet = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.04,
        size.height * 0.1,
        size.width * 0.92,
        size.height * 0.78,
      ),
      const Radius.circular(8),
    );
    canvas.drawRRect(
      sheet,
      Paint()
        ..color = isDark ? const Color(0xFF232742) : const Color(0xFFFFFFFF),
    );

    final lineColor = isDark
        ? const Color(0xFF59608A)
        : const Color(0xFFC2CBE2);
    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 1.5;
    for (var i = 0; i < 6; i++) {
      final y = size.height * (0.2 + i * 0.1);
      canvas.drawLine(
        Offset(size.width * 0.08, y),
        Offset(size.width * 0.9, y),
        linePaint,
      );
    }

    final highlights = [
      Rect.fromLTWH(size.width * 0.28, size.height * 0.19, size.width * 0.2, 8),
      Rect.fromLTWH(
        size.width * 0.46,
        size.height * 0.39,
        size.width * 0.24,
        8,
      ),
      Rect.fromLTWH(size.width * 0.18, size.height * 0.59, size.width * 0.3, 8),
    ];
    for (var i = 0; i < highlights.length; i++) {
      final glow = (0.58 + 0.42 * math.sin((phase * 2 * math.pi) + i * 1.3))
          .clamp(0.0, 1.0);
      final nodeCenter = Offset(
        highlights[i].right + 18,
        highlights[i].center.dy,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(highlights[i], const Radius.circular(4)),
        Paint()
          ..color = Color.lerp(
            isDark ? const Color(0xFF5660D6) : const Color(0xFFAAB8FF),
            isDark ? const Color(0xFF9DA7FF) : const Color(0xFF6E80F5),
            glow,
          )!.withValues(alpha: 0.9),
      );
      canvas.drawLine(
        Offset(highlights[i].right, highlights[i].center.dy),
        nodeCenter,
        Paint()
          ..color =
              (isDark ? _ForensicPalette.secondary : const Color(0xFF41CBB0))
                  .withValues(alpha: 0.35)
          ..strokeWidth = 1.2,
      );
      canvas.drawCircle(
        nodeCenter,
        4.5,
        Paint()
          ..color =
              (isDark ? _ForensicPalette.secondary : const Color(0xFF41CBB0))
                  .withValues(alpha: 0.35 + (glow * 0.4)),
      );
      canvas.drawCircle(
        nodeCenter,
        2.2,
        Paint()
          ..color = isDark ? const Color(0xFFB7FFF0) : const Color(0xFF157A67),
      );
    }

    final scanX = size.width * (0.08 + 0.8 * ((phase * 1.15) % 1.0));
    canvas.drawLine(
      Offset(scanX, size.height * 0.15),
      Offset(scanX, size.height * 0.84),
      Paint()
        ..color = (isDark ? const Color(0xFFA4AEFF) : const Color(0xFF5E71ED))
            .withValues(alpha: 0.65)
        ..strokeWidth = 1.4,
    );

    _paintText(
      canvas,
      'file content',
      Offset(size.width * 0.07, size.height * 0.11),
      TextStyle(
        color: isDark ? const Color(0xFFC6CBF7) : const Color(0xFF4F5CB2),
        fontSize: 9,
        fontWeight: FontWeight.w800,
      ),
    );
    _paintText(
      canvas,
      'highlighted snippets -> artefacts',
      Offset(size.width * 0.44, size.height * 0.82),
      TextStyle(
        color: isDark ? const Color(0xFFC6CBF7) : const Color(0xFF4F5CB2),
        fontSize: 8,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant _MicroArtefactPainter oldDelegate) {
    return oldDelegate.phase != phase || oldDelegate.isDark != isDark;
  }
}

void _paintText(Canvas canvas, String text, Offset offset, TextStyle style) {
  final painter = TextPainter(
    text: TextSpan(text: text, style: style),
    textDirection: TextDirection.ltr,
  )..layout();
  painter.paint(canvas, offset);
}
