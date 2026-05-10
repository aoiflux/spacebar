import 'package:flutter/material.dart';

class ShowcaseDefaults {
  static const bool darkOpsEnabled = false;
}

class ShowcaseLayout {
  static const int mobileCrossAxisCount = 1;
  static const int desktopCrossAxisCount = 2;
  static const int kpiColumns = 4;
}

class ShowcaseDimens {
  static const double zero = 0;
  static const double mobileBreakpoint = 600;
  static const double compactBreakpoint = 820;

  static const double pagePadding = 16;
  static const double footerBottomPadding = 32;
  static const double headerExpandedHeight = 140;

  static const double sectionSpacing = 16;
  static const double mobileCardHeight = 330;
  static const double desktopCardHeight = 360;
  static const double mobileGraphHeight = 480;
  static const double desktopGraphHeight = 560;

  static const double gap2 = 2;
  static const double gap6 = 6;
  static const double gap8 = 8;
  static const double gap10 = 10;
  static const double gap12 = 12;

  static const double radius3 = 3;
  static const double radius6 = 6;
  static const double radius10 = 10;
  static const double radius12 = 12;
  static const double pillRadius = 999;

  static const double sectionAccentWidth = 3;
  static const double sectionAccentHeight = 36;
  static const double badgeSize = 22;
  static const double statusDotSize = 7;

  static const double kpiSpacing = 10;
  static const double kpiAccentWidth = 6;
  static const double kpiAccentHeight = 28;

  static const double modeIconSize = 14;

  static const double fontBodySmall = 13;
  static const double fontBadge = 10;
  static const double fontTitleSmall = 14;
  static const double fontSubtitleSmall = 11;

  static const double letterSpacingTiny = 0.1;
  static const double letterSpacingSmall = 0.2;
}

class ShowcaseStrings {
  static const String pageTitle = 'Feature Showcase';
  static const String pageSubtitle = 'Visual overview of core capabilities';

  static const String ingestionSectionTitle = 'Ingestion & Processing';
  static const String ingestionSectionSubtitle =
      'Live watcher telemetry and hierarchical parsing flow';
  static const int ingestionSectionNumber = 1;

  static const String correlationSectionTitle = 'Correlation Board';
  static const String correlationSectionSubtitle =
      'Cross-source evidence linkage across files, memory, and packets';
  static const int correlationSectionNumber = 2;

  static const String intelligenceSectionTitle = 'Cross-Case Intelligence';
  static const String intelligenceSectionSubtitle =
      'Artefact linking across disk images, RAM captures, and network captures';
  static const int intelligenceSectionNumber = 3;

  static const String watcherCardTitle =
      'Background Watcher + Processing Pipeline';
  static const String watcherCardDescription =
      'Auto-detect new evidence and push through dedupe, carve, parse, and index.';

  static const String diskPipelineCardTitle = 'Disk Image Processing Pipeline';
  static const String diskPipelineCardDescription =
      'Deduplicate + Zstd-compress first, then parse and index asynchronously across partitions and file systems.';

  static const String microArtifactCardTitle = 'Micro-Artifact Extraction';
  static const String microArtifactCardDescription =
      'Stream of extracted atomic artifacts';

  static const String keywordCardTitle = 'Keyword Search';
  static const String keywordCardDescription =
      'Fast indexed search across all extracted artefacts.';

  static const String artefactGraphTitle = 'Artefact Relation Graph';
  static const String artefactGraphDescription =
      'Evidence-board style relationships across indexed files, memory images, and packet captures.';

  static const String similarityCardTitle = 'Artefact Similarity Index';
  static const String similarityCardDescription =
      'Five-signal evidence fusion ranks related files and highlights repackaged malware likelihood.';

  static const String crossCaseCardTitle = 'Cross-Case Links';
  static const String crossCaseCardDescription =
      'One campaign, multiple incidents.';

  static const String systemStatusLabel = 'System Status';
  static const String systemStatusValue = 'Online';

  static const String modeDark = 'Dark Ops';
  static const String modeLight = 'Light Ops';

  static const String tabAlgorithm = 'Algorithm';
  static const String tabModels = 'Models';
  static const String tabHowItWorks = 'How it works';
  static const String tabCustomize = 'Customize';

  static const String kpiActiveCasesLabel = 'Active Cases';
  static const String kpiActiveCasesValue = '27';
  static const String kpiIndexedEntriesLabel = 'Indexed Entries';
  static const String kpiIndexedEntriesValue = '2.4M';
  static const String kpiCorrelationHitsLabel = 'Correlation Hits';
  static const String kpiCorrelationHitsValue = '312';
  static const String kpiWatcherQueueLabel = 'Watcher Queue';
  static const String kpiWatcherQueueValue = '03';
}

class ShowcaseColors {
  static const Color primaryBlue = Color(0xFF63A0FF);
  static const Color secondaryMint = Color(0xFF5EEAD4);
  static const Color tertiaryPurple = Color(0xFF8B5CF6);

  static const Color surfaceDark = Color(0xFF111827);
  static const Color textPrimaryDark = Color(0xFFE2E8F0);
  static const Color textMutedDark = Color(0xFF94A3B8);
  static const Color outlineDark = Color(0xFF334155);
  static const Color outlineVariantDark = Color(0xFF1F2937);

