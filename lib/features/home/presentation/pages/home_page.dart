import 'package:flutter/material.dart';
import 'package:spacebar/features/evi_list/presentation/pages/evi_list_page.dart';
import 'package:spacebar/features/evi_store/presentation/pages/evi_store_page.dart';
import 'package:spacebar/features/home/presentation/widgets/home_action_pane.dart';
import 'package:spacebar/features/home/presentation/widgets/home_command_surface.dart';
import 'package:spacebar/features/home/presentation/widgets/home_fluent_background.dart';
import 'package:spacebar/features/home/presentation/widgets/home_info_chip.dart';
import 'package:spacebar/features/home/presentation/widgets/home_status_pill.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      body: Stack(
        children: [
          const HomeFluentBackground(),
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1080),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HomeCommandSurface(
                        child: Row(
                          children: [
                            Container(
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF2D7FF9),
                                    Color(0xFF1EA7FD),
                                  ],
                                ),
                              ),
                              child: const Icon(
                                Icons.shield_outlined,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'DUES Workspace',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.2,
                                  color: const Color(0xFF1C2430),
                                ),
                              ),
                            ),
                            const HomeStatusPill(
                              label: 'Secure Mode',
                              icon: Icons.lock_outline,
                              tint: Color(0xFF0CA678),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 22),
                      Text(
                        'DUES',
                        style: theme.textTheme.displayMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                          color: cs.onSurface,
                        ),
                      ),
                      Text(
                        'Deduplicated Unified Evidence Store',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: cs.onSurface.withValues(alpha: 0.82),
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Digital forensics workspace for evidence ingestion, curation, and review.',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: cs.onSurface.withValues(alpha: 0.65),
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 28),
                      Expanded(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final compact = constraints.maxWidth < 800;
                            return Column(
                              children: [
                                Expanded(
                                  child: GridView.count(
                                    physics: const BouncingScrollPhysics(),
                                    crossAxisCount: compact ? 1 : 2,
                                    mainAxisSpacing: 16,
                                    crossAxisSpacing: 16,
                                    childAspectRatio: compact ? 2.35 : 1.48,
                                    children: [
                                      HomeActionPane(
                                        icon: Icons.inventory_2_outlined,
                                        title: 'Evidence Store',
                                        subtitle:
                                            'Ingest and process evidence files into DUES with hashing, indexing, and deduplication.',
                                        ctaLabel: 'Open EVI Store',
                                        tint: const Color(0xFF2D7FF9),
                                        statLabel: 'Primary Workflow',
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  const EviStorePage(),
                                            ),
                                          );
                                        },
                                      ),
                                      HomeActionPane(
                                        icon: Icons.dataset_outlined,
                                        title: 'Evidence List',
                                        subtitle:
                                            'Browse and inspect available evidence collections prepared for analysis workflows.',
                                        ctaLabel: 'Open EVI List',
                                        tint: const Color(0xFF0CA678),
                                        statLabel: 'Review Workflow',
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  const EviListPage(),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 12),
                                HomeCommandSurface(
                                  child: Wrap(
                                    spacing: 10,
                                    runSpacing: 10,
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
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
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
