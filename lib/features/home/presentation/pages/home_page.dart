import 'package:flutter/material.dart';
import 'package:spacebar/features/evi_list/presentation/pages/evi_list_page.dart';
import 'package:spacebar/features/evi_store/presentation/pages/evi_store_page.dart';
import 'package:spacebar/features/home/presentation/widgets/home_action_pane.dart';
import 'package:spacebar/features/home/presentation/widgets/home_fluent_background.dart';
import 'package:spacebar/features/home/presentation/widgets/home_info_chip.dart';
import 'package:spacebar/features/home/presentation/widgets/home_status_pill.dart';
import 'package:spacebar/features/showcase/presentation/pages/showcase_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          const HomeFluentBackground(),
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Top bar ───────────────────────────────────────────
                      Row(
                        children: [
                          Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              color: const Color(0xFF0B57D0),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.shield_outlined,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'DUES',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                              color: const Color(0xFF0F1C2E),
                            ),
                          ),
                          const Spacer(),
                          const HomeStatusPill(
                            label: 'Secure Mode',
                            icon: Icons.lock_outline,
                            tint: Color(0xFF0D7A5F),
                          ),
                          const SizedBox(width: 12),
                          _ShowcaseButton(
                            theme: theme,
                            onTap: () {
                              Navigator.of(context).push(
                                PageRouteBuilder<void>(
                                  transitionDuration: const Duration(
                                    milliseconds: 260,
                                  ),
                                  reverseTransitionDuration: const Duration(
                                    milliseconds: 220,
                                  ),
                                  pageBuilder: (_, _, _) =>
                                      const ShowcasePage(),
                                  transitionsBuilder:
                                      (
                                        context,
                                        animation,
                                        secondaryAnimation,
                                        child,
                                      ) {
                                        final fade = CurvedAnimation(
                                          parent: animation,
                                          curve: Curves.easeOutCubic,
                                        );
                                        final slide = Tween<Offset>(
                                          begin: const Offset(0, 0.015),
                                          end: Offset.zero,
                                        ).animate(fade);
                                        return FadeTransition(
                                          opacity: fade,
                                          child: SlideTransition(
                                            position: slide,
                                            child: child,
                                          ),
                                        );
                                      },
                                ),
                              );
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 48),

                      // ── Hero section ──────────────────────────────────────
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final wide = constraints.maxWidth > 700;
                          return wide
                              ? _HeroWide(theme: theme)
                              : _HeroNarrow(theme: theme);
                        },
                      ),

                      const SizedBox(height: 36),

                      // ── Action cards ──────────────────────────────────────
                      Expanded(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final compact = constraints.maxWidth < 700;
                            return GridView.count(
                              physics: const BouncingScrollPhysics(),
                              crossAxisCount: compact ? 1 : 2,
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 16,
                              childAspectRatio: compact ? 2.0 : 1.45,
                              children: [
                                HomeActionPane(
                                  icon: Icons.inventory_2_outlined,
                                  title: 'Evidence Store',
                                  subtitle:
                                      'Ingest evidence files into DUES — with hashing, chunk-level deduplication, and secure storage.',
                                  ctaLabel: 'Open Store',
                                  tint: const Color(0xFF0B57D0),
                                  statLabel: 'Ingestion',
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => const EviStorePage(),
                                      ),
                                    );
                                  },
                                ),
                                HomeActionPane(
                                  icon: Icons.dataset_outlined,
                                  title: 'Evidence List',
                                  subtitle:
                                      'Browse, inspect, and review stored evidence collections — structured for forensic analysis workflows.',
                                  ctaLabel: 'Open List',
                                  tint: const Color(0xFF0D7A5F),
                                  statLabel: 'Review',
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => const EviListPage(),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 14),

                      // ── Footer capability row ──────────────────────────────
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: const [
                          HomeInfoChip(
                            icon: Icons.verified_user_outlined,
                            label: 'Chain-of-custody ready',
                          ),
                          HomeInfoChip(
                            icon: Icons.fingerprint_outlined,
                            label: 'Hash-based deduplication',
                          ),
                          HomeInfoChip(
                            icon: Icons.storage_outlined,
                            label: 'Unified evidence access',
                          ),
                          HomeInfoChip(
                            icon: Icons.compress_rounded,
                            label: 'Lossless compression',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroWide extends StatelessWidget {
  final ThemeData theme;

  const _HeroWide({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF4FF),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFFBDD2F8)),
                ),
                child: Text(
                  'DIGITAL FORENSICS PLATFORM',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: const Color(0xFF0B57D0),
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.1,
                    fontSize: 10,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Deduplicated\nUnified Evidence\nStore',
                style: theme.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1.0,
                  color: const Color(0xFF0F1C2E),
                  height: 1.1,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 32),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Purpose-built for modern digital forensics — evidence ingestion, curation, and review at scale, with hash-level integrity at every step.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF52637A),
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFF0D7A5F),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'System ready',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF0D7A5F),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HeroNarrow extends StatelessWidget {
  final ThemeData theme;

  const _HeroNarrow({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFEEF4FF),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: const Color(0xFFBDD2F8)),
          ),
          child: Text(
            'DIGITAL FORENSICS PLATFORM',
            style: theme.textTheme.labelSmall?.copyWith(
              color: const Color(0xFF0B57D0),
              fontWeight: FontWeight.w700,
              letterSpacing: 1.1,
              fontSize: 10,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Deduplicated Unified Evidence Store',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.8,
            color: const Color(0xFF0F1C2E),
            height: 1.15,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Purpose-built for modern digital forensics workflows.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: const Color(0xFF52637A),
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class _ShowcaseButton extends StatefulWidget {
  final ThemeData theme;
  final VoidCallback onTap;

  const _ShowcaseButton({required this.theme, required this.onTap});

  @override
  State<_ShowcaseButton> createState() => _ShowcaseButtonState();
}

class _ShowcaseButtonState extends State<_ShowcaseButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _gradientAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat();

    _gradientAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedBuilder(
        animation: _gradientAnimation,
        builder: (context, child) {
          return GestureDetector(
            onTap: widget.onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                  begin: Alignment(-1 - _gradientAnimation.value, -1),
                  end: Alignment(1 + _gradientAnimation.value, 1),
                  colors: [
                    const Color(0xFF6941C6),
                    const Color(0xFF0B57D0),
                    const Color(0xFF0D7A5F),
                    const Color(0xFF6941C6),
                  ],
                  stops: const [0.0, 0.3, 0.7, 1.0],
                ),
                boxShadow: _isHovered
                    ? [
                        BoxShadow(
                          color: const Color(0xFF6941C6).withValues(alpha: 0.4),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: const Color(0xFF6941C6).withValues(alpha: 0.2),
                          blurRadius: 6,
                          spreadRadius: 0,
                        ),
                      ],
              ),
              child: Transform.scale(
                scale: _isHovered ? 1.05 : 1.0,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.collections_outlined,
                      size: 16,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Showcase',
                      style: widget.theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                        color: Colors.white,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
