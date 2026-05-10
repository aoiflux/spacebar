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
  late final List<_KeywordResultSet> _querySets;
  int _activeQueryIndex = 0;
  int _activeResultIndex = 0;
  bool _resultsVisible = false;
  Timer? _resultTimer;

  @override
  void initState() {
    super.initState();
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
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
                    Icon(Icons.search_rounded, size: 16, color: tint),
                    const SizedBox(width: 8),
                    Expanded(
                      child: AnimatedBuilder(
                        animation: _typingProgress,
                        builder: (context, _) {
                          final progress = _typingProgress.value;
                          final typingPhase = (progress / 0.56).clamp(0.0, 1.0);
                          final chars = (query.length * typingPhase).clamp(
                            1,
                            query.length,
                          );
                          final typedQuery = query.substring(0, chars.toInt());
                          return RichText(
                            text: TextSpan(
                              style: theme.textTheme.labelSmall?.copyWith(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: theme.brightness == Brightness.dark
                                    ? const Color(0xFFE2E8F0)
                                    : const Color(0xFF0F172A),
                              ),
                              children: [
                                const TextSpan(text: 'query: '),
                                TextSpan(
                                  text: typedQuery.toLowerCase(),
                                  style: TextStyle(
                                    color: tint,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                if (typingPhase < 1) const TextSpan(text: '▌'),
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
          const SizedBox(height: 10),
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
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final item = results[index];
                      final highlighted = index == highlightedIndex;

                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: highlighted
                              ? tint.withValues(alpha: 0.15)
                              : (theme.brightness == Brightness.dark
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
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                item,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: theme.brightness == Brightness.dark
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
          const SizedBox(height: 8),
          Row(
            children: [
              _StatPill(
                label: 'Hits',
                value: '$hits',
                color: const Color(0xFF0EA5E9),
              ),
              const SizedBox(width: 8),
              _StatPill(
                label: 'Artefact Types',
                value: '$artifactTypes',
                color: const Color(0xFF7C3AED),
              ),
            ],
          ),
        ],
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
            final isSingleWord = keyword.isNotEmpty && !keyword.contains(' ');
            if (!isSingleWord) return null;
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

class _StatPill extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatPill({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
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
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFF94A3B8)
                    : const Color(0xFF64748B),
                fontSize: 9,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
