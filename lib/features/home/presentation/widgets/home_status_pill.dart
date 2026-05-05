import 'package:flutter/material.dart';

class HomeStatusPill extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color tint;

  const HomeStatusPill({
    super.key,
    required this.label,
    required this.icon,
    required this.tint,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: tint.withValues(alpha: 0.08),
        border: Border.all(color: tint.withValues(alpha: 0.30)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: tint),
          const SizedBox(width: 5),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: tint,
              fontWeight: FontWeight.w600,
              fontSize: 11,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
