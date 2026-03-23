import 'package:flutter/material.dart';

class EviListEmpty extends StatelessWidget {
  final VoidCallback onRefresh;

  const EviListEmpty({super.key, required this.onRefresh});

  static const _tint = Color(0xFF2D7FF9);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: _tint.withValues(alpha: 0.08),
                shape: BoxShape.circle,
                border: Border.all(color: _tint.withValues(alpha: 0.18)),
              ),
              child: const Icon(
                Icons.inventory_2_outlined,
                size: 40,
                color: _tint,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'No evidence files',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: cs.onSurface,
                letterSpacing: 0.1,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Evidence files ingested via the store will appear here.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: cs.onSurface.withValues(alpha: 0.55),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.tonal(
              onPressed: onRefresh,
              style: FilledButton.styleFrom(
                backgroundColor: _tint.withValues(alpha: 0.1),
                foregroundColor: _tint,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: _tint.withValues(alpha: 0.28)),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.refresh, size: 18),
                  SizedBox(width: 8),
                  Text('Refresh'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
