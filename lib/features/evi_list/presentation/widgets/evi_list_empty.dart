import 'package:flutter/material.dart';

class EviListEmpty extends StatelessWidget {
  final VoidCallback onRefresh;

  const EviListEmpty({super.key, required this.onRefresh});

  static const _tint = Color(0xFF0B57D0);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: _tint.withValues(alpha: 0.07),
                shape: BoxShape.circle,
                border: Border.all(color: _tint.withValues(alpha: 0.2)),
              ),
              child: const Icon(
                Icons.inventory_2_outlined,
                size: 38,
                color: _tint,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'No evidence files',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0F1C2E),
                letterSpacing: 0.1,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Evidence files ingested via the store will appear here.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF52637A),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            TextButton.icon(
              onPressed: onRefresh,
              icon: const Icon(Icons.refresh, size: 16, color: _tint),
              label: const Text(
                'Refresh',
                style: TextStyle(color: _tint, fontWeight: FontWeight.w600),
              ),
              style: TextButton.styleFrom(
                backgroundColor: _tint.withValues(alpha: 0.08),
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: _tint.withValues(alpha: 0.22)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
