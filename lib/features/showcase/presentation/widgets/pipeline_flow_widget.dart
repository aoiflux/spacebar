import 'package:flutter/material.dart';
import 'package:spacebar/features/showcase/presentation/widgets/showcase_card.dart';

class PipelineFlowWidget extends StatelessWidget {
  final String title;
  final String description;
  final List<String> stages;
  final Color? tint;

  const PipelineFlowWidget({
    super.key,
    required this.title,
    required this.description,
    required this.stages,
    this.tint,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final stageCount = stages.length;

    return ShowcaseCard(
      title: title,
      description: description,
      tint: tint,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Pipeline flow visualization
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              stageCount,
              (index) => Expanded(
                child: Row(
                  children: [
                    // Stage
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  tint?.withOpacity(0.8) ??
                                      const Color(0xFF0B57D0),
                                  tint?.withOpacity(0.6) ??
                                      const Color(0xFF0B57D0).withOpacity(0.6),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: (tint ?? const Color(0xFF0B57D0))
                                      .withOpacity(0.2),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            stages[index],
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                              color: const Color(0xFF0F1C2E),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    // Arrow (except for last stage)
                    if (index < stageCount - 1)
                      Expanded(
                        flex: 0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Column(
                            children: [
                              const SizedBox(height: 8),
                              Icon(
                                Icons.arrow_forward,
                                size: 16,
                                color: (tint ?? const Color(0xFF0B57D0))
                                    .withOpacity(0.5),
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Progress info
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: (tint ?? const Color(0xFF0B57D0)).withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: (tint ?? const Color(0xFF0B57D0)).withOpacity(0.15),
              ),
            ),
            child: Text(
              '✓ All stages complete',
              style: theme.textTheme.labelSmall?.copyWith(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: tint ?? const Color(0xFF0B57D0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
