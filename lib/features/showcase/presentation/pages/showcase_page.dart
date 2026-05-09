import 'package:flutter/material.dart';
import 'package:spacebar/features/showcase/presentation/widgets/graph_timeline_widget.dart';
import 'package:spacebar/features/showcase/presentation/widgets/hierarchical_pipeline_widget.dart';
import 'package:spacebar/features/showcase/presentation/widgets/keyword_search_widget.dart';
import 'package:spacebar/features/showcase/presentation/widgets/network_graph_widget.dart';
import 'package:spacebar/features/showcase/presentation/widgets/similarity_index_widget.dart';
import 'package:spacebar/features/showcase/presentation/widgets/scrolling_list_widget.dart';
import 'package:spacebar/features/showcase/presentation/widgets/watcher_pipeline_widget.dart';
import 'package:spacebar/mock/feature_showcase_data.dart';

class ShowcasePage extends StatefulWidget {
  const ShowcasePage({super.key});

  @override
  State<ShowcasePage> createState() => _ShowcasePageState();
}

class _ShowcasePageState extends State<ShowcasePage> {
  bool _darkOps = false;

  ThemeData _buildOpsTheme(ThemeData baseTheme) {
    final cs = ColorScheme.dark(
      primary: const Color(0xFF63A0FF),
      secondary: const Color(0xFF5EEAD4),
      tertiary: const Color(0xFF8B5CF6),
      surface: const Color(0xFF111827),
      onSurface: const Color(0xFFE2E8F0),
      onSurfaceVariant: const Color(0xFF94A3B8),
      outline: const Color(0xFF334155),
      outlineVariant: const Color(0xFF1F2937),
    );

    return baseTheme.copyWith(
      brightness: Brightness.dark,
      colorScheme: cs,
      scaffoldBackgroundColor: const Color(0xFF0B1220),
      cardColor: const Color(0xFF111827),
      dividerColor: const Color(0xFF263548),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF0F172A),
        foregroundColor: Color(0xFFE2E8F0),
        surfaceTintColor: Colors.transparent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final baseTheme = Theme.of(context);
    final isMobile = MediaQuery.of(context).size.width < 600;
    final crossAxisCount = isMobile ? 1 : 2;
    final pageTheme = _darkOps ? _buildOpsTheme(baseTheme) : baseTheme;

    return Theme(
      data: pageTheme,
      child: Builder(
        builder: (context) {
          final theme = Theme.of(context);

          return Scaffold(
            body: SafeArea(
              child: Stack(
                children: [
                  // Background
                  Positioned.fill(
                    child: _darkOps
                        ? Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFF070E1A),
                                  Color(0xFF0B1220),
                                  Color(0xFF0F172A),
                                ],
                              ),
                            ),
                          )
                        : Container(color: const Color(0xFFF4F6FA)),
                  ),
                  // Content
                  CustomScrollView(
                    slivers: [
                      // Header
                      SliverAppBar(
                        expandedHeight: 140,
                        floating: false,
                        pinned: true,
                        backgroundColor: _darkOps
                            ? const Color(0xFF0F172A)
                            : Colors.white,
                        elevation: 0,
                        leading: IconButton(
                          icon: const Icon(Icons.arrow_back),
                          color: _darkOps
                              ? const Color(0xFFE2E8F0)
                              : const Color(0xFF0F1C2E),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        flexibleSpace: FlexibleSpaceBar(
                          background: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'Feature Showcase',
                                  style: theme.textTheme.headlineSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: _darkOps
                                            ? const Color(0xFFE2E8F0)
                                            : const Color(0xFF0F1C2E),
                                        letterSpacing: 0.2,
                                      ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Visual overview of core capabilities',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: _darkOps
                                        ? const Color(0xFF94A3B8)
                                        : const Color(0xFF52637A),
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                          child: Column(
                            children: [
                              _DashboardControlStrip(
                                darkOps: _darkOps,
                                onToggleDarkOps: () {
                                  setState(() => _darkOps = !_darkOps);
                                },
                              ),
                              const SizedBox(height: 10),
                              _KpiRow(darkOps: _darkOps),
                            ],
                          ),
                        ),
                      ),
                      // Responsive showcase rows
                      SliverPadding(
                        padding: const EdgeInsets.all(16),
                        sliver: SliverToBoxAdapter(
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              const spacing = 16.0;
                              final totalSpacing =
                                  spacing * (crossAxisCount - 1);
                              final cardWidth =
                                  (constraints.maxWidth - totalSpacing) /
                                  crossAxisCount;
                              final regularHeight = isMobile ? 330.0 : 360.0;
                              final artefactHeight = isMobile ? 480.0 : 560.0;

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _SectionLabel(
                                    number: 1,
                                    title: 'Ingestion & Processing',
                                    subtitle:
                                        'Live watcher telemetry and hierarchical parsing flow',
                                    darkOps: _darkOps,
                                  ),
                                  const SizedBox(height: 10),
                                  Wrap(
                                    spacing: spacing,
                                    runSpacing: spacing,
                                    children: [
                                      SizedBox(
                                        width: cardWidth,
                                        height: regularHeight,
                                        child: WatcherPipelineWidget(
                                          title:
                                              'Background Watcher + Processing Pipeline',
                                          description:
                                              'Auto-detect new evidence and push through dedupe, carve, parse, and index.',
                                          mockData: FeatureShowcaseData
                                              .watcherPipelineData,
                                          tint: const Color(0xFF0B57D0),
                                        ),
                                      ),
                                      SizedBox(
                                        width: cardWidth,
                                        height: regularHeight,
                                        child: HierarchicalPipelineWidget(
                                          title:
                                              'Disk Image Processing Pipeline',
                                          description:
                                              'Deduplicate + Zstd-compress first, then parse and index asynchronously across partitions and file systems.',
                                          mockData: FeatureShowcaseData
                                              .dedupCompressData,
                                          tint: const Color(0xFFF59E0B),
                                        ),
                                      ),
                                      SizedBox(
                                        width: cardWidth,
                                        height: regularHeight,
                                        child: ScrollingListWidget(
                                          title: 'Micro-Artifact Extraction',
                                          description:
                                              'Stream of extracted atomic artifacts',
                                          items: FeatureShowcaseData
                                              .microArtifactItems,
                                          tint: const Color(0xFF6941C6),
                                        ),
                                      ),
                                      SizedBox(
                                        width: cardWidth,
                                        height: regularHeight,
                                        child: KeywordSearchWidget(
                                          title: 'Keyword Search',
                                          description:
                                              'Fast indexed search across all extracted artefacts.',
                                          mockData: FeatureShowcaseData
                                              .keywordSearchData,
                                          tint: const Color(0xFF38BDF8),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: spacing),
                                  _SectionLabel(
                                    number: 2,
                                    title: 'Correlation Board',
                                    subtitle:
                                        'Cross-source evidence linkage across files, memory, and packets',
                                    darkOps: _darkOps,
                                  ),
                                  const SizedBox(height: 10),
                                  SizedBox(
                                    width: double.infinity,
                                    height: artefactHeight,
                                    child: GraphTimelineWidget(
                                      title: 'Artefact Relation Graph',
                                      description:
                                          'Evidence-board style relationships across indexed files, memory images, and packet captures.',
                                      mockData: FeatureShowcaseData
                                          .provenanceGraphData,
                                      tint: const Color(0xFF6941C6),
                                    ),
                                  ),
                                  const SizedBox(height: spacing),
                                  _SectionLabel(
                                    number: 3,
                                    title: 'Cross-Case Intelligence',
                                    subtitle:
                                        'Artefact linking across disk images, RAM captures, and network captures',
                                    darkOps: _darkOps,
                                  ),
                                  const SizedBox(height: 10),
                                  Wrap(
                                    spacing: spacing,
                                    runSpacing: spacing,
                                    children: [
                                      SizedBox(
                                        width: cardWidth,
                                        height: regularHeight,
                                        child: SimilarityIndexWidget(
                                          title: 'Artefact Similarity Index',
                                          description:
                                              'Five-signal evidence fusion ranks related files and highlights repackaged malware likelihood.',
                                          mockData: FeatureShowcaseData
                                              .similarityIndexData,
                                          tint: const Color(0xFFEF4444),
                                        ),
                                      ),
                                      SizedBox(
                                        width: cardWidth,
                                        height: regularHeight,
                                        child: NetworkGraphWidget(
                                          title: 'Cross-Case Links',
                                          description:
                                              'One campaign, multiple incidents.',
                                          mockData: FeatureShowcaseData
                                              .crossCaseLinksData,
                                          tint: const Color(0xFFF59E0B),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                      // Footer spacing
                      SliverPadding(
                        padding: const EdgeInsets.only(bottom: 32),
                        sliver: SliverToBoxAdapter(child: Container()),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DashboardControlStrip extends StatelessWidget {
  final bool darkOps;
  final VoidCallback onToggleDarkOps;

  const _DashboardControlStrip({
    required this.darkOps,
    required this.onToggleDarkOps,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 820;
        return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: darkOps ? const Color(0xFF111827) : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: darkOps
                  ? const Color(0xFF334155)
                  : const Color(0xFFE2E8F0),
            ),
          ),
          child: compact
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _ControlPill(
                          label: 'Algorithm',
                          active: true,
                          darkOps: darkOps,
                        ),
                        _ControlPill(label: 'Models', darkOps: darkOps),
                        _ControlPill(label: 'How it works', darkOps: darkOps),
                        _ControlPill(label: 'Customize', darkOps: darkOps),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _StatusPill(
                          label: 'System Status',
                          value: 'Online',
                          darkOps: darkOps,
                        ),
                        const SizedBox(width: 8),
                        _ModeTogglePill(
                          darkOps: darkOps,
                          onTap: onToggleDarkOps,
                        ),
                      ],
                    ),
                  ],
                )
              : Row(
                  children: [
                    Wrap(
                      spacing: 8,
                      children: [
                        _ControlPill(
                          label: 'Algorithm',
                          active: true,
                          darkOps: darkOps,
                        ),
                        _ControlPill(label: 'Models', darkOps: darkOps),
                        _ControlPill(label: 'How it works', darkOps: darkOps),
                        _ControlPill(label: 'Customize', darkOps: darkOps),
                      ],
                    ),
                    const Spacer(),
                    _StatusPill(
                      label: 'System Status',
                      value: 'Online',
                      darkOps: darkOps,
                    ),
                    const SizedBox(width: 8),
                    _ModeTogglePill(darkOps: darkOps, onTap: onToggleDarkOps),
                  ],
                ),
        );
      },
    );
  }
}

class _ControlPill extends StatelessWidget {
  final String label;
  final bool active;
  final bool darkOps;

  const _ControlPill({
    required this.label,
    this.active = false,
    required this.darkOps,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: active
            ? (darkOps ? const Color(0xFF1E3A8A) : const Color(0xFFE0ECFF))
            : (darkOps ? const Color(0xFF0F172A) : Colors.white),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: active
              ? (darkOps ? const Color(0xFF3B82F6) : const Color(0xFFB5CDF7))
              : (darkOps ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
        ),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: active
              ? (darkOps ? const Color(0xFFBFDBFE) : const Color(0xFF0B57D0))
              : (darkOps ? const Color(0xFF94A3B8) : const Color(0xFF475569)),
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String label;
  final String value;
  final bool darkOps;

  const _StatusPill({
    required this.label,
    required this.value,
    required this.darkOps,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: darkOps ? const Color(0xFF052E25) : const Color(0xFFECFDF3),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: darkOps ? const Color(0xFF0D7A5F) : const Color(0xFFB7E8C9),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(
              color: Color(0xFF0D7A5F),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            '$label: $value',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: const Color(0xFF0D7A5F),
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _KpiRow extends StatelessWidget {
  final bool darkOps;

  const _KpiRow({required this.darkOps});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 820;
        final tileWidth = compact
            ? constraints.maxWidth
            : (constraints.maxWidth - 30) / 4;

        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            SizedBox(
              width: tileWidth,
              child: _KpiTile(
                label: 'Active Cases',
                value: '27',
                accent: Color(0xFF0B57D0),
                darkOps: darkOps,
              ),
            ),
            SizedBox(
              width: tileWidth,
              child: _KpiTile(
                label: 'Indexed Entries',
                value: '2.4M',
                accent: Color(0xFF7C3AED),
                darkOps: darkOps,
              ),
            ),
            SizedBox(
              width: tileWidth,
              child: _KpiTile(
                label: 'Correlation Hits',
                value: '312',
                accent: Color(0xFFDC2626),
                darkOps: darkOps,
              ),
            ),
            SizedBox(
              width: tileWidth,
              child: _KpiTile(
                label: 'Watcher Queue',
                value: '03',
                accent: Color(0xFF0D7A5F),
                darkOps: darkOps,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _KpiTile extends StatelessWidget {
  final String label;
  final String value;
  final Color accent;
  final bool darkOps;

  const _KpiTile({
    required this.label,
    required this.value,
    required this.accent,
    required this.darkOps,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: darkOps ? const Color(0xFF111827) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: darkOps ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 28,
            decoration: BoxDecoration(
              color: accent,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: darkOps
                        ? const Color(0xFFE2E8F0)
                        : const Color(0xFF0F172A),
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.1,
                  ),
                ),
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: darkOps
                        ? const Color(0xFF94A3B8)
                        : const Color(0xFF64748B),
                    fontWeight: FontWeight.w700,
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

class _SectionLabel extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool darkOps;
  final int? number;

  const _SectionLabel({
    required this.title,
    required this.subtitle,
    required this.darkOps,
    this.number,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Gradient accent bar
        Container(
          width: 3,
          height: 36,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [const Color(0xFF6941C6), const Color(0xFF3B82F6)],
            ),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 12),
        if (number != null) ...[
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: darkOps
                  ? const Color(0xFF1E293B)
                  : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: darkOps
                    ? const Color(0xFF334155)
                    : const Color(0xFFE2E8F0),
              ),
            ),
            child: Center(
              child: Text(
                '$number',
                style: theme.textTheme.labelSmall?.copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: darkOps
                      ? const Color(0xFF64748B)
                      : const Color(0xFF94A3B8),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: darkOps
                      ? const Color(0xFFE2E8F0)
                      : const Color(0xFF0F172A),
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                  letterSpacing: 0.1,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: darkOps
                      ? const Color(0xFF475569)
                      : const Color(0xFF94A3B8),
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ModeTogglePill extends StatelessWidget {
  final bool darkOps;
  final VoidCallback onTap;

  const _ModeTogglePill({required this.darkOps, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: darkOps ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: darkOps ? const Color(0xFF475569) : const Color(0xFFCBD5E1),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              darkOps ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
              size: 14,
              color: darkOps
                  ? const Color(0xFFBFDBFE)
                  : const Color(0xFF334155),
            ),
            const SizedBox(width: 6),
            Text(
              darkOps ? 'Dark Ops' : 'Light Ops',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: darkOps
                    ? const Color(0xFFBFDBFE)
                    : const Color(0xFF334155),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
