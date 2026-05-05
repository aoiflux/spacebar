import 'package:flutter/material.dart';

class HomeInfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const HomeInfoChip({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: const Color(0xFFEEF4FF),
        border: Border.all(color: const Color(0xFFBDD2F8)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: const Color(0xFF0B57D0)),
          const SizedBox(width: 7),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: const Color(0xFF2B4B8C),
              fontWeight: FontWeight.w500,
              fontSize: 11.5,
            ),
          ),
        ],
      ),
    );
  }
}
