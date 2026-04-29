import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sirah_app/core/providers/journey_providers.dart';
import 'package:sirah_app/core/utils/build_context_x.dart';
import 'package:sirah_app/features/journey/data/repositories/journey_repository.dart';
import 'package:sirah_app/features/journey/domain/name_progress_resolver.dart';
import 'package:sirah_app/features/shared/progress_ring.dart';

class JourneyScreen extends ConsumerWidget {
  const JourneyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final typo = context.typo;
    final space = context.space;
    final l10n = context.l10n;
    final journeyAsync = ref.watch(journeyRepositoryProvider);
    final progress = ref.watch(journeyProgressResolverProvider);

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(
        backgroundColor: colors.bg,
        surfaceTintColor: colors.bg,
        elevation: 0,
        title: Text(l10n.journeyTitle, style: typo.headline),
      ),
      body: journeyAsync.when(
        loading: () => Center(
          child: CircularProgressIndicator(
            color: colors.accent,
            strokeWidth: 2,
          ),
        ),
        error: (_, __) => Center(
          child: Text(
            l10n.journeyLoadError,
            style: typo.bodyLarge.copyWith(color: colors.muted),
          ),
        ),
        data: (journey) {
          final constellations = journey.getConstellations();
          return ListView.separated(
            padding: EdgeInsets.all(space.md),
            itemCount: constellations.length + 1,
            separatorBuilder: (_, __) => SizedBox(height: space.md),
            itemBuilder: (context, index) {
              if (index == 0) {
                return Text(
                  l10n.journeySubtitle,
                  style: typo.body.copyWith(color: colors.muted),
                );
              }
              final constellation = constellations[index - 1];
              return _ConstellationCard(
                constellation: constellation,
                progress: progress,
                onTap: () =>
                    context.push('/journey/constellation/${constellation.id}'),
              );
            },
          );
        },
      ),
    );
  }
}

class _ConstellationCard extends StatelessWidget {
  const _ConstellationCard({
    required this.constellation,
    required this.progress,
    required this.onTap,
  });

  final NameConstellation constellation;
  final NameProgressResolver progress;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typo = context.typo;
    final space = context.space;
    final color = _hexToColor(constellation.colorHex);
    final summary = progress.summarize(constellation.nameNumbers);

    return InkWell(
      onTap: onTap,
      borderRadius: context.radii.lgAll,
      child: Container(
        padding: EdgeInsets.all(space.lg),
        decoration: BoxDecoration(
          color: colors.bg2,
          borderRadius: context.radii.lgAll,
          border: Border.all(color: color.withValues(alpha: 0.35)),
        ),
        child: Row(
          children: [
            ProgressRing(
              progress: summary.weightedProgress,
              size: 44,
              color: color,
              backgroundColor: color.withValues(alpha: 0.14),
            ),
            SizedBox(width: space.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    constellation.titleFr,
                    textDirection: TextDirection.ltr,
                    style: typo.bodyLarge.copyWith(color: colors.ink),
                  ),
                  SizedBox(height: space.xs / 2),
                  Text(
                    constellation.descriptionFr,
                    textDirection: TextDirection.ltr,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: typo.caption.copyWith(color: colors.muted),
                  ),
                  SizedBox(height: space.xs),
                  Text(
                    context.l10n.journeyProgressDetailed(
                      summary.viewed,
                      summary.meditated,
                      summary.practiced,
                      summary.recognized,
                      summary.total,
                    ),
                    style: typo.caption.copyWith(color: color),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: colors.muted),
          ],
        ),
      ),
    );
  }

  Color _hexToColor(String hex) {
    final normalized = hex.replaceFirst('#', '');
    return Color(int.parse('FF$normalized', radix: 16));
  }
}
