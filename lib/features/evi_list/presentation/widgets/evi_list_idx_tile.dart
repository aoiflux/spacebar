import 'package:flutter/material.dart';
import 'package:spacebar/core/common/entities/evidence.dart';
import 'package:spacebar/core/utils/util.dart';

class EviListIdxTile extends StatelessWidget {
  final Evidence idx;

  const EviListIdxTile({super.key, required this.idx});

  static const _tint = Color(0xFF7048E8);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _tint.withValues(alpha: 0.18)),
          color: _tint.withValues(alpha: 0.04),
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
                Icons.description_outlined,
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
                    idx.fileName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF1C2430),
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    idx.fileId,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: const Color(0xFF364254).withValues(alpha: 0.55),
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
                        fmtBytes(idx.compressedSize),
                        _tint,
                      ),
                      _chip(
                        Icons.trending_down_rounded,
                        _ratio(idx.totalSize, idx.compressedSize),
                        _tint,
                      ),
                      _chip(
                        Icons.grid_view_rounded,
                        '${idx.chunkMap.length} chunks',
                        _tint,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
              decoration: BoxDecoration(
                color: _tint.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                fmtBytes(idx.totalSize),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: _tint,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
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
