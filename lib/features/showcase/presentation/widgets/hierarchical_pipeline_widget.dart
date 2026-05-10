import 'package:flutter/material.dart';
import 'package:spacebar/features/showcase/presentation/widgets/showcase_card.dart';

// ─── Stage model ─────────────────────────────────────────────────────────────

class _Stage {
  const _Stage({
    required this.id,
    required this.icon,
    required this.label,
    required this.metric,
    required this.metricLabel,
    required this.color,
    required this.mode,
    required this.outputs,
  });

  final String id;
  final IconData icon;
  final String label;
  final String metric;
  final String metricLabel;
  final Color color;
  final _StageMode mode;
  final List<_Output> outputs;
}

enum _StageMode { sync, async }

class _Output {
  const _Output(this.label, this.detail, this.icon);
  final String label;
  final String detail;
  final IconData icon;
}

const _kStages = <_Stage>[
  _Stage(
    id: 'ingest',
    icon: Icons.storage_rounded,
    label: 'Ingest',
    metric: '3 TB',
    metricLabel: 'raw input',
    color: Color(0xFF3B82F6),
    mode: _StageMode.sync,
    outputs: [
      _Output('RAW', 'Bitwise flat image', Icons.circle_outlined),
      _Output('E01', 'Expert Witness Format', Icons.circle_outlined),
      _Output('VHD / VMDK', 'Virtual disk container', Icons.circle_outlined),
      _Output('QCOW2', 'QEMU copy-on-write', Icons.circle_outlined),
    ],
  ),
  _Stage(
    id: 'reduce',
    icon: Icons.compress_rounded,
    label: 'Dedupe & Compress',
    metric: '−40%',
    metricLabel: '1.2 TB saved',
    color: Color(0xFF10B981),
    mode: _StageMode.sync,
    outputs: [
      _Output('Block dedup', 'Hash-level deduplication', Icons.layers_rounded),
      _Output('Zstd', 'Stream compression', Icons.bolt_rounded),
      _Output(
        'Delta chain',
        'Incremental deltas',
        Icons.compare_arrows_rounded,
      ),
    ],
  ),
  _Stage(
    id: 'parse',
    icon: Icons.manage_search_rounded,
    label: 'Parse & Identify',
    metric: '4 types',
    metricLabel: 'async workers',
    color: Color(0xFFF59E0B),
    mode: _StageMode.async,
    outputs: [
      _Output('GPT', 'GUID Partition Table', Icons.grid_on_rounded),
      _Output('MBR', 'Master Boot Record', Icons.grid_on_rounded),
      _Output('APFS Container', 'Apple FS container', Icons.grid_on_rounded),
    ],
  ),
  _Stage(
    id: 'fs',
    icon: Icons.folder_open_rounded,
    label: 'File Systems',
    metric: '5 FS',
    metricLabel: 'types detected',
    color: Color(0xFF8B5CF6),
    mode: _StageMode.async,
    outputs: [
      _Output('NTFS', 'Windows primary FS', Icons.description_rounded),
      _Output('EXT4', 'Linux extended FS', Icons.description_rounded),
      _Output('APFS', 'Apple File System', Icons.description_rounded),
      _Output('FAT32 / exFAT', 'Legacy & removable', Icons.description_rounded),
    ],
  ),
  _Stage(
    id: 'index',
    icon: Icons.bolt_rounded,
    label: 'Index',
    metric: '2.4 M',
    metricLabel: 'async indexing',
    color: Color(0xFFEF4444),
    mode: _StageMode.async,
    outputs: [
      _Output('Paths', 'Full directory tree', Icons.tag_rounded),
      _Output('Timestamps', 'MACB times', Icons.access_time_rounded),
      _Output('Byte ranges', 'Physical offsets', Icons.straighten_rounded),
      _Output('Flags', 'Attributes & permissions', Icons.flag_rounded),
      _Output('Sizes', 'Logical + physical', Icons.data_usage_rounded),
    ],
  ),
];

// ─── Widget ───────────────────────────────────────────────────────────────────

class HierarchicalPipelineWidget extends StatefulWidget {
  final String title;
  final String description;
  final Map<String, dynamic> mockData;
  final Color? tint;

