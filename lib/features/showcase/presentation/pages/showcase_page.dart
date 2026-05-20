import 'package:flutter/material.dart';
import 'package:spacebar/features/showcase/presentation/constants/showcase_page_constants.dart';
import 'package:spacebar/features/showcase/presentation/widgets/graph_timeline_widget.dart';
import 'package:spacebar/features/showcase/presentation/widgets/hierarchical_pipeline_widget.dart';
import 'package:spacebar/features/showcase/presentation/widgets/knowledge_fusion_widget.dart';
import 'package:spacebar/features/showcase/presentation/widgets/keyword_search_widget.dart';
import 'package:spacebar/features/showcase/presentation/widgets/network_graph_widget.dart';
import 'package:spacebar/features/showcase/presentation/widgets/similarity_index_widget.dart';
import 'package:spacebar/features/showcase/presentation/widgets/watcher_pipeline_widget.dart';
import 'package:spacebar/mock/feature_showcase_data.dart';

class ShowcasePage extends StatefulWidget {
  const ShowcasePage({super.key});

  @override
  State<ShowcasePage> createState() => _ShowcasePageState();
}

class _ShowcasePageState extends State<ShowcasePage> {
  final bool _darkOps = ShowcaseDefaults.darkOpsEnabled;
  bool _enableCardTickers = false;

  static const int _ingestionModuleCount = 4;
  static const int _correlationModuleCount = 1;
  static const int _intelligenceModuleCount = 2;

  int get _moduleCount =>
      _ingestionModuleCount +
      _correlationModuleCount +
      _intelligenceModuleCount;

  @override
  void initState() {
    super.initState();
    // Let the route transition settle before starting all card animations.
    Future<void>.delayed(const Duration(milliseconds: 140), () {
      if (!mounted) return;
      setState(() => _enableCardTickers = true);
    });
  }

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
    final titleColor = _darkOps
        ? ShowcaseColors.textPrimaryDark
        : ShowcaseColors.textInk;
    final isWideLayout = MediaQuery.of(context).size.width >= 1000;
    final expandedHeight = isWideLayout
        ? ShowcaseDimens.headerExpandedHeight - 16
        : ShowcaseDimens.headerExpandedHeight;
    final headerVerticalPadding = isWideLayout
        ? ShowcaseDimens.pagePadding - 4
        : ShowcaseDimens.pagePadding;

