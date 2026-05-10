import 'package:flutter/material.dart';

class ShowcaseCard extends StatefulWidget {
  final String title;
  final String description;
  final Widget child;
  final VoidCallback? onTap;
  final Color? tint;
  final double elevation;
  final bool allowExpand;

  const ShowcaseCard({
    super.key,
    required this.title,
    required this.description,
    required this.child,
    this.onTap,
    this.tint,
    this.elevation = 2,
    this.allowExpand = true,
  });

  @override
  State<ShowcaseCard> createState() => _ShowcaseCardState();
}

class _ShowcaseCardState extends State<ShowcaseCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeOutCubic),
    );

    _elevationAnimation = Tween<double>(begin: widget.elevation, end: 8)
        .animate(
          CurvedAnimation(parent: _hoverController, curve: Curves.easeOutCubic),
        );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  void _onEnter() {
    _hoverController.forward();
  }

  void _onExit() {
    _hoverController.reverse();
  }

  Future<void> _openExpandedView() async {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final titleColor = isDark
        ? const Color(0xFFE2E8F0)
        : const Color(0xFF0F1C2E);
    final subtitleColor = isDark
        ? const Color(0xFF94A3B8)
        : const Color(0xFF52637A);
    final dividerColor = isDark
        ? theme.dividerColor.withValues(alpha: 0.8)
        : theme.dividerColor.withValues(alpha: 0.5);

    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        final media = MediaQuery.of(dialogContext);
        final isMobile = media.size.width < 700;
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          backgroundColor: Colors.transparent,
          child: Center(
            child: FractionallySizedBox(
              widthFactor: isMobile ? 0.96 : 0.88,
              heightFactor: isMobile ? 0.9 : 0.8,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 1080,
                  maxHeight: 760,
                ),
                child: Card(
                  elevation: 12,
                  color: theme.cardColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                    side: BorderSide(
                      color:
                          widget.tint?.withValues(alpha: 0.24) ??
                          theme.dividerColor.withValues(alpha: 0.4),
                      width: 1.6,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      gradient: widget.tint != null
                          ? LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                widget.tint!.withValues(alpha: 0.03),
                                isDark ? const Color(0xFF111827) : Colors.white,
                              ],
                            )
                          : null,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(isMobile ? 16 : 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style:
                                          (isMobile
                                                  ? theme.textTheme.titleLarge
                                                  : theme
                                                        .textTheme
                                                        .headlineSmall)
                                              ?.copyWith(
                                                fontWeight: FontWeight.w800,
                                                fontSize: isMobile ? 22 : 28,
                                                color: titleColor,
                                                letterSpacing: 0.2,
                                              ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      widget.description,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: theme.textTheme.titleSmall
                                          ?.copyWith(
                                            fontSize: isMobile ? 14 : 16,
                                            color: subtitleColor,
                                            height: 1.35,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              _PanelAction(
                                icon: Icons.close_rounded,
                                onTap: () => Navigator.of(dialogContext).pop(),
                              ),
                              if (widget.tint != null)
                                Container(
                                  width: 8,
                                  height: 42,
                                  margin: const EdgeInsets.only(left: 12),
                                  decoration: BoxDecoration(
                                    color: widget.tint,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Container(height: 1, color: dividerColor),
                          const SizedBox(height: 12),
                          Expanded(child: ClipRect(child: widget.child)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final titleColor = isDark
        ? const Color(0xFFE2E8F0)
        : const Color(0xFF0F1C2E);
    final subtitleColor = isDark
        ? const Color(0xFF94A3B8)
        : const Color(0xFF52637A);
    final dividerColor = isDark
        ? theme.dividerColor.withValues(alpha: 0.8)
        : theme.dividerColor.withValues(alpha: 0.5);

    return MouseRegion(
      onEnter: (_) => _onEnter(),
      onExit: (_) => _onExit(),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: Listenable.merge([_scaleAnimation, _elevationAnimation]),
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Card(
                elevation: _elevationAnimation.value,
                color: theme.cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color:
                        widget.tint?.withValues(alpha: 0.2) ??
                        theme.dividerColor.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: widget.tint != null
                        ? LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              widget.tint!.withValues(alpha: 0.02),
                              isDark ? const Color(0xFF111827) : Colors.white,
                            ],
                          )
                        : null,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header with title and tint indicator
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.title,
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      color: titleColor,
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    widget.description,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: subtitleColor,
                                      fontSize: 12,
                                      height: 1.4,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (widget.allowExpand)
                              _PanelAction(
                                icon: Icons.open_in_full_rounded,
                                onTap: _openExpandedView,
                              ),
                            if (widget.allowExpand) const SizedBox(width: 6),
                            const SizedBox(width: 6),
                            _PanelAction(icon: Icons.more_horiz_rounded),
                            if (widget.tint != null)
                              Container(
                                width: 8,
                                height: 40,
                                margin: const EdgeInsets.only(left: 12),
                                decoration: BoxDecoration(
                                  color: widget.tint,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        // Divider
                        Container(height: 1, color: dividerColor),
                        const SizedBox(height: 14),
                        // Content area
                        Expanded(child: widget.child),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _PanelAction extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _PanelAction({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          ),
        ),
        child: Icon(
          icon,
          size: 14,
          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
        ),
      ),
    );
  }
}

