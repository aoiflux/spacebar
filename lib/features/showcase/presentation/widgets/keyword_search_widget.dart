import 'dart:async';

import 'package:flutter/material.dart';
import 'package:spacebar/features/showcase/presentation/widgets/showcase_card.dart';

class KeywordSearchWidget extends StatefulWidget {
  final String title;
  final String description;
  final Map<String, dynamic> mockData;
  final Color? tint;

  const KeywordSearchWidget({
    super.key,
    required this.title,
    required this.description,
    required this.mockData,
    this.tint,
  });

  @override
  State<KeywordSearchWidget> createState() => _KeywordSearchWidgetState();
}

class _KeywordSearchWidgetState extends State<KeywordSearchWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _typingProgress;
  late final List<_KeywordHighlight> _highlights;
  late final List<_KeywordResultSet> _querySets;
  int _activeQueryIndex = 0;
  int _activeResultIndex = 0;
  bool _resultsVisible = false;
  Timer? _resultTimer;

  @override
  void initState() {
    super.initState();
    _highlights = _parseHighlights(widget.mockData);
    _querySets = _parseQuerySets(widget.mockData);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3400),
    );
    _controller.addListener(() {
      if (_resultsVisible || _controller.value < 0.56 || !mounted) return;

      setState(() {
        _resultsVisible = true;
        _activeResultIndex = 0;
      });
      _restartResultTimer();
    });

    _controller.addStatusListener((status) {
      if (status != AnimationStatus.completed) return;

      _resultTimer?.cancel();
      if (_querySets.length > 1 && mounted) {
        setState(() {
          _activeQueryIndex = (_activeQueryIndex + 1) % _querySets.length;
          _resultsVisible = false;
          _activeResultIndex = 0;
        });
      } else if (mounted) {
        setState(() {
          _resultsVisible = false;
          _activeResultIndex = 0;
        });
      }

      _controller.forward(from: 0);
    });
    _controller.forward();

    _typingProgress = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _resultTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tint = widget.tint ?? const Color(0xFF38BDF8);
    final highlights = _highlights;
    final activeSet = _querySets.isEmpty
        ? const _KeywordResultSet('persistence', <String>[])
        : _querySets[_activeQueryIndex.clamp(0, _querySets.length - 1)];
    final query = activeSet.keyword;
    final results = activeSet.results;
    final hits = results.length;
    final highlightedIndex = (!_resultsVisible || results.isEmpty)
        ? -1
        : _activeResultIndex.clamp(0, results.length - 1);
    final artifactTypes = results
        .map((r) => r.split(':').first.trim())
        .toSet()
        .length;

    return ShowcaseCard(
      title: widget.title,
      description: widget.description,
      tint: tint,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compactLayout = constraints.maxWidth < 320;
          final isDark = theme.brightness == Brightness.dark;
          final activeHighlight = highlights.isEmpty
              ? null
              : highlights[_activeQueryIndex % highlights.length];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (highlights.isNotEmpty) ...[
                if (compactLayout)
                  _FeatureHighlightCard(
                    highlight: activeHighlight!,
                    tint: tint,
                    isDark: isDark,
                    icon: _featureIconFor(_activeQueryIndex),
                    compact: true,
                  )
                else
                  SizedBox(
                    height: 88,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.zero,
                      physics: const BouncingScrollPhysics(),
                      itemCount: highlights.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final highlight = highlights[index];
                        return SizedBox(
                          width: 188,
                          child: _FeatureHighlightCard(
                            highlight: highlight,
                            tint: tint,
                            isDark: isDark,
                            icon: _featureIconFor(index),
                          ),
                        );
                      },
                    ),
                  ),
                SizedBox(height: compactLayout ? 8 : 10),
              ],
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: compactLayout ? 9 : 10,
                  vertical: compactLayout ? 8 : 9,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      tint.withValues(alpha: 0.18),
                      tint.withValues(alpha: 0.07),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: tint.withValues(alpha: 0.35)),
                ),
                child: Semantics(
                  container: true,
                  readOnly: true,
                  label: 'query: $query',
                  child: ExcludeSemantics(
                    child: Row(
                      children: [
                        Icon(
                          Icons.search_rounded,
                          size: compactLayout ? 15 : 16,
                          color: tint,
                        ),
                        SizedBox(width: compactLayout ? 6 : 8),
                        Expanded(
                          child: AnimatedBuilder(
                            animation: _typingProgress,
                            builder: (context, _) {
                              final progress = _typingProgress.value;
                              final typingPhase = (progress / 0.56).clamp(
                                0.0,
                                1.0,
                              );
                              final effectiveQuery = query.isEmpty
                                  ? 'search'
                                  : query;
                              final chars = (query.length * typingPhase).clamp(
                                1,
                                effectiveQuery.length,
                              );
                              final typedQuery = effectiveQuery.substring(
                                0,
                                chars.toInt(),
                              );
                              return RichText(
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                text: TextSpan(
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    fontSize: compactLayout ? 10 : 11,
                                    fontWeight: FontWeight.w600,
                                    color: isDark
                                        ? const Color(0xFFE2E8F0)
                                        : const Color(0xFF0F172A),
                                  ),
                                  children: [
                                    const TextSpan(text: 'query: '),
                                    TextSpan(
                                      text: typedQuery,
                                      style: TextStyle(
                                        color: tint,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    if (typingPhase < 1)
                                      const TextSpan(text: '▌'),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: compactLayout ? 8 : 10),
              Expanded(
                child: Semantics(
                  container: true,
                  readOnly: true,
                  label: '$hits results for $query',
                  child: ExcludeSemantics(
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOutCubic,
                      opacity: _resultsVisible ? 1 : 0,
                      child: ListView.separated(
                        padding: EdgeInsets.zero,
                        itemCount: results.length,
                        physics: const BouncingScrollPhysics(),
                        separatorBuilder: (_, _) =>
                            SizedBox(height: compactLayout ? 6 : 8),
                        itemBuilder: (context, index) {
                          final item = results[index];
                          final highlighted = index == highlightedIndex;

                          return Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: compactLayout ? 9 : 10,
                              vertical: compactLayout ? 7 : 8,
                            ),
                            decoration: BoxDecoration(
                              color: highlighted
                                  ? tint.withValues(alpha: 0.15)
                                  : (isDark
                                        ? const Color(0xFF111827)
                                        : const Color(0xFFF8FAFC)),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: highlighted
                                    ? tint.withValues(alpha: 0.5)
                                    : tint.withValues(alpha: 0.2),
                              ),
                              boxShadow: highlighted
                                  ? [
                                      BoxShadow(
                                        color: tint.withValues(alpha: 0.16),
                                        blurRadius: 10,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: highlighted
                                        ? tint
                                        : tint.withValues(alpha: 0.4),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: compactLayout ? 6 : 8),
                                Expanded(
                                  child: Text(
                                    item,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      fontSize: compactLayout ? 9 : 10,
                                      fontWeight: FontWeight.w700,
                                      color: isDark
                                          ? const Color(0xFFCBD5E1)
                                          : const Color(0xFF1E293B),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: compactLayout ? 6 : 8),
              Row(
                children: [
                  _StatPill(
                    label: 'Hits',
                    value: '$hits',
                    color: const Color(0xFF0EA5E9),
                    compact: compactLayout,
                  ),
                  SizedBox(width: compactLayout ? 6 : 8),
                  _StatPill(
                    label: 'Artefact Types',
                    value: '$artifactTypes',
                    color: const Color(0xFF7C3AED),
                    compact: compactLayout,
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  List<_KeywordResultSet> _parseQuerySets(Map<String, dynamic> mockData) {
    final raw = mockData['queries'];
    if (raw is List) {
      final parsed = raw
          .whereType<Map>()
          .map((entry) {
            final keyword = (entry['keyword'] as String?)?.trim() ?? '';
            if (keyword.isEmpty) return null;
            final results =
                (entry['results'] as List?)?.whereType<String>().toList() ??
                const <String>[];
            return _KeywordResultSet(keyword, results);
          })
          .whereType<_KeywordResultSet>()
          .take(5)
          .toList();

      if (parsed.isNotEmpty) return parsed;
    }

    final fallbackQuery = (mockData['query'] as String?) ?? 'persistence';
    final fallbackResults =
        (mockData['results'] as List?)?.whereType<String>().toList() ??
        const <String>[];
    return [_KeywordResultSet(fallbackQuery, fallbackResults)];
  }

  List<_KeywordHighlight> _parseHighlights(Map<String, dynamic> mockData) {
    final raw = mockData['highlights'];
    if (raw is! List) return const <_KeywordHighlight>[];

    return raw
        .whereType<Map>()
        .map((entry) {
          final title = (entry['title'] as String?)?.trim() ?? '';
          final detail = (entry['detail'] as String?)?.trim() ?? '';
          if (title.isEmpty || detail.isEmpty) return null;
          return _KeywordHighlight(title, detail);
        })
        .whereType<_KeywordHighlight>()
        .take(3)
        .toList();
  }

  IconData _featureIconFor(int index) {
    switch (index % 3) {
      case 0:
        return Icons.document_scanner_outlined;
      case 1:
        return Icons.account_tree_outlined;
      default:
        return Icons.find_in_page_outlined;
    }
  }

  void _restartResultTimer() {
    _resultTimer?.cancel();
    final activeSet = _querySets.isEmpty
        ? const _KeywordResultSet('persistence', <String>[])
        : _querySets[_activeQueryIndex.clamp(0, _querySets.length - 1)];
    final results = activeSet.results;

    if (results.length <= 1) return;

    _resultTimer = Timer.periodic(const Duration(milliseconds: 420), (_) {
      if (!mounted || !_resultsVisible) return;
      setState(() {
        _activeResultIndex = (_activeResultIndex + 1) % results.length;
      });
    });
  }
}

class _KeywordResultSet {
  final String keyword;
  final List<String> results;

  const _KeywordResultSet(this.keyword, this.results);
}

class _KeywordHighlight {
  final String title;
  final String detail;

  const _KeywordHighlight(this.title, this.detail);
}

class _FeatureHighlightCard extends StatelessWidget {
  final _KeywordHighlight highlight;
  final Color tint;
  final bool isDark;
  final IconData icon;
  final bool compact;

  const _FeatureHighlightCard({
    required this.highlight,
    required this.tint,
    required this.isDark,
    required this.icon,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      readOnly: true,
      label: '${highlight.title}: ${highlight.detail}',
      child: ExcludeSemantics(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 9 : 10,
            vertical: compact ? 8 : 9,
          ),
          decoration: BoxDecoration(
            color: tint.withValues(alpha: isDark ? 0.12 : 0.08),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: tint.withValues(alpha: 0.24)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: compact ? 13 : 14, color: tint),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      highlight.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontSize: compact ? 9 : 10,
                        fontWeight: FontWeight.w800,
                        color: isDark
                            ? const Color(0xFFE2E8F0)
                            : const Color(0xFF0F172A),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: compact ? 6 : 8),
              Text(
                highlight.detail,
                maxLines: compact ? 2 : 3,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontSize: compact ? 8.5 : 9,
                  height: 1.35,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? const Color(0xFFCBD5E1)
                      : const Color(0xFF334155),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final bool compact;

  const _StatPill({
    required this.label,
    required this.value,
    required this.color,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 7 : 8,
          vertical: compact ? 6 : 7,
        ),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.28)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: color,
                fontSize: compact ? 10 : 11,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFF94A3B8)
                    : const Color(0xFF64748B),
                fontSize: compact ? 8 : 9,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
