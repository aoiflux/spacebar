import 'dart:async';

import 'package:flutter/material.dart';
import 'package:spacebar/features/showcase/presentation/widgets/showcase_card.dart';

// ─── Static pipeline stage definitions ───────────────────────────────────────

class _PipeStage {
  const _PipeStage(this.label, this.icon, this.stat, this.unit, this.color);
  final String label;
  final IconData icon;
  final String stat;
  final String unit;
  final Color color;
}

const _kStages = [
  _PipeStage(
    'Dedupe',
    Icons.filter_none_rounded,
    '2.1 M',
    'blocks',
    Color(0xFF3B82F6),
  ),
  _PipeStage(
    'Carve',
    Icons.content_cut_rounded,
    '847',
    'files',
    Color(0xFF10B981),
  ),
  _PipeStage(
    'Parse',
    Icons.account_tree_rounded,
    '312',
    'artefacts',
    Color(0xFF8B5CF6),
  ),
  _PipeStage(
    'Index',
    Icons.bolt_rounded,
    '2.4 M',
    'entries',
    Color(0xFF0B57D0),
  ),
];

// ─── Detected file entries ────────────────────────────────────────────────────

class _DetectedFile {
  const _DetectedFile(this.path, this.type, this.size, this.icon, this.color);
  final String path;
  final String type;
  final String size;
  final IconData icon;
  final Color color;
}

const _kDetectedFiles = [
  _DetectedFile(
    '/Cases/2024-INV/disk_image.E01',
    'Disk Image',
    '3.1 GB',
    Icons.storage_rounded,
    Color(0xFF3B82F6),
  ),
  _DetectedFile(
    '/Cases/2024-INV/mem_dump.dmp',
    'Memory Dump',
    '16.0 GB',
    Icons.memory_rounded,
    Color(0xFF8B5CF6),
  ),
  _DetectedFile(
    '/Capture/net_20240510.pcap',
    'Packet Capture',
    '824 MB',
    Icons.wifi_rounded,
    Color(0xFF10B981),
  ),
];

// ─── Widget ───────────────────────────────────────────────────────────────────

class WatcherPipelineWidget extends StatefulWidget {
  final String title;
  final String description;
  final Map<String, dynamic> mockData;
  final Color? tint;

  const WatcherPipelineWidget({
    super.key,
    required this.title,
    required this.description,
    required this.mockData,
    this.tint,
  });

  @override
  State<WatcherPipelineWidget> createState() => _WatcherPipelineWidgetState();
}

