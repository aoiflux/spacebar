import 'package:flutter/material.dart';
import 'package:spacebar/features/showcase/presentation/constants/showcase_page_constants.dart';
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
  bool _darkOps = ShowcaseDefaults.darkOpsEnabled;

  ThemeData _buildOpsTheme(ThemeData baseTheme) {
    return baseTheme.copyWith(
      brightness: Brightness.dark,
      colorScheme: ShowcaseColorScheme.ops,
      scaffoldBackgroundColor: ShowcaseColors.scaffoldDark,
      cardColor: ShowcaseColors.cardDark,
      dividerColor: ShowcaseColors.dividerDark,
      appBarTheme: const AppBarTheme(
        backgroundColor: ShowcaseColors.appBarDark,
        foregroundColor: ShowcaseColors.textPrimaryDark,
        surfaceTintColor: Colors.transparent,
      ),
    );
  }

  Widget _buildBackground() {
    if (_darkOps) {
      return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: ShowcaseColors.backgroundGradientDark,
          ),
        ),
      );
    }

    return const ColoredBox(color: ShowcaseColors.backgroundLight);
  }

  Widget _buildHeader(ThemeData theme) {
    return SliverAppBar(
      expandedHeight: ShowcaseDimens.headerExpandedHeight,
      floating: false,
      pinned: true,
      backgroundColor: _darkOps
          ? ShowcaseColors.appBarDark
          : ShowcaseColors.surfaceLight,
      elevation: ShowcaseDimens.zero,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        color: _darkOps
            ? ShowcaseColors.textPrimaryDark
            : ShowcaseColors.textInk,
        onPressed: () => Navigator.of(context).pop(),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Padding(
          padding: const EdgeInsets.fromLTRB(
            ShowcaseDimens.pagePadding,
            ShowcaseDimens.pagePadding,
            ShowcaseDimens.pagePadding,
            ShowcaseDimens.pagePadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                ShowcaseStrings.pageTitle,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: _darkOps
                      ? ShowcaseColors.textPrimaryDark
                      : ShowcaseColors.textInk,
                  letterSpacing: ShowcaseDimens.letterSpacingSmall,
                ),
              ),
              const SizedBox(height: ShowcaseDimens.gap6),
              Text(
                ShowcaseStrings.pageSubtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: _darkOps
                      ? ShowcaseColors.textMutedDark
                      : ShowcaseColors.textMutedLight,
                  fontSize: ShowcaseDimens.fontBodySmall,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopControls() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          ShowcaseDimens.pagePadding,
          ShowcaseDimens.gap12,
          ShowcaseDimens.pagePadding,
          ShowcaseDimens.zero,
        ),
        child: Column(
          children: [
            _DashboardControlStrip(
              darkOps: _darkOps,
              onToggleDarkOps: () {
                setState(() => _darkOps = !_darkOps);
              },
            ),
            const SizedBox(height: ShowcaseDimens.gap10),
            _KpiRow(darkOps: _darkOps),
          ],
        ),
      ),
    );
  }

  Widget _buildShowcaseContent({
    required bool isMobile,
    required int crossAxisCount,
  }) {
    return SliverPadding(
      padding: const EdgeInsets.all(ShowcaseDimens.pagePadding),
      sliver: SliverToBoxAdapter(
        child: LayoutBuilder(
          builder: (context, constraints) {
            const spacing = ShowcaseDimens.sectionSpacing;
            final totalSpacing = spacing * (crossAxisCount - 1);
            final cardWidth =
                (constraints.maxWidth - totalSpacing) / crossAxisCount;
            final regularHeight = isMobile
                ? ShowcaseDimens.mobileCardHeight
                : ShowcaseDimens.desktopCardHeight;
            final artefactHeight = isMobile
                ? ShowcaseDimens.mobileGraphHeight
                : ShowcaseDimens.desktopGraphHeight;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionLabel(
                  number: ShowcaseStrings.ingestionSectionNumber,
                  title: ShowcaseStrings.ingestionSectionTitle,
                  subtitle: ShowcaseStrings.ingestionSectionSubtitle,
                  darkOps: _darkOps,
                ),
                const SizedBox(height: ShowcaseDimens.gap10),
                _buildIngestionWrap(
                  cardWidth: cardWidth,
                  cardHeight: regularHeight,
                ),
                const SizedBox(height: spacing),
                _SectionLabel(
                  number: ShowcaseStrings.correlationSectionNumber,
                  title: ShowcaseStrings.correlationSectionTitle,
                  subtitle: ShowcaseStrings.correlationSectionSubtitle,
                  darkOps: _darkOps,
                ),
                const SizedBox(height: ShowcaseDimens.gap10),
                SizedBox(
                  width: double.infinity,
                  height: artefactHeight,
                  child: const GraphTimelineWidget(
                    title: ShowcaseStrings.artefactGraphTitle,
                    description: ShowcaseStrings.artefactGraphDescription,
                    mockData: FeatureShowcaseData.provenanceGraphData,
                    tint: ShowcaseColors.tintViolet,
                  ),
                ),
                const SizedBox(height: spacing),
                _SectionLabel(
                  number: ShowcaseStrings.intelligenceSectionNumber,
                  title: ShowcaseStrings.intelligenceSectionTitle,
                  subtitle: ShowcaseStrings.intelligenceSectionSubtitle,
                  darkOps: _darkOps,
                ),
                const SizedBox(height: ShowcaseDimens.gap10),
                _buildIntelligenceWrap(
                  cardWidth: cardWidth,
                  cardHeight: regularHeight,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildIngestionWrap({
    required double cardWidth,
    required double cardHeight,
  }) {
    return Wrap(
      spacing: ShowcaseDimens.sectionSpacing,
      runSpacing: ShowcaseDimens.sectionSpacing,
      children: [
        SizedBox(
          width: cardWidth,
          height: cardHeight,
          child: const WatcherPipelineWidget(
            title: ShowcaseStrings.watcherCardTitle,
            description: ShowcaseStrings.watcherCardDescription,
            mockData: FeatureShowcaseData.watcherPipelineData,
            tint: ShowcaseColors.tintBlue,
          ),
        ),
        SizedBox(
          width: cardWidth,
          height: cardHeight,
          child: const HierarchicalPipelineWidget(
            title: ShowcaseStrings.diskPipelineCardTitle,
            description: ShowcaseStrings.diskPipelineCardDescription,
            mockData: FeatureShowcaseData.dedupCompressData,
            tint: ShowcaseColors.tintAmber,
          ),
        ),
        SizedBox(
          width: cardWidth,
          height: cardHeight,
          child: const ScrollingListWidget(
            title: ShowcaseStrings.microArtifactCardTitle,
            description: ShowcaseStrings.microArtifactCardDescription,
            items: FeatureShowcaseData.microArtifactItems,
            tint: ShowcaseColors.tintViolet,
          ),
        ),
        SizedBox(
          width: cardWidth,
          height: cardHeight,
          child: const KeywordSearchWidget(
            title: ShowcaseStrings.keywordCardTitle,
            description: ShowcaseStrings.keywordCardDescription,
            mockData: FeatureShowcaseData.keywordSearchData,
            tint: ShowcaseColors.tintSky,
          ),
        ),
      ],
    );
  }

  Widget _buildIntelligenceWrap({
    required double cardWidth,
    required double cardHeight,
  }) {
    return Wrap(
      spacing: ShowcaseDimens.sectionSpacing,
      runSpacing: ShowcaseDimens.sectionSpacing,
      children: [
        SizedBox(
          width: cardWidth,
          height: cardHeight,
          child: const SimilarityIndexWidget(
            title: ShowcaseStrings.similarityCardTitle,
            description: ShowcaseStrings.similarityCardDescription,
            mockData: FeatureShowcaseData.similarityIndexData,
            tint: ShowcaseColors.tintRed,
          ),
        ),
        SizedBox(
          width: cardWidth,
          height: cardHeight,
          child: const NetworkGraphWidget(
            title: ShowcaseStrings.crossCaseCardTitle,
            description: ShowcaseStrings.crossCaseCardDescription,
            mockData: FeatureShowcaseData.crossCaseLinksData,
            tint: ShowcaseColors.tintAmber,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final baseTheme = Theme.of(context);
    final isMobile =
        MediaQuery.of(context).size.width < ShowcaseDimens.mobileBreakpoint;
    final crossAxisCount = isMobile
        ? ShowcaseLayout.mobileCrossAxisCount
        : ShowcaseLayout.desktopCrossAxisCount;
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
                  Positioned.fill(child: _buildBackground()),
                  CustomScrollView(
                    slivers: [
                      _buildHeader(theme),
                      _buildTopControls(),
                      _buildShowcaseContent(
                        isMobile: isMobile,
                        crossAxisCount: crossAxisCount,
                      ),
                      const SliverPadding(
                        padding: EdgeInsets.only(
                          bottom: ShowcaseDimens.footerBottomPadding,
                        ),
                        sliver: SliverToBoxAdapter(child: SizedBox.shrink()),
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
        final compact = constraints.maxWidth < ShowcaseDimens.compactBreakpoint;
        final controls = Wrap(
          spacing: ShowcaseDimens.gap8,
          runSpacing: ShowcaseDimens.gap8,
          children: ShowcaseData.controlTabs
              .map(
                (tab) => _ControlPill(
                  label: tab.label,
                  active: tab.active,
                  darkOps: darkOps,
                ),
              )
              .toList(growable: false),
        );

        final statusWidgets = [
          _StatusPill(
            label: ShowcaseStrings.systemStatusLabel,
            value: ShowcaseStrings.systemStatusValue,
            darkOps: darkOps,
          ),
          const SizedBox(width: ShowcaseDimens.gap8),
          _ModeTogglePill(darkOps: darkOps, onTap: onToggleDarkOps),
        ];

        return Container(
          padding: const EdgeInsets.all(ShowcaseDimens.gap10),
          decoration: BoxDecoration(
            color: darkOps
                ? ShowcaseColors.cardDark
                : ShowcaseColors.cardLightAlt,
            borderRadius: BorderRadius.circular(ShowcaseDimens.radius12),
            border: Border.all(
              color: darkOps
                  ? ShowcaseColors.borderDark
                  : ShowcaseColors.borderLight,
            ),
          ),
          child: compact
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    controls,
                    const SizedBox(height: ShowcaseDimens.gap8),
                    Row(children: statusWidgets),
                  ],
                )
              : Row(children: [controls, const Spacer(), ...statusWidgets]),
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
      padding: const EdgeInsets.symmetric(
        horizontal: ShowcaseDimens.gap10,
        vertical: ShowcaseDimens.gap6,
      ),
      decoration: BoxDecoration(
        color: active
            ? (darkOps
                  ? ShowcaseColors.pillActiveDark
                  : ShowcaseColors.pillActiveLight)
            : (darkOps
                  ? ShowcaseColors.panelDark
                  : ShowcaseColors.surfaceLight),
        borderRadius: BorderRadius.circular(ShowcaseDimens.pillRadius),
        border: Border.all(
          color: active
              ? (darkOps
                    ? ShowcaseColors.pillActiveBorderDark
                    : ShowcaseColors.pillActiveBorderLight)
              : (darkOps
                    ? ShowcaseColors.borderDark
                    : ShowcaseColors.borderLight),
        ),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: active
              ? (darkOps
                    ? ShowcaseColors.pillActiveTextDark
                    : ShowcaseColors.pillActiveTextLight)
              : (darkOps
                    ? ShowcaseColors.textMutedDark
                    : ShowcaseColors.textSecondary),
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
      padding: const EdgeInsets.symmetric(
        horizontal: ShowcaseDimens.gap10,
        vertical: ShowcaseDimens.gap6,
      ),
      decoration: BoxDecoration(
        color: darkOps
            ? ShowcaseColors.statusBgDark
            : ShowcaseColors.statusBgLight,
        borderRadius: BorderRadius.circular(ShowcaseDimens.pillRadius),
        border: Border.all(
          color: darkOps
              ? ShowcaseColors.statusBorderDark
              : ShowcaseColors.statusBorderLight,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: ShowcaseDimens.statusDotSize,
            height: ShowcaseDimens.statusDotSize,
            decoration: const BoxDecoration(
              color: ShowcaseColors.statusAccent,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: ShowcaseDimens.gap6),
          Text(
            '$label: $value',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: ShowcaseColors.statusAccent,
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
        final compact = constraints.maxWidth < ShowcaseDimens.compactBreakpoint;
        final tileWidth = compact
            ? constraints.maxWidth
            : (constraints.maxWidth -
                      (ShowcaseDimens.kpiSpacing *
                          (ShowcaseLayout.kpiColumns - 1))) /
                  ShowcaseLayout.kpiColumns;

        return Wrap(
          spacing: ShowcaseDimens.kpiSpacing,
          runSpacing: ShowcaseDimens.kpiSpacing,
          children: ShowcaseData.kpis
              .map(
                (kpi) => SizedBox(
                  width: tileWidth,
                  child: _KpiTile(
                    label: kpi.label,
                    value: kpi.value,
                    accent: kpi.accent,
                    darkOps: darkOps,
                  ),
                ),
              )
              .toList(growable: false),
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
      padding: const EdgeInsets.symmetric(
        horizontal: ShowcaseDimens.gap10,
        vertical: ShowcaseDimens.gap10,
      ),
      decoration: BoxDecoration(
        color: darkOps ? ShowcaseColors.cardDark : ShowcaseColors.surfaceLight,
        borderRadius: BorderRadius.circular(ShowcaseDimens.radius10),
        border: Border.all(
          color: darkOps
              ? ShowcaseColors.borderDark
              : ShowcaseColors.borderLight,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: ShowcaseDimens.kpiAccentWidth,
            height: ShowcaseDimens.kpiAccentHeight,
            decoration: BoxDecoration(
              color: accent,
              borderRadius: BorderRadius.circular(ShowcaseDimens.radius3),
            ),
          ),
          const SizedBox(width: ShowcaseDimens.gap8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: darkOps
                        ? ShowcaseColors.textPrimaryDark
                        : ShowcaseColors.panelDark,
                    fontWeight: FontWeight.w800,
                    letterSpacing: ShowcaseDimens.letterSpacingTiny,
                  ),
                ),
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: darkOps
                        ? ShowcaseColors.textMutedDark
                        : ShowcaseColors.textLabelLight,
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
        Container(
          width: ShowcaseDimens.sectionAccentWidth,
          height: ShowcaseDimens.sectionAccentHeight,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [ShowcaseColors.tintViolet, ShowcaseColors.accentBlue],
            ),
            borderRadius: BorderRadius.circular(ShowcaseDimens.radius3),
          ),
        ),
        const SizedBox(width: ShowcaseDimens.gap12),
        if (number != null) ...[
          Container(
            width: ShowcaseDimens.badgeSize,
            height: ShowcaseDimens.badgeSize,
            decoration: BoxDecoration(
              color: darkOps
                  ? ShowcaseColors.badgeBgDark
                  : ShowcaseColors.badgeBgLight,
              borderRadius: BorderRadius.circular(ShowcaseDimens.radius6),
              border: Border.all(
                color: darkOps
                    ? ShowcaseColors.borderDark
                    : ShowcaseColors.borderLight,
              ),
            ),
            child: Center(
              child: Text(
                '$number',
                style: theme.textTheme.labelSmall?.copyWith(
                  fontSize: ShowcaseDimens.fontBadge,
                  fontWeight: FontWeight.w800,
                  color: darkOps
                      ? ShowcaseColors.badgeTextDark
                      : ShowcaseColors.badgeTextLight,
                ),
              ),
            ),
          ),
          const SizedBox(width: ShowcaseDimens.gap10),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: darkOps
                      ? ShowcaseColors.textPrimaryDark
                      : ShowcaseColors.panelDark,
                  fontWeight: FontWeight.w800,
                  fontSize: ShowcaseDimens.fontTitleSmall,
                  letterSpacing: ShowcaseDimens.letterSpacingTiny,
                ),
              ),
              const SizedBox(height: ShowcaseDimens.gap2),
              Text(
                subtitle,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: darkOps
                      ? ShowcaseColors.sectionSubtitleDark
                      : ShowcaseColors.sectionSubtitleLight,
                  fontWeight: FontWeight.w600,
                  fontSize: ShowcaseDimens.fontSubtitleSmall,
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
      borderRadius: BorderRadius.circular(ShowcaseDimens.pillRadius),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: ShowcaseDimens.gap10,
          vertical: ShowcaseDimens.gap6,
        ),
        decoration: BoxDecoration(
          color: darkOps
              ? ShowcaseColors.modeBgDark
              : ShowcaseColors.modeBgLight,
          borderRadius: BorderRadius.circular(ShowcaseDimens.pillRadius),
          border: Border.all(
            color: darkOps
                ? ShowcaseColors.modeBorderDark
                : ShowcaseColors.modeBorderLight,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              darkOps ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
              size: ShowcaseDimens.modeIconSize,
              color: darkOps
                  ? ShowcaseColors.modeTextDark
                  : ShowcaseColors.modeTextLight,
            ),
            const SizedBox(width: ShowcaseDimens.gap6),
            Text(
              darkOps ? ShowcaseStrings.modeDark : ShowcaseStrings.modeLight,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: darkOps
                    ? ShowcaseColors.modeTextDark
                    : ShowcaseColors.modeTextLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
