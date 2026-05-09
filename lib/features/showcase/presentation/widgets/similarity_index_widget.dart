import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:spacebar/features/showcase/presentation/widgets/showcase_card.dart';

class _MethodSignal {
  const _MethodSignal({
    required this.id,
    required this.label,
    required this.weight,
    required this.color,
  });

  final String id;
  final String label;
  final int weight;
  final Color color;
}

class _FileBubble {
  const _FileBubble({
    required this.file,
    required this.score,
    required this.matchedBy,
    required this.repackagedLikelihood,
  });

  final String file;
  final int score;
  final List<String> matchedBy;
  final int repackagedLikelihood;
}

const _defaultMethods = <_MethodSignal>[
  _MethodSignal(
    id: 'exact_hash',
    label: 'Exact',
    weight: 100,
    color: Color(0xFFDC2626),
  ),
  _MethodSignal(
    id: 'chunk_exact',
    label: 'Chunk',
    weight: 88,
    color: Color(0xFFF59E0B),
  ),
  _MethodSignal(
    id: 'chunk_partial_simhash',
    label: 'Partial',
    weight: 72,
    color: Color(0xFF84CC16),
  ),
  _MethodSignal(
    id: 'topk_full_simhash',
    label: 'Top-K',
    weight: 78,
    color: Color(0xFF06B6D4),
  ),
  _MethodSignal(
    id: 'vector_match',
    label: 'Vector',
    weight: 69,
    color: Color(0xFF8B5CF6),
  ),
];

const _defaultRelated = <_FileBubble>[
  _FileBubble(
    file: 'payload_updater_v4.bin',
    score: 96,
    matchedBy: ['exact_hash', 'chunk_exact', 'topk_full_simhash'],
    repackagedLikelihood: 98,
  ),
  _FileBubble(
    file: 'invoice_reader_patch.exe',
    score: 87,
    matchedBy: ['chunk_exact', 'chunk_partial_simhash', 'vector_match'],
    repackagedLikelihood: 91,
  ),
  _FileBubble(
    file: 'svc_update_signed.dat',
    score: 81,
    matchedBy: ['chunk_partial_simhash', 'topk_full_simhash', 'vector_match'],
    repackagedLikelihood: 86,
  ),
  _FileBubble(
    file: 'archive_patch_2026.bin',
    score: 74,
    matchedBy: ['topk_full_simhash', 'vector_match'],
    repackagedLikelihood: 62,
  ),
];

class SimilarityIndexWidget extends StatefulWidget {
  final String title;
  final String description;
  final Map<String, dynamic> mockData;
  final Color? tint;

  const SimilarityIndexWidget({
    super.key,
    required this.title,
    required this.description,
    required this.mockData,
    this.tint,
  });

  @override
  State<SimilarityIndexWidget> createState() => _SimilarityIndexWidgetState();
}

