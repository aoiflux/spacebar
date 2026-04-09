import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:spacebar/features/home/presentation/widgets/home_status_pill.dart';

class HomeActionPane extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String ctaLabel;
  final String statLabel;
  final Color tint;
  final VoidCallback onTap;

  const HomeActionPane({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.ctaLabel,
    required this.statLabel,
    required this.tint,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return _HomeHoverLiftCard(
      tint: tint,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: tint.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: tint, size: 26),
                ),
                const Spacer(),
                HomeStatusPill(
                  label: statLabel,
                  icon: Icons.bolt_outlined,
                  tint: tint,
                ),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              title,
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1C2430),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              subtitle,
              style: textTheme.bodyLarge?.copyWith(
                height: 1.35,
                color: const Color(0xFF364254),
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Text(
                  ctaLabel,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: tint,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.arrow_forward_rounded, color: tint),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeHoverLiftCard extends StatefulWidget {
  final Widget child;
  final Color tint;
  final VoidCallback onTap;

  const _HomeHoverLiftCard({
    required this.child,
    required this.tint,
    required this.onTap,
  });

  @override
  State<_HomeHoverLiftCard> createState() => _HomeHoverLiftCardState();
}

class _HomeHoverLiftCardState extends State<_HomeHoverLiftCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, _hovered ? -5 : 0, 0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 13, sigmaY: 13),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onTap,
                child: Ink(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: widget.tint.withValues(
                        alpha: _hovered ? 0.45 : 0.26,
                      ),
                      width: 1.2,
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withValues(alpha: 0.74),
                        Colors.white.withValues(alpha: 0.48),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: widget.tint.withValues(
                          alpha: _hovered ? 0.2 : 0.13,
                        ),
                        blurRadius: _hovered ? 38 : 28,
                        offset: Offset(0, _hovered ? 18 : 12),
                      ),
                    ],
                  ),
                  child: widget.child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