  static const Color scaffoldDark = Color(0xFF0B1220);
  static const Color appBarDark = Color(0xFF0F172A);
  static const Color cardDark = Color(0xFF111827);
  static const Color panelDark = Color(0xFF0F172A);
  static const Color dividerDark = Color(0xFF263548);
  static const Color borderDark = Color(0xFF334155);

  static const Color backgroundLight = Color(0xFFF4F6FA);
  static const Color surfaceLight = Colors.white;
  static const Color cardLightAlt = Color(0xFFF8FAFC);
  static const Color borderLight = Color(0xFFE2E8F0);

  static const Color textInk = Color(0xFF0F1C2E);
  static const Color textMutedLight = Color(0xFF52637A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textLabelLight = Color(0xFF64748B);

  static const Color sectionSubtitleDark = Color(0xFF475569);
  static const Color sectionSubtitleLight = Color(0xFF94A3B8);

  static const Color badgeBgDark = Color(0xFF1E293B);
  static const Color badgeBgLight = Color(0xFFF1F5F9);
  static const Color badgeTextDark = Color(0xFF64748B);
  static const Color badgeTextLight = Color(0xFF94A3B8);

  static const Color statusBgDark = Color(0xFF052E25);
  static const Color statusBgLight = Color(0xFFECFDF3);
  static const Color statusBorderDark = Color(0xFF0D7A5F);
  static const Color statusBorderLight = Color(0xFFB7E8C9);
  static const Color statusAccent = Color(0xFF0D7A5F);

  static const Color pillActiveDark = Color(0xFF1E3A8A);
  static const Color pillActiveLight = Color(0xFFE0ECFF);
  static const Color pillActiveBorderDark = Color(0xFF3B82F6);
  static const Color pillActiveBorderLight = Color(0xFFB5CDF7);
  static const Color pillActiveTextDark = Color(0xFFBFDBFE);
  static const Color pillActiveTextLight = Color(0xFF0B57D0);

  static const Color modeBgDark = Color(0xFF1E293B);
  static const Color modeBgLight = Color(0xFFF1F5F9);
  static const Color modeBorderDark = Color(0xFF475569);
  static const Color modeBorderLight = Color(0xFFCBD5E1);
  static const Color modeTextDark = Color(0xFFBFDBFE);
  static const Color modeTextLight = Color(0xFF334155);

  static const Color tintBlue = Color(0xFF0B57D0);
  static const Color tintViolet = Color(0xFF6941C6);
  static const Color tintAmber = Color(0xFFF59E0B);
  static const Color tintSky = Color(0xFF38BDF8);
  static const Color tintRed = Color(0xFFEF4444);
  static const Color tintPurple = Color(0xFF7C3AED);
  static const Color tintGreen = Color(0xFF0D7A5F);
  static const Color accentBlue = Color(0xFF3B82F6);

  static const List<Color> backgroundGradientDark = [
    Color(0xFF070E1A),
    Color(0xFF0B1220),
    Color(0xFF0F172A),
  ];
}

class ShowcaseColorScheme {
  static const ColorScheme ops = ColorScheme.dark(
    primary: ShowcaseColors.primaryBlue,
    secondary: ShowcaseColors.secondaryMint,
    tertiary: ShowcaseColors.tertiaryPurple,
    surface: ShowcaseColors.surfaceDark,
    onSurface: ShowcaseColors.textPrimaryDark,
    onSurfaceVariant: ShowcaseColors.textMutedDark,
    outline: ShowcaseColors.outlineDark,
    outlineVariant: ShowcaseColors.outlineVariantDark,
  );
}

class ControlTabConfig {
  final String label;
  final bool active;

  const ControlTabConfig({required this.label, required this.active});
}

class KpiConfig {
  final String label;
  final String value;
  final Color accent;

  const KpiConfig({
    required this.label,
    required this.value,
    required this.accent,
  });
}

class ShowcaseData {
  static const List<ControlTabConfig> controlTabs = [
    ControlTabConfig(label: ShowcaseStrings.tabAlgorithm, active: true),
    ControlTabConfig(label: ShowcaseStrings.tabModels, active: false),
    ControlTabConfig(label: ShowcaseStrings.tabHowItWorks, active: false),
    ControlTabConfig(label: ShowcaseStrings.tabCustomize, active: false),
  ];

  static const List<KpiConfig> kpis = [
    KpiConfig(
      label: ShowcaseStrings.kpiActiveCasesLabel,
      value: ShowcaseStrings.kpiActiveCasesValue,
      accent: ShowcaseColors.tintBlue,
    ),
    KpiConfig(
      label: ShowcaseStrings.kpiIndexedEntriesLabel,
      value: ShowcaseStrings.kpiIndexedEntriesValue,
      accent: ShowcaseColors.tintPurple,
    ),
    KpiConfig(
      label: ShowcaseStrings.kpiCorrelationHitsLabel,
      value: ShowcaseStrings.kpiCorrelationHitsValue,
      accent: ShowcaseColors.tintRed,
    ),
    KpiConfig(
      label: ShowcaseStrings.kpiWatcherQueueLabel,
      value: ShowcaseStrings.kpiWatcherQueueValue,
      accent: ShowcaseColors.tintGreen,
    ),
  ];
}