class _SimilarityIndexWidgetState extends State<SimilarityIndexWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int? _hoveredIndex;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tint = widget.tint ?? const Color(0xFFEF4444);
    final isDark = theme.brightness == Brightness.dark;

    final methodsRaw =
        (widget.mockData['methods'] as List?)?.cast<Map<String, dynamic>>() ??
        const [];
    final methods = methodsRaw.isEmpty
        ? _defaultMethods
        : methodsRaw
              .map((m) {
                final colorHex = m['color'] as int?;
                return _MethodSignal(
                  id: m['id'] as String? ?? 'method',
                  label:
                      m['label'] as String? ?? m['id'] as String? ?? 'method',
                  weight: (m['weight'] as num? ?? 50).toInt().clamp(0, 100),
                  color: colorHex != null ? Color(colorHex) : tint,
                );
              })
              .toList(growable: false);

    final relatedRaw =
        (widget.mockData['relatedFiles'] as List?)
            ?.cast<Map<String, dynamic>>() ??
        const [];
    final related =
        relatedRaw.isEmpty
              ? _defaultRelated
              : relatedRaw
                    .map((r) {
                      return _FileBubble(
                        file: r['file'] as String? ?? 'unknown.bin',
                        score: (r['score'] as num? ?? 0).toInt().clamp(0, 100),
                        matchedBy:
                            (r['matchedBy'] as List?)?.cast<String>() ??
                            const <String>[],
                        repackagedLikelihood:
                            (r['repackagedLikelihood'] as num? ?? 0)
                                .toInt()
                                .clamp(0, 100),
                      );
                    })
                    .toList(growable: false)
          ..sort((a, b) => b.score.compareTo(a.score));

    final strongCount = related.where((f) => f.score >= 85).length;
    final avgScore = related.isEmpty
        ? 0
        : (related.fold<int>(0, (s, f) => s + f.score) / related.length)
              .round();

    return ShowcaseCard(
      title: widget.title,
      description: widget.description,
      tint: tint,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SummaryBanner(
            relatedCount: related.length,
            strongCount: strongCount,
            avgScore: avgScore,
            tint: tint,
            isDark: isDark,
          ),
          const SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // File score list
                  _FileScoreList(
                    files: related,
                    hoveredIndex: _hoveredIndex,
                    isDark: isDark,
                    onHover: (index) => setState(() => _hoveredIndex = index),
                    onUnhover: () => setState(() => _hoveredIndex = null),
                  ),
                  const SizedBox(height: 12),
                  // Method x File matrix
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, _) {
                      return _MethodFileMatrix(
                        files: related,
                        methods: methods,
                        hoveredIndex: _hoveredIndex,
                        animation: _controller.value,
                        isDark: isDark,
                        onHoverFile: (index) =>
                            setState(() => _hoveredIndex = index),
                        onUnhoverFile: () =>
                            setState(() => _hoveredIndex = null),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryBanner extends StatelessWidget {
  const _SummaryBanner({
    required this.relatedCount,
    required this.strongCount,
    required this.avgScore,
    required this.tint,
    required this.isDark,
  });

  final int relatedCount;
  final int strongCount;
  final int avgScore;
  final Color tint;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: tint.withOpacity(isDark ? 0.13 : 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: tint.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: tint, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$relatedCount related files',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: isDark
                        ? const Color(0xFFE2E8F0)
                        : const Color(0xFF1E293B),
                  ),
                ),
                Text(
                  '$strongCount strong · avg $avgScore%',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? const Color(0xFFA1A7B5)
                        : const Color(0xFF64748B),
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

class _FileScoreList extends StatelessWidget {
  const _FileScoreList({
    required this.files,
    required this.hoveredIndex,
    required this.isDark,
    required this.onHover,
    required this.onUnhover,
  });

  final List<_FileBubble> files;
  final int? hoveredIndex;
  final bool isDark;
  final Function(int) onHover;
  final VoidCallback onUnhover;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0B1324) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: files.asMap().entries.map((entry) {
          final index = entry.key;
          final file = entry.value;
          final isHovered = hoveredIndex == index;

          return MouseRegion(
            onEnter: (_) => onHover(index),
            onExit: (_) => onUnhover(),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      file.file,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontSize: 8.5,
                        fontWeight: FontWeight.w700,
                        color: isHovered
                            ? (isDark
                                  ? const Color(0xFF60A5FA)
                                  : const Color(0xFF0B57D0))
                            : (isDark
                                  ? const Color(0xFFE2E8F0)
                                  : const Color(0xFF0F172A)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  // Score bar
                  Expanded(
                    flex: 1,
                    child: Stack(
                      children: [
                        Container(
                          height: 16,
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF1E293B)
                                : const Color(0xFFE2E8F0),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: Container(
                            height: 16,
                            width: (file.score / 100) * 100,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  file.score >= 85
                                      ? const Color(0xFFDC2626)
                                      : const Color(0xFFF59E0B),
                                  file.score >= 85
                                      ? const Color(0xFFEF4444)
                                      : const Color(0xFFFCD34D),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  SizedBox(
                    width: 28,
                    child: Text(
                      '${file.score}%',
                      textAlign: TextAlign.right,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontSize: 8.5,
                        fontWeight: FontWeight.w800,
                        color: file.score >= 85
                            ? const Color(0xFFDC2626)
                            : (isDark
                                  ? const Color(0xFFCBD5E1)
                                  : const Color(0xFF64748B)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _MethodFileMatrix extends StatelessWidget {
  const _MethodFileMatrix({
    required this.files,
    required this.methods,
    required this.hoveredIndex,
    required this.animation,
    required this.isDark,
    required this.onHoverFile,
    required this.onUnhoverFile,
  });

  final List<_FileBubble> files;
  final List<_MethodSignal> methods;
  final int? hoveredIndex;
  final double animation;
  final bool isDark;
  final Function(int) onHoverFile;
  final VoidCallback onUnhoverFile;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0B1324) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Method header row
          Padding(
            padding: const EdgeInsets.only(left: 100, bottom: 4),
            child: Row(
              children: methods.map((method) {
                return Expanded(
                  child: Center(
                    child: Text(
                      method.label,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontSize: 7.5,
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF64748B),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 2),
          // Matrix rows
          Column(
            children: files.asMap().entries.map((entry) {
              final index = entry.key;
              final file = entry.value;
              final isHovered = hoveredIndex == index;

              return MouseRegion(
                onEnter: (_) => onHoverFile(index),
                onExit: (_) => onUnhoverFile(),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      // File name label
                      SizedBox(
                        width: 100,
                        child: Text(
                          file.file.length > 14
                              ? file.file.substring(0, 11) + '..'
                              : file.file,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                fontSize: 8,
                                fontWeight: FontWeight.w700,
                                color: isHovered
                                    ? (isDark
                                          ? const Color(0xFF60A5FA)
                                          : const Color(0xFF0B57D0))
                                    : (isDark
                                          ? const Color(0xFFA1A7B5)
                                          : const Color(0xFF64748B)),
                              ),
                        ),
                      ),
                      // Method cells
                      Expanded(
                        child: Row(
                          children: methods.map((method) {
                            final matched = file.matchedBy.contains(method.id);
                            final pulse =
                                0.6 +
                                (math.sin(
                                          (animation + index * 0.1) *
                                              2 *
                                              math.pi,
                                        ) +
                                        1) *
                                    0.2;

                            return Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 2,
                                  vertical: 1,
                                ),
                                child: Container(
                                  height: 18,
                                  decoration: BoxDecoration(
                                    color: matched
                                        ? method.color.withOpacity(
                                            isHovered ? pulse : 0.7,
                                          )
                                        : (isDark
                                              ? const Color(0xFF1E293B)
                                              : const Color(0xFFE2E8F0)),
                                    borderRadius: BorderRadius.circular(3),
                                    border: isHovered && matched
                                        ? Border.all(
                                            color: method.color,
                                            width: 1.5,
                                          )
                                        : null,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
