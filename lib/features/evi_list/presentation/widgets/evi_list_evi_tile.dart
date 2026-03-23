import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:spacebar/core/common/entities/evidence.dart';
import 'package:spacebar/core/utils/util.dart';
import 'package:spacebar/features/evi_list/presentation/widgets/evi_list_parti_tile.dart';
import 'package:spacebar/features/evi_store/presentation/pages/evi_store_page.dart';

class EviListEviTile extends StatefulWidget {
  final Evidence evi;
  final List<Evidence>? partiFiles;
  final bool partiLoading;
  final Map<String, List<Evidence>> idxFilesByParti;
  final Set<String> idxLoadingIds;
  final bool selectionMode;
  final bool selected;
  final VoidCallback onSelectionToggle;
  final VoidCallback onExpand;
  final void Function(String partiFileId) onPartiExpand;

  const EviListEviTile({
    super.key,
    required this.evi,
    required this.partiFiles,
    required this.partiLoading,
    required this.idxFilesByParti,
    required this.idxLoadingIds,
    required this.selectionMode,
    required this.selected,
    required this.onSelectionToggle,
    required this.onExpand,
    required this.onPartiExpand,
  });

  @override
  State<EviListEviTile> createState() => _EviListEviTileState();
}

class _EviListEviTileState extends State<EviListEviTile> {
  bool _expanded = false;
  bool _hovered = false;

  static const _tint = Color(0xFF2D7FF9);

  void _toggle() {
    setState(() => _expanded = !_expanded);
    if (_expanded && widget.partiFiles == null && !widget.partiLoading) {
      widget.onExpand();
    }
  }

  void _onPrimaryTap(BuildContext context) {
    if (widget.selectionMode) {
      widget.onSelectionToggle();
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EviStorePage(initialEvidence: widget.evi),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          transform: Matrix4.translationValues(0, _hovered ? -3 : 0, 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: _tint.withValues(alpha: _hovered ? 0.42 : 0.22),
              width: 1.2,
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.78),
                Colors.white.withValues(alpha: 0.52),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: _tint.withValues(alpha: _hovered ? 0.18 : 0.08),
                blurRadius: _hovered ? 32 : 16,
                offset: Offset(0, _hovered ? 14 : 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Material(
                color: Colors.transparent,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 14,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _onPrimaryTap(context),
                              child: Row(
                                children: [
                                  Container(
                                    width: 42,
                                    height: 42,
                                    decoration: BoxDecoration(
                                      color: _tint.withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.inventory_2_outlined,
                                      color: _tint,
                                      size: 22,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.evi.fileName,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: theme.textTheme.titleSmall
                                              ?.copyWith(
                                                fontWeight: FontWeight.w700,
                                                color: const Color(0xFF1C2430),
                                                letterSpacing: 0.1,
                                              ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          widget.evi.fileId,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: theme.textTheme.labelSmall
                                              ?.copyWith(
                                                color: const Color(
                                                  0xFF364254,
                                                ).withValues(alpha: 0.55),
                                                letterSpacing: 0.2,
                                              ),
                                        ),
                                        const SizedBox(height: 6),
                                        Wrap(
                                          spacing: 6,
                                          runSpacing: 4,
                                          children: [
                                            _chip(
                                              Icons.compress_rounded,
                                              fmtBytes(
                                                widget.evi.compressedSize,
                                              ),
                                              _tint,
                                            ),
                                            _chip(
                                              Icons.trending_down_rounded,
                                              _ratio(
                                                widget.evi.totalSize,
                                                widget.evi.compressedSize,
                                              ),
                                              _tint,
                                            ),
                                            _chip(
                                              Icons.grid_view_rounded,
                                              '${widget.evi.chunkMap.length} chunks',
                                              _tint,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          if (widget.selectionMode)
                            Checkbox(
                              value: widget.selected,
                              activeColor: _tint,
                              onChanged: (_) => widget.onSelectionToggle(),
                            ),
                          if (widget.partiLoading)
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
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _tint.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                fmtBytes(widget.evi.totalSize),
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: _tint,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            InkWell(
                              onTap: _toggle,
                              borderRadius: BorderRadius.circular(4),
                              splashColor: _tint.withValues(alpha: 0.08),
                              highlightColor: _tint.withValues(alpha: 0.04),
                              child: AnimatedRotation(
                                turns: _expanded ? 0.5 : 0,
                                duration: const Duration(milliseconds: 200),
                                child: const Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: _tint,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 230),
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
      ),
    );
  }

  Widget _buildChildren(ThemeData theme) {
    if (widget.partiLoading) {
      return const Padding(
        padding: EdgeInsets.all(18),
        child: Center(child: CircularProgressIndicator(color: _tint)),
      );
    }

    if (widget.partiFiles == null) {
      return const SizedBox(width: double.infinity);
    }

    if (widget.partiFiles!.isEmpty) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(18, 0, 18, 14),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey.withValues(alpha: 0.07),
          ),
          child: Text(
            'No partition files',
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.grey.shade500,
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 14),
      child: Column(
        children: widget.partiFiles!
            .map(
              (p) => EviListPartiTile(
                parti: p,
                idxFiles: widget.idxFilesByParti[p.fileId],
                idxLoading: widget.idxLoadingIds.contains(p.fileId),
                onExpand: () => widget.onPartiExpand(p.fileId),
              ),
            )
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
