import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sirah_app/core/providers/journey_providers.dart';
import 'package:sirah_app/core/providers/names_providers.dart';
import 'package:sirah_app/core/utils/build_context_x.dart';
import 'package:sirah_app/core/utils/color_utils.dart';
import 'package:sirah_app/features/journey/data/repositories/journey_repository.dart';
import 'package:sirah_app/features/journey/domain/name_progress_resolver.dart';
import 'package:sirah_app/features/names/data/models/prophet_name.dart';
import 'package:sirah_app/features/shared/arabic_text.dart';

class ConstellationDetailScreen extends ConsumerWidget {
  const ConstellationDetailScreen({super.key, required this.constellationId});

  final String constellationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final journeyAsync = ref.watch(journeyRepositoryProvider);
    final namesAsync = ref.watch(namesProvider);
    final progress = ref.watch(journeyProgressResolverProvider);

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(
        backgroundColor: colors.bg,
        surfaceTintColor: colors.bg,
        elevation: 0,
      ),
      body: journeyAsync.when(
        loading: () => _Loading(color: colors.accent),
        error: (_, __) => _ErrorMessage(message: context.l10n.journeyLoadError),
        data: (journey) {
          final constellation = journey.getConstellationById(constellationId);
          if (constellation == null) {
            return _ErrorMessage(message: context.l10n.journeyNotFound);
          }
          return namesAsync.when(
            loading: () => _Loading(color: colors.accent),
            error: (_, __) =>
                _ErrorMessage(message: context.l10n.journeyLoadError),
            data: (names) => _ConstellationContent(
              constellation: constellation,
              names: names,
              progress: progress,
            ),
          );
        },
      ),
    );
  }
}

class _ConstellationContent extends StatelessWidget {
  const _ConstellationContent({
    required this.constellation,
    required this.names,
    required this.progress,
  });

  final NameConstellation constellation;
  final List<ProphetName> names;
  final NameProgressResolver progress;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typo = context.typo;
    final space = context.space;
    final color = hexToColor(constellation.colorHex);
    final constellationNames = [
      for (final number in constellation.nameNumbers)
        if (_nameByNumber(number) != null) _nameByNumber(number)!,
    ];

    return ListView.separated(
      padding: EdgeInsets.fromLTRB(space.md, 0, space.md, space.xxl),
      itemCount: constellationNames.length + 1,
      separatorBuilder: (_, __) => SizedBox(height: space.sm),
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: EdgeInsets.only(bottom: space.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  constellation.titleAr,
                  textDirection: TextDirection.rtl,
                  style: typo.arabicLarge.copyWith(color: color),
                ),
                SizedBox(height: space.xs),
                Text(
                  constellation.titleFr,
                  textDirection: TextDirection.ltr,
                  style: typo.displayMedium.copyWith(color: colors.ink),
                ),
                SizedBox(height: space.sm),
                Text(
                  constellation.descriptionFr,
                  textDirection: TextDirection.ltr,
                  style: typo.body.copyWith(color: colors.muted, height: 1.45),
                ),
              ],
            ),
          );
        }

        final name = constellationNames[index - 1];
        return _StarNameTile(
          name: name,
          status: progress.stageFor(name.number),
          accent: color,
          onTap: () => context.push('/name/${name.number}/experience'),
        );
      },
    );
  }

  ProphetName? _nameByNumber(int number) {
    try {
      return names.firstWhere((name) => name.number == number);
    } on StateError {
      return null;
    }
  }
}

class _StarNameTile extends StatelessWidget {
  const _StarNameTile({
    required this.name,
    required this.status,
    required this.accent,
    required this.onTap,
  });

  final ProphetName name;
  final JourneyNameStage status;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typo = context.typo;
    final space = context.space;
    final statusColor = status == JourneyNameStage.unknown
        ? colors.muted
        : accent;

    return InkWell(
      onTap: onTap,
      borderRadius: context.radii.mdAll,
      child: Container(
        padding: EdgeInsets.all(space.md),
        decoration: BoxDecoration(
          color: colors.bg2,
          borderRadius: context.radii.mdAll,
          border: Border.all(
            color: status == JourneyNameStage.unknown
                ? colors.line
                : accent.withValues(alpha: 0.5),
          ),
        ),
        child: Row(
          children: [
            Icon(_iconForStatus(status), color: statusColor),
            SizedBox(width: space.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ArabicText(
                    text: name.arabic,
                    size: ArabicSize.medium,
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: space.xs / 2),
                  Text(
                    name.transliteration,
                    textDirection: TextDirection.ltr,
                    style: typo.body.copyWith(
                      color: colors.muted,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(height: space.xs / 2),
                  Text(
                    _labelForStatus(context, status),
                    style: typo.caption.copyWith(color: statusColor),
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

  IconData _iconForStatus(JourneyNameStage status) {
    return switch (status) {
      JourneyNameStage.recognized => Icons.workspace_premium_rounded,
      JourneyNameStage.practiced => Icons.check_circle_rounded,
      JourneyNameStage.meditated => Icons.self_improvement_rounded,
      JourneyNameStage.viewed => Icons.star_rounded,
      JourneyNameStage.unknown => Icons.star_border_rounded,
    };
  }

  String _labelForStatus(BuildContext context, JourneyNameStage status) {
    final l10n = context.l10n;
    return switch (status) {
      JourneyNameStage.recognized => l10n.journeyStarRecognized,
      JourneyNameStage.practiced => l10n.journeyStarPracticed,
      JourneyNameStage.meditated => l10n.journeyStarMeditated,
      JourneyNameStage.viewed => l10n.journeyStarViewed,
      JourneyNameStage.unknown => l10n.journeyStarUnknown,
    };
  }
}

class _Loading extends StatelessWidget {
  const _Loading({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(color: color, strokeWidth: 2),
    );
  }
}

class _ErrorMessage extends StatelessWidget {
  const _ErrorMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: context.typo.bodyLarge.copyWith(color: context.colors.muted),
      ),
    );
  }
}
