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

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    _typingProgress = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final query = widget.mockData['query'] as String? ?? 'persistence';
    final results =
        (widget.mockData['results'] as List?)?.cast<String>() ??
        const <String>[];
    final hits = results.length;
    final artifactTypes = results
        .map((r) => r.split(':').first.trim())
        .toSet()
        .length;
    final tint = widget.tint ?? const Color(0xFF38BDF8);

    return ShowcaseCard(
      title: widget.title,
      description: widget.description,
      tint: tint,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedBuilder(
            animation: _typingProgress,
            builder: (context, _) {
              final chars = (query.length * _typingProgress.value).clamp(
                1,
                query.length,
              );
              final typedQuery = query.substring(0, chars.toInt());

              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: theme.brightness == Brightness.dark
                      ? const Color(0xFF0B1324)
                      : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: tint.withOpacity(0.35)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search_rounded, size: 16, color: tint),
                    const SizedBox(width: 8),
                    Expanded(
                      child: RichText(
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
                              text: typedQuery,
                              style: TextStyle(
                                color: tint,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            if (typedQuery.length < query.length)
                              const TextSpan(text: '▌'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.zero,
              itemCount: results.length,
              physics: const BouncingScrollPhysics(),
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final item = results[index];
                return AnimatedBuilder(
                  animation: _typingProgress,
                  builder: (context, _) {
                    final active =
                        (_typingProgress.value * results.length).floor() %
                        results.length;
                    final highlighted = index == active;

                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: highlighted
                            ? tint.withOpacity(0.12)
                            : (theme.brightness == Brightness.dark
                                  ? const Color(0xFF111827)
                                  : const Color(0xFFF8FAFC)),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: highlighted
                              ? tint.withOpacity(0.45)
                              : tint.withOpacity(0.18),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: highlighted ? tint : tint.withOpacity(0.4),
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
                );
              },
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
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.28)),
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
