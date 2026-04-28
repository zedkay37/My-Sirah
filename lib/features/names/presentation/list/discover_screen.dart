import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sirah_app/core/providers/husna_providers.dart';
import 'package:sirah_app/core/providers/journey_providers.dart';
import 'package:sirah_app/core/utils/build_context_x.dart';

class DiscoverScreen extends ConsumerWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final typo = context.typo;
    final space = context.space;
    final l10n = context.l10n;

    final progress = ref.watch(journeyProgressResolverProvider);
    final prophetsRecognized = progress.recognized.length;
    final journeyViewed = progress.viewed.length;
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
            progress: prophetsRecognized,
            progressLabel: l10n.libraryDeckProgress(prophetsRecognized, 201),
            total: 201,
            accentColor: colors.accent,
            onTap: () => context.push('/library/deck/prophet_names'),
          ),
          SizedBox(height: space.md),
          _DeckCard(
            index: 1,
            icon: Icons.travel_explore_outlined,
            titleAr: l10n.journeyTitleAr,
            titleFr: l10n.journeyTitle,
            subtitle: l10n.journeySubtitle,
            progress: journeyViewed,
            progressLabel: l10n.journeyProgress(journeyViewed, 201),
            total: 201,
            accentColor: colors.success,
            onTap: () => context.push('/journey'),
          ),
          SizedBox(height: space.md),
          _DeckCard(
            index: 2,
            icon: Icons.stars_outlined,
            titleAr: l10n.discoverHusnaTitleAr,
            titleFr: l10n.husnaTitle,
            subtitle: l10n.discoverHusnaSubtitle,
            progress: husnaLearned,
            progressLabel: l10n.libraryDeckProgress(husnaLearned, 99),
            total: 99,
            accentColor: colors.accent2,
            onTap: () => context.push('/library/deck/asmaul_husna'),
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
    required this.progress,
    required this.progressLabel,
    required this.total,
    required this.accentColor,
    required this.onTap,
  });

  final int index;
  final IconData icon;
  final String titleAr;
  final String titleFr;
  final String subtitle;
  final int progress;
  final String progressLabel;
  final int total;
  final Color accentColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typo = context.typo;
    final space = context.space;
    final radii = context.radii;

    final progressValue = total > 0 ? progress / total : 0.0;

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
                    value: progressValue,
                    backgroundColor: accentColor.withValues(alpha: 0.1),
                    color: accentColor,
                    minHeight: 4,
                  ),
                ),
                SizedBox(height: space.xs),
                Text(
                  progressLabel,
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
