import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sirah_app/core/providers/husna_providers.dart';
import 'package:sirah_app/core/providers/settings_provider.dart';
import 'package:sirah_app/core/utils/build_context_x.dart';

class DiscoverScreen extends ConsumerWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final typo = context.typo;
    final space = context.space;
    final l10n = context.l10n;

    final prophetsLearned = ref.watch(
      settingsProvider.select((s) => s.learned.length),
    );
    final husnaLearned = ref.watch(husnaLearnedCountProvider);

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(
        backgroundColor: colors.bg,
        surfaceTintColor: colors.bg,
        elevation: 0,
        title: Text(l10n.navDiscover, style: typo.headline),
      ),
      body: ListView(
        padding: EdgeInsets.all(space.md),
        children: [
          Text(
            l10n.discoverHubSubtitle,
            style: typo.body.copyWith(color: colors.muted),
          ),
          SizedBox(height: space.lg),
          _DeckCard(
            index: 0,
            icon: Icons.auto_awesome_outlined,
            titleAr: l10n.discoverProphetsTitleAr,
            titleFr: l10n.discoverProphetsTitle,
            subtitle: l10n.discoverProphetsSubtitle,
            learned: prophetsLearned,
            total: 201,
            accentColor: colors.accent,
            onTap: () => context.push('/discover/prophets'),
          ),
          SizedBox(height: space.md),
          _DeckCard(
            index: 1,
            icon: Icons.stars_outlined,
            titleAr: l10n.discoverHusnaTitleAr,
            titleFr: l10n.husnaTitle,
            subtitle: l10n.discoverHusnaSubtitle,
            learned: husnaLearned,
            total: 99,
            accentColor: colors.accent2,
            onTap: () => context.push('/discover/husna'),
          ),
        ],
      ),
    );
  }
}

class _DeckCard extends StatelessWidget {
  const _DeckCard({
    required this.index,
    required this.icon,
    required this.titleAr,
    required this.titleFr,
    required this.subtitle,
    required this.learned,
    required this.total,
    required this.accentColor,
    required this.onTap,
  });

  final int index;
  final IconData icon;
  final String titleAr;
  final String titleFr;
  final String subtitle;
  final int learned;
  final int total;
  final Color accentColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typo = context.typo;
    final space = context.space;
    final radii = context.radii;

    final progress = total > 0 ? learned / total : 0.0;

    return GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(space.lg),
            decoration: BoxDecoration(
              color: colors.bg2,
              borderRadius: BorderRadius.circular(radii.lg),
              border: Border.all(color: colors.line),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: accentColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(radii.md),
                      ),
                      alignment: Alignment.center,
                      child: Icon(icon, color: accentColor, size: 22),
                    ),
                    SizedBox(width: space.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            titleAr,
                            style: typo.arabicBody.copyWith(
                              fontSize: 18,
                              color: colors.ink,
                            ),
                            textDirection: TextDirection.rtl,
                          ),
                          Text(
                            titleFr,
                            style: typo.caption.copyWith(
                              color: colors.muted,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right, color: colors.muted, size: 20),
                  ],
                ),
                SizedBox(height: space.md),
                Text(
                  subtitle,
                  style: typo.caption.copyWith(color: colors.muted),
                ),
                SizedBox(height: space.sm),
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: accentColor.withValues(alpha: 0.1),
                    color: accentColor,
                    minHeight: 4,
                  ),
                ),
                SizedBox(height: space.xs),
                Text(
                  context.l10n.homeCategoryLearned(learned, total),
                  style: typo.caption.copyWith(color: colors.muted),
                ),
              ],
            ),
          ),
        )
        .animate()
        .fade(duration: 300.ms, delay: (index * 80).ms)
        .slideY(begin: 0.05, duration: 300.ms, delay: (index * 80).ms);
  }
}
