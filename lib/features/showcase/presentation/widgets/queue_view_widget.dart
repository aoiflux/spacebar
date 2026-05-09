import 'package:flutter/material.dart';
import 'package:spacebar/features/showcase/presentation/widgets/showcase_card.dart';

class QueueViewWidget extends StatelessWidget {
  final String title;
  final String description;
  final Map<String, dynamic> mockData;
  final Color? tint;

  const QueueViewWidget({
    super.key,
    required this.title,
    required this.description,
    required this.mockData,
    this.tint,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pending = mockData['pending'] as int? ?? 0;
    final verified = mockData['verified'] as int? ?? 0;
    final rejected = mockData['rejected'] as int? ?? 0;
    final successRate = mockData['successRate'] as num? ?? 85;

    final total = pending + verified + rejected;

    return ShowcaseCard(
      title: title,
      description: description,
      tint: tint,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Success rate header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF0D7A5F).withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFF0D7A5F).withOpacity(0.15),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Success Rate',
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF52637A),
                  ),
                ),
                Text(
                  '${successRate.toStringAsFixed(0)}%',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    color: const Color(0xFF0D7A5F),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Queue status cards
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.0,
              children: [
                _QueueStatusCard(
                  label: 'Pending',
                  count: pending,
                  icon: Icons.hourglass_empty_outlined,
                  color: const Color(0xFFF59E0B),
                  theme: theme,
                ),
                _QueueStatusCard(
                  label: 'Verified',
                  count: verified,
                  icon: Icons.check_circle_outline,
                  color: const Color(0xFF0D7A5F),
                  theme: theme,
                ),
                _QueueStatusCard(
                  label: 'Rejected',
                  count: rejected,
                  icon: Icons.cancel_outlined,
                  color: const Color(0xFFEF4444),
                  theme: theme,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // Progress bar
          Container(
            height: 6,
            decoration: BoxDecoration(
              color: theme.dividerColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(3),
            ),
            clipBehavior: Clip.hardEdge,
            child: Row(
              children: [
                if (verified > 0)
                  Expanded(
                    flex: verified,
                    child: Container(color: const Color(0xFF0D7A5F)),
                  ),
                if (pending > 0)
                  Expanded(
                    flex: pending,
                    child: Container(color: const Color(0xFFF59E0B)),
                  ),
                if (rejected > 0)
                  Expanded(
                    flex: rejected,
                    child: Container(color: const Color(0xFFEF4444)),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Total count
          Text(
            'Total reviewed: $total items',
            style: theme.textTheme.labelSmall?.copyWith(
              fontSize: 10,
              color: const Color(0xFF52637A),
            ),
          ),
        ],
      ),
    );
  }
}

class _QueueStatusCard extends StatelessWidget {
  final String label;
  final int count;
  final IconData icon;
  final Color color;
  final ThemeData theme;

  const _QueueStatusCard({
    required this.label,
    required this.count,
    required this.icon,
    required this.color,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.2), width: 1.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: 6),
          Text(
            count.toString(),
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              fontSize: 9,
              color: const Color(0xFF52637A),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
