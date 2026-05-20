import 'package:flutter/foundation.dart';
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
  final ValueNotifier<int> _dialogContentVersion = ValueNotifier<int>(0);
  bool _dialogRefreshQueued = false;
  bool _isExpandedOpen = false;

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
    _dialogContentVersion.dispose();
    _hoverController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ShowcaseCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isExpandedOpen) {
      return;
    }
    // Keep expanded dialog content in sync with stateful card children.
    if (oldWidget.child != widget.child && !_dialogRefreshQueued) {
      _dialogRefreshQueued = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _dialogRefreshQueued = false;
        if (!mounted) return;
        _dialogContentVersion.value++;
      });
    }
  }

  void _onEnter() {
    _hoverController.forward();
  }

  void _onExit() {
    _hoverController.reverse();
  }

  Future<void> _openExpandedView() async {
    if (_isExpandedOpen) {
      return;
    }

    // Prevent focus transitions while a key is still pressed from bubbling
    // into RawKeyboard state assertions on some desktop/web runtimes.
    FocusManager.instance.primaryFocus?.unfocus();

    setState(() {
      _isExpandedOpen = true;
    });

    try {
      await showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (dialogContext) => _ExpandedShowcaseDialog(
          title: widget.title,
          description: widget.description,
          tint: widget.tint,
          dialogContentVersion: _dialogContentVersion,
          child: widget.child,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isExpandedOpen = false;
        });
      }
    }
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
                        Expanded(
                          child: _isExpandedOpen
                              ? const SizedBox.shrink()
                              : widget.child,
                        ),
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

class ShowcaseExpansionScope extends InheritedWidget {
  const ShowcaseExpansionScope({
    super.key,
    required this.isExpanded,
    required super.child,
  });

  final bool isExpanded;

  static bool of(BuildContext context) {
    return context
            .dependOnInheritedWidgetOfExactType<ShowcaseExpansionScope>()
            ?.isExpanded ??
        false;
  }

  @override
  bool updateShouldNotify(covariant ShowcaseExpansionScope oldWidget) {
    return oldWidget.isExpanded != isExpanded;
  }
}

class _ExpandedShowcaseDialog extends StatelessWidget {
  const _ExpandedShowcaseDialog({
    required this.title,
    required this.description,
    required this.tint,
    required this.dialogContentVersion,
    required this.child,
  });

  final String title;
  final String description;
  final Color? tint;
  final ValueListenable<int> dialogContentVersion;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return _ExpandedDialogFrame(
      title: title,
      description: description,
      tint: tint,
      dialogContentVersion: dialogContentVersion,
      child: child,
    );
  }
}

class _ExpandedDialogFrame extends StatelessWidget {
  const _ExpandedDialogFrame({
    required this.title,
    required this.description,
    required this.tint,
    required this.dialogContentVersion,
    required this.child,
  });

  final String title;
  final String description;
  final Color? tint;
  final ValueListenable<int> dialogContentVersion;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final media = MediaQuery.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isMobile = media.size.width < 700;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      backgroundColor: Colors.transparent,
      child: Center(
        child: FractionallySizedBox(
          widthFactor: isMobile ? 0.96 : 0.88,
          heightFactor: isMobile ? 0.9 : 0.8,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1080, maxHeight: 760),
            child: _ExpandedDialogCard(
              title: title,
              description: description,
              tint: tint,
              dialogContentVersion: dialogContentVersion,
              isMobile: isMobile,
              theme: theme,
              isDark: isDark,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class _ExpandedDialogCard extends StatelessWidget {
  const _ExpandedDialogCard({
    required this.title,
    required this.description,
    required this.tint,
    required this.dialogContentVersion,
    required this.isMobile,
    required this.theme,
    required this.isDark,
    required this.child,
  });

  final String title;
  final String description;
  final Color? tint;
  final ValueListenable<int> dialogContentVersion;
  final bool isMobile;
  final ThemeData theme;
  final bool isDark;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 12,
      color: theme.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color:
              tint?.withValues(alpha: 0.24) ??
              theme.dividerColor.withValues(alpha: 0.4),
          width: 1.6,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: tint != null
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    tint!.withValues(alpha: 0.03),
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
              _ExpandedDialogHeader(
                title: title,
                description: description,
                tint: tint,
                theme: theme,
                isMobile: isMobile,
                isDark: isDark,
              ),
              const SizedBox(height: 12),
              _ExpandedDialogDivider(theme: theme),
              const SizedBox(height: 12),
              Expanded(
                child: ShowcaseExpansionScope(
                  isExpanded: true,
                  child: ValueListenableBuilder<int>(
                    valueListenable: dialogContentVersion,
                    child: ClipRect(child: child),
                    builder: (context, value, child) => child!,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExpandedDialogHeader extends StatelessWidget {
  const _ExpandedDialogHeader({
    required this.title,
    required this.description,
    required this.tint,
    required this.theme,
    required this.isMobile,
    required this.isDark,
  });

  final String title;
  final String description;
  final Color? tint;
  final ThemeData theme;
  final bool isMobile;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final titleColor = isDark
        ? const Color(0xFFE2E8F0)
        : const Color(0xFF0F1C2E);
    final subtitleColor = isDark
        ? const Color(0xFF94A3B8)
        : const Color(0xFF52637A);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style:
                    (isMobile
                            ? theme.textTheme.titleLarge
                            : theme.textTheme.headlineSmall)
                        ?.copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: isMobile ? 22 : 28,
                          color: titleColor,
                          letterSpacing: 0.2,
                        ),
              ),
              const SizedBox(height: 6),
              Text(
                description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleSmall?.copyWith(
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
          onTap: () => Navigator.of(context).pop(),
        ),
        if (tint != null)
          Container(
            width: 8,
            height: 42,
            margin: const EdgeInsets.only(left: 12),
            decoration: BoxDecoration(
              color: tint,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
      ],
    );
  }
}

class _ExpandedDialogDivider extends StatelessWidget {
  const _ExpandedDialogDivider({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final isDark = theme.brightness == Brightness.dark;
    final dividerColor = isDark
        ? theme.dividerColor.withValues(alpha: 0.8)
        : theme.dividerColor.withValues(alpha: 0.5);

    return Container(height: 1, color: dividerColor);
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
      canRequestFocus: false,
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