  const HierarchicalPipelineWidget({
    super.key,
    required this.title,
    required this.description,
    required this.mockData,
    this.tint,
  });

  @override
  State<HierarchicalPipelineWidget> createState() =>
      _HierarchicalPipelineWidgetState();
}

class _HierarchicalPipelineWidgetState extends State<HierarchicalPipelineWidget>
    with TickerProviderStateMixin {
  int _selectedStage = 0;
  late final AnimationController _flowCtrl;
  late final AnimationController _revealCtrl;

  @override
  void initState() {
    super.initState();
    _flowCtrl =
        AnimationController(
            vsync: this,
            duration: const Duration(milliseconds: 7000),
          )
          ..addListener(_syncStageWithFlow)
          ..repeat();
    _revealCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    )..forward();
  }

  void _syncStageWithFlow() {
    final stageCount = _kStages.length;
    if (stageCount == 0) return;

    final nextStage = ((_flowCtrl.value * stageCount).floor()) % stageCount;
    if (nextStage == _selectedStage) return;

    setState(() => _selectedStage = nextStage);
    _revealCtrl.forward(from: 0);
  }

  @override
  void dispose() {
    _flowCtrl.removeListener(_syncStageWithFlow);
    _flowCtrl.dispose();
    _revealCtrl.dispose();
    super.dispose();
  }

  void _selectStage(int index) {
    if (index == _selectedStage) return;
    setState(() => _selectedStage = index);
    _revealCtrl.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tint = widget.tint ?? const Color(0xFFF59E0B);
    final stage = _kStages[_selectedStage];

    return ShowcaseCard(
      title: widget.title,
      description: widget.description,
      tint: tint,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Stage rail ─────────────────────────────────────────────────
          SizedBox(
            height: 76,
            child: AnimatedBuilder(
              animation: _flowCtrl,
              builder: (_, __) => _StageRail(
                selectedIndex: _selectedStage,
                flowT: _flowCtrl.value,
                isDark: isDark,
                onSelect: _selectStage,
              ),
            ),
          ),
          const SizedBox(height: 10),

          // ── Breadcrumb path bar ─────────────────────────────────────────
          _PathBar(selectedIndex: _selectedStage, isDark: isDark),
          const SizedBox(height: 10),

          _StageModeBanner(stage: stage, isDark: isDark),
          const SizedBox(height: 8),

          // ── Output grid with staggered reveal ──────────────────────────
          Expanded(
            child: AnimatedBuilder(
              animation: _revealCtrl,
              builder: (_, __) => _OutputGrid(
                outputs: stage.outputs,
                stageColor: stage.color,
                revealT: _revealCtrl.value,
                isDark: isDark,
              ),
            ),
          ),
          const SizedBox(height: 10),

          // ── Metric footer ───────────────────────────────────────────────
          _MetricFooter(
            rawSize: widget.mockData['rawSize'] as String? ?? '3 TB',
            saved: widget.mockData['saved'] as String? ?? '1.2 TB',
            ratio: (widget.mockData['ratio'] as num? ?? 40).toInt(),
            isDark: isDark,
            tint: tint,
          ),
        ],
      ),
    );
  }
}

// ─── Stage rail with animated flow particles ──────────────────────────────────

class _StageRail extends StatelessWidget {
  const _StageRail({
    required this.selectedIndex,
    required this.flowT,
    required this.isDark,
    required this.onSelect,
  });

