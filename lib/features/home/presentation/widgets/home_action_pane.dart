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
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: tint,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: tint.withValues(alpha: 0.28),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Icon(icon, color: Colors.white, size: 24),
                ),
                const Spacer(),
                HomeStatusPill(
                  label: statLabel,
                  icon: Icons.bolt_outlined,
                  tint: tint,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0F1C2E),
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: textTheme.bodyMedium?.copyWith(
                height: 1.55,
                color: const Color(0xFF52637A),
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: tint,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: tint.withValues(alpha: 0.22),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    ctaLabel,
                    style: textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 0.1,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ],
              ),
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
        transform: Matrix4.translationValues(0, _hovered ? -4 : 0, 0),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(20),
            splashColor: widget.tint.withValues(alpha: 0.06),
            highlightColor: widget.tint.withValues(alpha: 0.03),
            child: Ink(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                border: Border.all(
                  color: _hovered
                      ? widget.tint.withValues(alpha: 0.35)
                      : const Color(0xFFDDE5F0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: _hovered
                        ? widget.tint.withValues(alpha: 0.14)
                        : const Color(0x0A0B2240),
                    blurRadius: _hovered ? 40 : 16,
                    offset: Offset(0, _hovered ? 16 : 6),
                  ),
                ],
              ),
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