class _WatcherPipelineWidgetState extends State<WatcherPipelineWidget>
    with TickerProviderStateMixin {
  // Radar scan ring
  late final AnimationController _scanCtrl;
  // Pipeline flow particles
  late final AnimationController _flowCtrl;
  // Heartbeat pulse on the status dot
  late final AnimationController _beatCtrl;

  // Which file is "newest" / highlighted
  int _latestFile = 0;
  // Which pipeline stage the active item is currently "at"
  int _activeStage = 0;

  Timer? _feedTimer;
  Timer? _stageTimer;

  @override
  void initState() {
    super.initState();

    _scanCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();

    _flowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();

    _beatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    // Cycle which file is "latest" every 3 s
    _feedTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (mounted) {
        setState(() {
          _latestFile = (_latestFile + 1) % _kDetectedFiles.length;
        });
      }
    });

    // Advance the "active" stage token every 1.4 s (in sync with flow)
    _stageTimer = Timer.periodic(const Duration(milliseconds: 1400), (_) {
      if (mounted) {
        setState(() {
          _activeStage = (_activeStage + 1) % _kStages.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _scanCtrl.dispose();
    _flowCtrl.dispose();
    _beatCtrl.dispose();
    _feedTimer?.cancel();
    _stageTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tint = widget.tint ?? const Color(0xFF0B57D0);
    final status = widget.mockData['status'] as String? ?? 'inactive';
    final newItems = widget.mockData['newItems'] as int? ?? 0;
    final lastScan = widget.mockData['lastScan'] as String? ?? 'N/A';
    final active = status.toLowerCase() == 'active';

    return ShowcaseCard(
      title: widget.title,
      description: widget.description,
      tint: tint,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compactHeight = constraints.maxHeight < 245;
          final compactWidth = constraints.maxWidth < 330;
          final gap = compactHeight ? 8.0 : 10.0;
          final feedHeight = compactHeight ? 92.0 : 108.0;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Status bar ─────────────────────────────────────────────
              _StatusBar(
                active: active,
                newItems: newItems,
                lastScan: lastScan,
                beatCtrl: _beatCtrl,
                tint: tint,
                isDark: isDark,
                compact: compactWidth,
              ),
              SizedBox(height: gap),

              // ── Watcher feed + radar ───────────────────────────────────
              SizedBox(
                height: feedHeight,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Radar orb
                    AspectRatio(
                      aspectRatio: 1,
                      child: AnimatedBuilder(
                        animation: _scanCtrl,
                        builder: (_, __) => _RadarOrb(
                          scanT: _scanCtrl.value,
                          tint: tint,
                          isDark: isDark,
                          fileCount: _kDetectedFiles.length,
                        ),
                      ),
                    ),
                    SizedBox(width: compactWidth ? 8 : 10),
                    // Detected files list
                    Expanded(
                      child: _DetectionFeed(
                        files: _kDetectedFiles,
                        latestIndex: _latestFile,
                        isDark: isDark,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: gap),

              // ── Processing pipeline ─────────────────────────────────────
              Expanded(
                child: AnimatedBuilder(
                  animation: _flowCtrl,
                  builder: (_, __) => _PipelineRail(
                    flowT: _flowCtrl.value,
                    activeStage: _activeStage,
                    isDark: isDark,
                    compact: compactHeight,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ─── Status bar ───────────────────────────────────────────────────────────────

class _StatusBar extends StatelessWidget {
  const _StatusBar({
    required this.active,
    required this.newItems,
    required this.lastScan,
    required this.beatCtrl,
    required this.tint,
    required this.isDark,
    required this.compact,
  });

  final bool active;
  final int newItems;
  final String lastScan;
  final AnimationController beatCtrl;
  final Color tint;
  final bool isDark;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF10B981);
    if (compact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AnimatedBuilder(
                animation: beatCtrl,
                builder: (_, __) => Container(
                  width: 9,
                  height: 9,
                  decoration: BoxDecoration(
                    color: active ? green : const Color(0xFF94A3B8),
                    shape: BoxShape.circle,
                    boxShadow: active
                        ? [
                            BoxShadow(
                              color: green.withValues(alpha: 
                                0.3 + 0.3 * beatCtrl.value,
                              ),
                              blurRadius: 8,
                              spreadRadius: beatCtrl.value * 3,
                            ),
                          ]
                        : null,
                  ),
                ),
              ),
              const SizedBox(width: 7),
              Text(
                active ? 'Watcher Running' : 'Watcher Idle',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 10.5,
                  color: active ? green : const Color(0xFF64748B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _Chip('+$newItems detected', tint),
              _Chip('scan $lastScan', const Color(0xFF7C3AED)),
            ],
          ),
        ],
      );
    }

    return Row(
      children: [
        AnimatedBuilder(
          animation: beatCtrl,
          builder: (_, __) => Container(
            width: 9,
            height: 9,
            decoration: BoxDecoration(
              color: active ? green : const Color(0xFF94A3B8),
              shape: BoxShape.circle,
              boxShadow: active
                  ? [
                      BoxShadow(
                        color: green.withValues(alpha: 0.3 + 0.3 * beatCtrl.value),
                        blurRadius: 8,
                        spreadRadius: beatCtrl.value * 3,
                      ),
                    ]
                  : null,
            ),
          ),
        ),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            active ? 'Watcher Running' : 'Watcher Idle',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w800,
              fontSize: 10.5,
              color: active ? green : const Color(0xFF64748B),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 6),
        Flexible(child: _Chip('+$newItems detected', tint)),
        const SizedBox(width: 6),
        Flexible(child: _Chip('scan $lastScan', const Color(0xFF7C3AED))),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip(this.label, this.color);
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.28)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

// ─── Radar orb ────────────────────────────────────────────────────────────────

class _RadarOrb extends StatelessWidget {
  const _RadarOrb({
    required this.scanT,
    required this.tint,
    required this.isDark,
    required this.fileCount,
  });

  final double scanT;
  final Color tint;
  final bool isDark;
  final int fileCount;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _RadarPainter(
        scanT: scanT,
        tint: tint,
        isDark: isDark,
        fileCount: fileCount,
      ),
    );
  }
}

class _RadarPainter extends CustomPainter {
  const _RadarPainter({
    required this.scanT,
    required this.tint,
    required this.isDark,
    required this.fileCount,
  });

  final double scanT;
  final Color tint;
  final bool isDark;
  final int fileCount;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2 - 4;

    // Concentric rings
    for (final frac in [0.35, 0.65, 1.0]) {
      canvas.drawCircle(
        Offset(cx, cy),
        r * frac,
        Paint()
          ..color = tint.withValues(alpha: isDark ? 0.12 : 0.08)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );
    }

    // Crosshairs
    final crossPaint = Paint()
      ..color = tint.withValues(alpha: 0.12)
      ..strokeWidth = 0.8;
    canvas.drawLine(Offset(cx, cy - r), Offset(cx, cy + r), crossPaint);
    canvas.drawLine(Offset(cx - r, cy), Offset(cx + r, cy), crossPaint);

    // Sweep gradient fill (pie slice)
    final sweepAngle = 1.8; // radians
    final startAngle = scanT * 2 * 3.14159265 - sweepAngle;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r),
      startAngle,
      sweepAngle,
      true,
      Paint()
        ..shader = SweepGradient(
          colors: [tint.withValues(alpha: 0.0), tint.withValues(alpha: 0.22)],
          startAngle: 0,
          endAngle: sweepAngle,
          transform: GradientRotation(startAngle),
        ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: r)),
    );

    // Scan leading edge
    final edgeX = cx + r * _cos(scanT * 2 * 3.14159265);
    final edgeY = cy + r * _sin(scanT * 2 * 3.14159265);
    canvas.drawLine(
      Offset(cx, cy),
      Offset(edgeX, edgeY),
      Paint()
        ..color = tint.withValues(alpha: 0.7)
        ..strokeWidth = 1.5
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
    );

    // Static blip dots for detected files
    for (int i = 0; i < fileCount; i++) {
      final angle = (i / fileCount) * 2 * 3.14159265 + 0.6;
      final dist = r * (0.4 + i * 0.18);
      final bx = cx + dist * _cos(angle);
      final by = cy + dist * _sin(angle);
      canvas.drawCircle(
        Offset(bx, by),
        3.5,
        Paint()
          ..color = tint.withValues(alpha: 0.18)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
      );
      canvas.drawCircle(Offset(bx, by), 1.8, Paint()..color = tint);
    }

    // Center dot
    canvas.drawCircle(
      Offset(cx, cy),
      4,
      Paint()
        ..color = tint.withValues(alpha: 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );
    canvas.drawCircle(Offset(cx, cy), 2, Paint()..color = tint);
  }

  double _cos(double radians) => _sinTable(
    radians - 3.14159265 / 2,
  ); // cos(x) = sin(x + π/2)... use dart:math
  double _sin(double radians) => _sinTable(radians);

  // Simple sin approximation using dart:math via import
  double _sinTable(double r) {
    // Use actual sin/cos from dart:math would be cleaner but we can't import here
    // Approximation: use the Taylor series or just rely on the fact we already import nothing
    // Actually we CAN just use dart:math — but we need to call it differently
    // We'll compute via the identity: sin(x) ≈ x - x³/6 + x⁵/120 works for small x
    // Better: use a lookup via mod
    // Just implement directly:
    final x = r % (2 * 3.14159265359);
    // Bhaskara I approximation (good to 0.1% error)
    // sin(x) for x in [0, π]: 16x(π-x)/(5π²-4x(π-x))
    const pi = 3.14159265359;
    final xn = x < 0 ? x + 2 * pi : x;
    if (xn <= pi) {
      final num = 16 * xn * (pi - xn);
      final den = 5 * pi * pi - 4 * xn * (pi - xn);
      return num / den;
    } else {
      final xp = xn - pi;
      final num = 16 * xp * (pi - xp);
      final den = 5 * pi * pi - 4 * xp * (pi - xp);
      return -(num / den);
    }
  }

  @override
  bool shouldRepaint(covariant _RadarPainter old) =>
      old.scanT != scanT || old.isDark != isDark;
}

// ─── Detection feed ───────────────────────────────────────────────────────────

class _DetectionFeed extends StatelessWidget {
  const _DetectionFeed({
    required this.files,
    required this.latestIndex,
    required this.isDark,
  });

  final List<_DetectedFile> files;
  final int latestIndex;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0B1324) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact =
              constraints.maxWidth < 165 || constraints.maxHeight < 84;
          return ListView.separated(
            padding: EdgeInsets.zero,
            itemCount: files.length,
            physics: const BouncingScrollPhysics(),
            separatorBuilder: (_, __) => SizedBox(height: compact ? 3 : 4),
            itemBuilder: (context, i) {
              final f = files[i];
              final isLatest = i == latestIndex;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutCubic,
                padding: EdgeInsets.symmetric(
                  horizontal: compact ? 6 : 7,
                  vertical: compact ? 2 : 3,
                ),
                decoration: BoxDecoration(
                  color: isLatest
                      ? f.color.withValues(alpha: isDark ? 0.14 : 0.08)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                  border: isLatest
                      ? Border.all(color: f.color.withValues(alpha: 0.3))
                      : Border.all(color: Colors.transparent),
                ),
                child: Row(
                  children: [
                    Icon(
                      f.icon,
                      size: compact ? 11 : 12,
                      color: f.color.withValues(alpha: isLatest ? 1.0 : 0.4),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            f.path.split('/').last,
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  fontSize: compact ? 8.8 : 9.5,
                                  fontWeight: FontWeight.w700,
                                  color: isLatest
                                      ? (isDark
                                            ? const Color(0xFFE2E8F0)
                                            : const Color(0xFF0F172A))
                                      : (isDark
                                            ? const Color(0xFF475569)
                                            : const Color(0xFF94A3B8)),
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (!compact)
                            Text(
                              '${f.type}  ·  ${f.size}',
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    fontSize: 8.5,
                                    color: isDark
                                        ? const Color(0xFF334155)
                                        : const Color(0xFFCBD5E1),
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),
                    if (isLatest && !compact)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: f.color,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'NEW',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                fontSize: 7.5,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                        ),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// ─── Pipeline rail ────────────────────────────────────────────────────────────

class _PipelineRail extends StatelessWidget {
  const _PipelineRail({
    required this.flowT,
    required this.activeStage,
    required this.isDark,
    required this.compact,
  });

  final double flowT;
  final int activeStage;
  final bool isDark;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final iconActive = compact ? 32.0 : 38.0;
    final iconIdle = compact ? 26.0 : 30.0;
    final labelSize = compact ? 8.2 : 9.0;
    final statSize = compact ? 8.8 : 9.5;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6 : 8,
        vertical: compact ? 6 : 8,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0B1324) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label row
          Row(
            children: [
              Icon(
                Icons.play_arrow_rounded,
                size: 11,
                color: isDark
                    ? const Color(0xFF475569)
                    : const Color(0xFF94A3B8),
              ),
              const SizedBox(width: 4),
              Text(
                'Processing pipeline',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? const Color(0xFF475569)
                      : const Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
          SizedBox(height: compact ? 4 : 6),
          // Stage row + connector canvas
          Expanded(
            child: Stack(
              children: [
                // Flow connectors + particles
                Positioned.fill(
                  child: CustomPaint(
                    painter: _PipePainter(
                      count: _kStages.length,
                      activeStage: activeStage,
                      colors: _kStages.map((s) => s.color).toList(),
                      flowT: flowT,
                      isDark: isDark,
                      connectorY: iconActive / 2,
                    ),
                  ),
                ),
                // Stage columns
                Row(
                  children: List.generate(_kStages.length, (i) {
                    final s = _kStages[i];
                    final isActive = i == activeStage;
                    return Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeOutCubic,
                            width: isActive ? iconActive : iconIdle,
                            height: isActive ? iconActive : iconIdle,
                            decoration: BoxDecoration(
                              color: isActive
                                  ? s.color
                                  : s.color.withValues(alpha: isDark ? 0.12 : 0.08),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: s.color.withValues(alpha: 
                                  isActive ? 1.0 : 0.3,
                                ),
                                width: isActive ? 2.0 : 1.2,
                              ),
                              boxShadow: isActive
                                  ? [
                                      BoxShadow(
                                        color: s.color.withValues(alpha: 0.4),
                                        blurRadius: 14,
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Icon(
                              s.icon,
                              size: isActive
                                  ? (compact ? 16 : 18)
                                  : (compact ? 12 : 14),
                              color: isActive
                                  ? Colors.white
                                  : s.color.withValues(alpha: 0.7),
                            ),
                          ),
                          SizedBox(height: compact ? 2 : 4),
                          Text(
                            s.label,
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  fontSize: labelSize,
                                  fontWeight: isActive
                                      ? FontWeight.w800
                                      : FontWeight.w600,
                                  color: isActive
                                      ? s.color
                                      : (isDark
                                            ? const Color(0xFF475569)
                                            : const Color(0xFF94A3B8)),
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            s.stat,
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  fontSize: statSize,
                                  fontWeight: FontWeight.w800,
                                  color: isActive
                                      ? (isDark
                                            ? const Color(0xFFE2E8F0)
                                            : const Color(0xFF0F172A))
                                      : (isDark
                                            ? const Color(0xFF334155)
                                            : const Color(0xFFCBD5E1)),
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (!compact)
                            Text(
                              s.unit,
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    fontSize: 8,
                                    color: isDark
                                        ? const Color(0xFF334155)
                                        : const Color(0xFFCBD5E1),
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PipePainter extends CustomPainter {
  const _PipePainter({
    required this.count,
    required this.activeStage,
    required this.colors,
    required this.flowT,
    required this.isDark,
    required this.connectorY,
  });

  final int count;
  final int activeStage;
  final List<Color> colors;
  final double flowT;
  final bool isDark;
  final double connectorY;

  @override
  void paint(Canvas canvas, Size size) {
    final slotW = size.width / count;
    final cy = connectorY;

    for (int i = 0; i < count - 1; i++) {
      final fromX = slotW * i + slotW / 2;
      final toX = slotW * (i + 1) + slotW / 2;
      final isActive = i == activeStage || i + 1 == activeStage;
      final segColor = colors[i];

      // Track line
      canvas.drawLine(
        Offset(fromX + 17, cy),
        Offset(toX - 17, cy),
        Paint()
          ..color = isActive
              ? segColor.withValues(alpha: 0.5)
              : (isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0))
          ..strokeWidth = isActive ? 1.8 : 1.2
          ..style = PaintingStyle.stroke,
      );

      // Animated particle on active segment
      if (i == activeStage) {
        final lineStart = fromX + 17;
        final lineEnd = toX - 17;
        final px = lineStart + (lineEnd - lineStart) * flowT;

        canvas.drawCircle(
          Offset(px, cy),
          7,
          Paint()
            ..color = segColor.withValues(alpha: 0.2)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
        );
        canvas.drawCircle(Offset(px, cy), 3, Paint()..color = segColor);
        // Trailing glow
        final trailPx = lineStart + (lineEnd - lineStart) * (flowT * 0.85);
        canvas.drawCircle(
          Offset(trailPx, cy),
          2,
          Paint()
            ..color = segColor.withValues(alpha: 0.4)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _PipePainter old) =>
      old.activeStage != activeStage ||
      old.flowT != flowT ||
      old.isDark != isDark;
}