  final int selectedIndex;
  final double flowT;
  final bool isDark;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // connector lines + particles underneath
        Positioned.fill(
          child: CustomPaint(
            painter: _RailPainter(
              count: _kStages.length,
              selectedIndex: selectedIndex,
              colors: _kStages.map((s) => s.color).toList(),
              flowT: flowT,
              isDark: isDark,
            ),
          ),
        ),
        // stage buttons
        Row(
          children: List.generate(_kStages.length, (i) {
            final s = _kStages[i];
            final isSel = i == selectedIndex;
            return Expanded(
              child: GestureDetector(
                onTap: () => onSelect(i),
                behavior: HitTestBehavior.opaque,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOutCubic,
                      width: isSel ? 42 : 32,
                      height: isSel ? 42 : 32,
                      decoration: BoxDecoration(
                        color: isSel
                            ? s.color
                            : s.color.withValues(alpha: isDark ? 0.12 : 0.08),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: s.color.withValues(alpha: isSel ? 1.0 : 0.35),
                          width: isSel ? 2.0 : 1.2,
                        ),
                        boxShadow: isSel
                            ? [
                                BoxShadow(
                                  color: s.color.withValues(alpha: 0.45),
                                  blurRadius: 16,
                                ),
                              ]
                            : null,
                      ),
                      child: Icon(
                        s.icon,
                        size: isSel ? 20 : 15,
                        color: isSel ? Colors.white : s.color.withValues(alpha: 0.75),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      s.label,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontSize: isSel ? 9.5 : 8.5,
                        fontWeight: isSel ? FontWeight.w800 : FontWeight.w500,
                        color: isSel
                            ? s.color
                            : (isDark
                                  ? const Color(0xFF64748B)
                                  : const Color(0xFF94A3B8)),
                      ),
                    ),
                    if (s.mode == _StageMode.async)
                      Container(
                        margin: const EdgeInsets.only(top: 2),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: s.color.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Text(
                          'ASYNC',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                fontSize: 7,
                                fontWeight: FontWeight.w800,
                                color: s.color,
                                letterSpacing: 0.3,
                              ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _RailPainter extends CustomPainter {
  const _RailPainter({
    required this.count,
    required this.selectedIndex,
    required this.colors,
    required this.flowT,
    required this.isDark,
  });

  final int count;
  final int selectedIndex;
  final List<Color> colors;
  final double flowT;
  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final slotW = size.width / count;
    // Icon columns are vertically centered with label text below the icon.
    // Lines positioned at vertical middle of the rail.
    const cy = 28.0;

    for (int i = 0; i < count - 1; i++) {
      final fromX = slotW * i + slotW / 2;
      final toX = slotW * (i + 1) + slotW / 2;
      final isHighlighted = i == selectedIndex || i + 1 == selectedIndex;

      // base track line
      canvas.drawLine(
        Offset(fromX + 19, cy),
        Offset(toX - 19, cy),
        Paint()
          ..color = isHighlighted
              ? colors[i].withValues(alpha: 0.55)
              : (isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0))
          ..strokeWidth = isHighlighted ? 2.0 : 1.2
          ..style = PaintingStyle.stroke,
      );

      // animated particle on the active segment
      if (isHighlighted) {
        final segT = (flowT + i * 0.22) % 1.0;
        final lineStart = fromX + 19;
        final lineEnd = toX - 19;
        final px = lineStart + (lineEnd - lineStart) * segT;

        canvas.drawCircle(
          Offset(px, cy),
          6,
          Paint()
            ..color = colors[i].withValues(alpha: 0.22)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
        );
        canvas.drawCircle(Offset(px, cy), 2.8, Paint()..color = colors[i]);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _RailPainter old) =>
      old.selectedIndex != selectedIndex ||
      old.flowT != flowT ||
      old.isDark != isDark;
}

// ─── Breadcrumb path bar ──────────────────────────────────────────────────────

class _PathBar extends StatelessWidget {
  const _PathBar({required this.selectedIndex, required this.isDark});

  final int selectedIndex;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final stages = _kStages.sublist(0, selectedIndex + 1);
    final current = _kStages[selectedIndex];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0B1324) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.route_rounded,
            size: 12,
            color: isDark ? const Color(0xFF475569) : const Color(0xFF94A3B8),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (int i = 0; i < stages.length; i++) ...[
                    Text(
                      stages[i].label,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontSize: 9.5,
                        fontWeight: i == stages.length - 1
                            ? FontWeight.w800
                            : FontWeight.w600,
                        color: i == stages.length - 1
                            ? stages[i].color
                            : (isDark
                                  ? const Color(0xFF475569)
                                  : const Color(0xFF94A3B8)),
                      ),
                    ),
                    if (i < stages.length - 1)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Icon(
                          Icons.chevron_right_rounded,
                          size: 12,
                          color: isDark
                              ? const Color(0xFF334155)
                              : const Color(0xFFCBD5E1),
                        ),
                      ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: current.color.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              current.metric,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontSize: 9,
                fontWeight: FontWeight.w800,
                color: current.color,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: current.mode == _StageMode.async
                  ? const Color(0xFF7C3AED).withValues(alpha: 0.14)
                  : const Color(0xFF0D7A5F).withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              current.mode == _StageMode.async ? 'ASYNC' : 'SYNC',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontSize: 8.5,
                fontWeight: FontWeight.w800,
                color: current.mode == _StageMode.async
                    ? const Color(0xFF7C3AED)
                    : const Color(0xFF0D7A5F),
                letterSpacing: 0.25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StageModeBanner extends StatelessWidget {
  const _StageModeBanner({required this.stage, required this.isDark});

  final _Stage stage;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final async = stage.mode == _StageMode.async;
    final accent = async ? const Color(0xFF7C3AED) : const Color(0xFF0D7A5F);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0B1324) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Row(
        children: [
          Icon(
            async ? Icons.bolt_rounded : Icons.sync_rounded,
            size: 12,
            color: accent,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              async
                  ? 'Runs asynchronously from dedupe/compression.'
                  : 'Runs in synchronous pipeline order.',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontSize: 9.5,
                fontWeight: FontWeight.w700,
                color: accent,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            stage.metricLabel,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontSize: 8.5,
              color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Output grid with staggered reveal ───────────────────────────────────────

class _OutputGrid extends StatelessWidget {
  const _OutputGrid({
    required this.outputs,
    required this.stageColor,
    required this.revealT,
    required this.isDark,
  });

  final List<_Output> outputs;
  final Color stageColor;
  final double revealT;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 160,
        mainAxisExtent: 62,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: outputs.length,
      itemBuilder: (context, i) {
        final o = outputs[i];
        final delay = i / (outputs.length + 1);
        final localT = ((revealT - delay) / (1.0 - delay)).clamp(0.0, 1.0);
        final curve = Curves.easeOutCubic.transform(localT);

        return Opacity(
          opacity: curve,
          child: Transform.translate(
            offset: Offset(0, (1 - curve) * 14),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: stageColor.withValues(alpha: isDark ? 0.07 : 0.05),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: stageColor.withValues(alpha: 0.22)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        o.icon,
                        size: 13,
                        color: stageColor.withValues(alpha: 0.8),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          o.label,
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w800,
                                color: isDark
                                    ? const Color(0xFFE2E8F0)
                                    : const Color(0xFF0F172A),
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    o.detail,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontSize: 9,
                      fontWeight: FontWeight.w500,
                      color: isDark
                          ? const Color(0xFF64748B)
                          : const Color(0xFF94A3B8),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ─── Metric footer ────────────────────────────────────────────────────────────

class _MetricFooter extends StatelessWidget {
  const _MetricFooter({
    required this.rawSize,
    required this.saved,
    required this.ratio,
    required this.isDark,
    required this.tint,
  });

  final String rawSize;
  final String saved;
  final int ratio;
  final bool isDark;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0B1324) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Row(
        children: [
          _FooterStat(label: 'Raw input', value: rawSize, isDark: isDark),
          _FooterDivider(isDark: isDark),
          _FooterStat(
            label: 'Saved',
            value: saved,
            valueColor: const Color(0xFF10B981),
            isDark: isDark,
          ),
          _FooterDivider(isDark: isDark),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Reduction',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontSize: 9,
                        color: isDark
                            ? const Color(0xFF64748B)
                            : const Color(0xFF94A3B8),
                      ),
                    ),
                    Text(
                      '$ratio%',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: tint,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: ratio / 100,
                    backgroundColor: isDark
                        ? const Color(0xFF1E293B)
                        : const Color(0xFFE2E8F0),
                    valueColor: AlwaysStoppedAnimation(tint),
                    minHeight: 5,
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

class _FooterStat extends StatelessWidget {
  const _FooterStat({
    required this.label,
    required this.value,
    required this.isDark,
    this.valueColor,
  });

  final String label;
  final String value;
  final bool isDark;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color:
                  valueColor ??
                  (isDark ? const Color(0xFFE2E8F0) : const Color(0xFF0F172A)),
            ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontSize: 9,
              color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterDivider extends StatelessWidget {
  const _FooterDivider({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 28,
      margin: const EdgeInsets.only(right: 12),
      color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
    );
  }
}

