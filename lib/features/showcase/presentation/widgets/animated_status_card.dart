import 'package:flutter/material.dart';
import 'package:spacebar/features/showcase/presentation/widgets/showcase_card.dart';

class AnimatedStatusCard extends StatefulWidget {
  final String title;
  final String description;
  final Map<String, dynamic> mockData;
  final Color? tint;

  const AnimatedStatusCard({
    super.key,
    required this.title,
    required this.description,
    required this.mockData,
    this.tint,
  });

  @override
  State<AnimatedStatusCard> createState() => _AnimatedStatusCardState();
}

class _AnimatedStatusCardState extends State<AnimatedStatusCard>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final newItems = widget.mockData['newItems'] as int? ?? 0;
    final lastScan = widget.mockData['lastScan'] as String? ?? 'N/A';
    final status = widget.mockData['status'] as String? ?? 'inactive';

    return ShowcaseCard(
      title: widget.title,
      description: widget.description,
      tint: widget.tint,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status indicator with pulse
          Row(
            children: [
              ScaleTransition(
                scale: Tween<double>(begin: 0.8, end: 1.2).animate(
                  CurvedAnimation(
                    parent: _pulseController,
                    curve: Curves.easeInOut,
                  ),
                ),
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: status == 'active'
                        ? const Color(0xFF0D7A5F)
                        : const Color(0xFFDDE5F0),
                    shape: BoxShape.circle,
                    boxShadow: status == 'active'
                        ? [
                            BoxShadow(
                              color: const Color(0xFF0D7A5F).withValues(alpha: 0.3),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ]
                        : null,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                status == 'active' ? 'Active' : 'Inactive',
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: status == 'active'
                      ? const Color(0xFF0D7A5F)
                      : const Color(0xFF52637A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatItem(
                label: 'New Items',
                value: newItems.toString(),
                icon: Icons.add_circle_outline,
                color: const Color(0xFF0B57D0),
              ),
              Container(
                width: 1,
                height: 40,
                color: theme.dividerColor.withValues(alpha: 0.3),
              ),
              _StatItem(
                label: 'Last Scan',
                value: lastScan,
                icon: Icons.schedule_outlined,
                color: const Color(0xFF6941C6),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(height: 6),
          Text(
            value,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
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

