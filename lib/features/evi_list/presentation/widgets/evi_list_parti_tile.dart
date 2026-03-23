import 'package:flutter/material.dart';
import 'package:spacebar/core/common/entities/evidence.dart';
import 'package:spacebar/core/utils/util.dart';
import 'package:spacebar/features/evi_list/presentation/widgets/evi_list_idx_tile.dart';

class EviListPartiTile extends StatefulWidget {
  final Evidence parti;
  final List<Evidence>? idxFiles;
  final bool idxLoading;
  final VoidCallback onExpand;

  const EviListPartiTile({
    super.key,
    required this.parti,
    required this.idxFiles,
    required this.idxLoading,
    required this.onExpand,
  });

  @override
  State<EviListPartiTile> createState() => _EviListPartiTileState();
}

class _EviListPartiTileState extends State<EviListPartiTile> {
  bool _expanded = false;

  static const _tint = Color(0xFF0CA678);

  void _toggle() {
    setState(() => _expanded = !_expanded);
    if (_expanded && widget.idxFiles == null && !widget.idxLoading) {
      widget.onExpand();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _tint.withValues(alpha: 0.22)),
          color: Colors.white.withValues(alpha: 0.65),
          boxShadow: [
            BoxShadow(
              color: _tint.withValues(alpha: 0.07),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _toggle,
              borderRadius: BorderRadius.circular(14),
              splashColor: _tint.withValues(alpha: 0.08),
              highlightColor: _tint.withValues(alpha: 0.04),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 11,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: _tint.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(9),
                          ),
                          child: const Icon(
                            Icons.storage_outlined,
                            color: _tint,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.parti.fileName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF1C2430),
                                ),
                              ),
                              const SizedBox(height: 1),
                              Text(
                                widget.parti.fileId,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: const Color(
                                    0xFF364254,
                                  ).withValues(alpha: 0.55),
                                  letterSpacing: 0.1,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Wrap(
                                spacing: 6,
                                runSpacing: 4,
                                children: [
                                  _chip(
                                    Icons.compress_rounded,
                                    fmtBytes(widget.parti.compressedSize),
                                    _tint,
                                  ),
                                  _chip(
                                    Icons.trending_down_rounded,
                                    _ratio(
                                      widget.parti.totalSize,
                                      widget.parti.compressedSize,
                                    ),
                                    _tint,
                                  ),
                                  _chip(
                                    Icons.grid_view_rounded,
                                    '${widget.parti.chunkMap.length} chunks',
                                    _tint,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (widget.idxLoading)
                          const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: _tint,
                            ),
                          )
                        else ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 9,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _tint.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              fmtBytes(widget.parti.totalSize),
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: _tint,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          AnimatedRotation(
                            turns: _expanded ? 0.5 : 0,
                            duration: const Duration(milliseconds: 200),
                            child: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: _tint,
                              size: 20,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOutCubic,
                    child: _expanded
                        ? _buildChildren(theme)
                        : const SizedBox(width: double.infinity),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChildren(ThemeData theme) {
    if (widget.idxLoading) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator(color: _tint)),
      );
    }

    if (widget.idxFiles == null) {
      return const SizedBox(width: double.infinity);
    }

    if (widget.idxFiles!.isEmpty) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey.withValues(alpha: 0.07),
          ),
          child: Text(
            'No indexed files',
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.grey.shade500,
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
      child: Column(
        children: widget.idxFiles!
            .map((idx) => EviListIdxTile(idx: idx))
            .toList(),
      ),
    );
  }
}

String _ratio(int total, int compressed) {
  if (total <= 0) return '—';
  final pct = ((1 - compressed / total) * 100).round().clamp(0, 100);
  return '$pct% saved';
}

Widget _chip(IconData icon, String label, Color tint) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
    decoration: BoxDecoration(
      color: tint.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: tint.withValues(alpha: 0.15)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 11, color: tint.withValues(alpha: 0.75)),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10.5,
            color: tint,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}