    Widget modulePill() {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: _darkOps
              ? ShowcaseColors.badgeBgDark
              : ShowcaseColors.badgeBgLight,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: _darkOps
                ? ShowcaseColors.borderDark
                : ShowcaseColors.borderLight,
          ),
        ),
        child: Text(
          '$_moduleCount modules',
          style: theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: _darkOps
                ? ShowcaseColors.badgeTextDark
                : ShowcaseColors.badgeTextLight,
          ),
        ),
      );
    }

    Widget visualDeckPill() {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: ShowcaseColors.tintViolet.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: ShowcaseColors.tintViolet.withValues(alpha: 0.28),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.insights_rounded,
              size: 12,
              color: ShowcaseColors.tintViolet,
            ),
            const SizedBox(width: 6),
            Text(
              'Visual Intelligence Deck',
              style: theme.textTheme.labelSmall?.copyWith(
                color: ShowcaseColors.tintViolet,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      );
    }

    Widget buzzPill(String label) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: _darkOps
              ? ShowcaseColors.panelDark
              : ShowcaseColors.badgeBgLight,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: _darkOps
                ? ShowcaseColors.borderDark
                : ShowcaseColors.borderLight,
          ),
        ),
        child: Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: _darkOps
                ? ShowcaseColors.textMutedDark
                : ShowcaseColors.textSecondary,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }

    return SliverAppBar(
      expandedHeight: expandedHeight,
      floating: false,
      pinned: true,
      backgroundColor: _darkOps
          ? ShowcaseColors.appBarDark
          : ShowcaseColors.surfaceLight,
      elevation: ShowcaseDimens.zero,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        color: titleColor,
        onPressed: () => Navigator.of(context).pop(),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: LayoutBuilder(
          builder: (context, constraints) {
            final contentHeight =
                (constraints.maxHeight - (headerVerticalPadding * 2)).clamp(
                  0.0,
                  double.infinity,
                );
            final showBuzz = contentHeight >= 110;

            return Padding(
              padding: EdgeInsets.fromLTRB(
                ShowcaseDimens.pagePadding,
                headerVerticalPadding,
                ShowcaseDimens.pagePadding,
                headerVerticalPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Expanded(child: visualDeckPill()),
                      const SizedBox(width: 12),
                      modulePill(),
                    ],
                  ),
                  SizedBox(
                    height: isWideLayout
                        ? ShowcaseDimens.gap6
                        : ShowcaseDimens.gap8,
                  ),
                  Text(
                    ShowcaseStrings.pageTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: titleColor,
                      letterSpacing: ShowcaseDimens.letterSpacingSmall,
                    ),
                  ),
                  if (showBuzz) ...[
                    const SizedBox(height: ShowcaseDimens.gap8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        buzzPill('Chain-of-Custody'),
                        buzzPill('Cross-Case Correlation'),
                        buzzPill('Hash Deduplication'),
                      ],
                    ),
                  ],
                ],
              ),
            );
          },
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
            _DashboardControlStrip(darkOps: _darkOps),
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

            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              child: _enableCardTickers
                  ? KeyedSubtree(
                      key: const ValueKey('live-showcase'),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _SectionLabel(
                            number: ShowcaseStrings.ingestionSectionNumber,
                            title: ShowcaseStrings.ingestionSectionTitle,
                            subtitle: ShowcaseStrings.ingestionSectionSubtitle,
                            darkOps: _darkOps,
                          ),
                          const SizedBox(height: ShowcaseDimens.gap10),
                          TickerMode(
                            enabled: _enableCardTickers,
                            child: RepaintBoundary(
                              child: _buildIngestionWrap(
                                cardWidth: cardWidth,
                                cardHeight: regularHeight,
                                rowWidth: constraints.maxWidth,
                              ),
                            ),
                          ),
                          const SizedBox(height: spacing),
                          _SectionLabel(
                            number: ShowcaseStrings.correlationSectionNumber,
                            title: ShowcaseStrings.correlationSectionTitle,
                            subtitle:
                                ShowcaseStrings.correlationSectionSubtitle,
                            darkOps: _darkOps,
                          ),
                          const SizedBox(height: ShowcaseDimens.gap10),
                          TickerMode(
                            enabled: _enableCardTickers,
                            child: RepaintBoundary(
                              child: SizedBox(
                                width: double.infinity,
                                height: artefactHeight,
                                child: const GraphTimelineWidget(
                                  title: ShowcaseStrings.artefactGraphTitle,
                                  description:
                                      ShowcaseStrings.artefactGraphDescription,
                                  mockData:
                                      FeatureShowcaseData.provenanceGraphData,
                                  tint: ShowcaseColors.tintViolet,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: spacing),
                          _SectionLabel(
                            number: ShowcaseStrings.intelligenceSectionNumber,
                            title: ShowcaseStrings.intelligenceSectionTitle,
                            subtitle:
                                ShowcaseStrings.intelligenceSectionSubtitle,
                            darkOps: _darkOps,
                          ),
                          const SizedBox(height: ShowcaseDimens.gap10),
                          TickerMode(
                            enabled: _enableCardTickers,
                            child: RepaintBoundary(
                              child: _buildIntelligenceWrap(
                                cardWidth: cardWidth,
                                cardHeight: regularHeight,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : KeyedSubtree(
                      key: const ValueKey('skeleton-showcase'),
                      child: _buildShowcaseSkeleton(
                        cardWidth: cardWidth,
                        cardHeight: regularHeight,
                        isMobile: isMobile,
                        artefactHeight: artefactHeight,
                        spacing: spacing,
                      ),
                    ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildShowcaseSkeleton({
    required double cardWidth,
    required double cardHeight,
    required bool isMobile,
    required double artefactHeight,
    required double spacing,
  }) {
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
        _buildSkeletonWrap(
          cardWidth: cardWidth,
          cardHeight: cardHeight,
          count: 3,
        ),
        const SizedBox(height: ShowcaseDimens.sectionSpacing),
        _SkeletonCard(
          width: double.infinity,
          height: isMobile ? cardHeight + 22 : cardHeight,
          darkOps: _darkOps,
        ),
        const SizedBox(height: ShowcaseDimens.sectionSpacing),
        _SectionLabel(
          number: ShowcaseStrings.correlationSectionNumber,
          title: ShowcaseStrings.correlationSectionTitle,
          subtitle: ShowcaseStrings.correlationSectionSubtitle,
          darkOps: _darkOps,
        ),
        const SizedBox(height: ShowcaseDimens.gap10),
        _SkeletonCard(
          width: double.infinity,
          height: artefactHeight,
          darkOps: _darkOps,
        ),
        SizedBox(height: spacing),
        _SectionLabel(
          number: ShowcaseStrings.intelligenceSectionNumber,
          title: ShowcaseStrings.intelligenceSectionTitle,
          subtitle: ShowcaseStrings.intelligenceSectionSubtitle,
          darkOps: _darkOps,
        ),
        const SizedBox(height: ShowcaseDimens.gap10),
        _buildSkeletonWrap(
          cardWidth: cardWidth,
          cardHeight: cardHeight,
          count: 2,
        ),
      ],
    );
  }

  Widget _buildSkeletonWrap({
    required double cardWidth,
    required double cardHeight,
    required int count,
  }) {
    return Wrap(
      spacing: ShowcaseDimens.sectionSpacing,
      runSpacing: ShowcaseDimens.sectionSpacing,
      children: List.generate(
        count,
        (_) => _SkeletonCard(
          width: cardWidth,
          height: cardHeight,
          darkOps: _darkOps,
        ),
      ),
    );
  }

  Widget _buildIngestionWrap({
    required double cardWidth,
    required double cardHeight,
    required double rowWidth,
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
          child: const KeywordSearchWidget(
            title: ShowcaseStrings.keywordCardTitle,
            description: ShowcaseStrings.keywordCardDescription,
            mockData: FeatureShowcaseData.keywordSearchData,
            tint: ShowcaseColors.tintSky,
          ),
        ),
        SizedBox(
          width: rowWidth,
          height: cardHeight,
          child: const KnowledgeFusionWidget(
            title: ShowcaseStrings.artifactCardTitle,
            description:
                'Enrichment parity + micro-artefact intelligence in one lane',
            tint: ShowcaseColors.tintViolet,
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

  const _DashboardControlStrip({required this.darkOps});

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

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard({
    required this.width,
    required this.height,
    required this.darkOps,
  });

  final double width;
  final double height;
  final bool darkOps;

  @override
  Widget build(BuildContext context) {
    final borderColor = darkOps
        ? ShowcaseColors.borderDark
        : ShowcaseColors.borderLight;
    final base = darkOps
        ? ShowcaseColors.cardDark
        : ShowcaseColors.cardLightAlt;
    final stripe = darkOps ? const Color(0xFF243249) : const Color(0xFFDCE8F8);

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: base,
        borderRadius: BorderRadius.circular(ShowcaseDimens.radius12),
        border: Border.all(color: borderColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(ShowcaseDimens.gap12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: width * 0.28,
              height: 10,
              decoration: BoxDecoration(
                color: stripe,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: width * 0.52,
              height: 8,
              decoration: BoxDecoration(
                color: stripe.withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            const SizedBox(height: 6),
            Container(
              width: width * 0.38,
              height: 8,
              decoration: BoxDecoration(
                color: stripe.withValues(alpha: 0.65),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            const Spacer(),
            Container(
              width: double.infinity,
              height: 36,
              decoration: BoxDecoration(
                color: stripe.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ],
        ),
      ),
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
