import 'package:flutter/material.dart';
import 'package:spacebar/features/showcase/presentation/widgets/showcase_card.dart';

class IconGridWidget extends StatelessWidget {
  final String title;
  final String description;
  final List<Map<String, dynamic>> icons;
  final Color? tint;

  const IconGridWidget({
    super.key,
    required this.title,
    required this.description,
    required this.icons,
    this.tint,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ShowcaseCard(
      title: title,
      description: description,
      tint: tint,
      child: GridView.count(
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.2,
        children: List.generate(icons.length, (index) {
          final icon = icons[index];
          final format = icon['format'] as String? ?? 'Format';
          final iconSymbol = icon['icon'] as String? ?? '📄';
          final color = icon['color'] as int? ?? 0xFFE8EDF5;

          return Container(
            decoration: BoxDecoration(
              color: Color(color).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Color(color).withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(iconSymbol, style: const TextStyle(fontSize: 32)),
                const SizedBox(height: 8),
                Text(
                  format,
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                    color: const Color(0xFF0F1C2E),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

