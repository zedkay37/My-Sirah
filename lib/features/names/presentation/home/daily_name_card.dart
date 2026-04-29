import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sirah_app/core/utils/build_context_x.dart';
import 'package:sirah_app/features/journey/data/repositories/journey_repository.dart';
import 'package:sirah_app/features/names/data/models/prophet_name.dart';
import 'package:sirah_app/features/shared/arabic_text.dart';
import 'package:sirah_app/features/shared/category_chip.dart';

class DailyNameCard extends ConsumerWidget {
  const DailyNameCard({
    super.key,
    required this.name,
    this.constellation,
    this.action,
  });

  final ProphetName name;
  final NameConstellation? constellation;
  final NameActionItem? action;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final typo = context.typo;
    final space = context.space;
    final radii = context.radii;
    final l10n = context.l10n;
    final screenHeight = MediaQuery.of(context).size.height;
    final minHeight = (screenHeight * 0.52).clamp(430.0, 560.0);

    return Semantics(
          label: '${name.transliteration}, nom du jour numéro ${name.number}',
          child: Container(
            constraints: BoxConstraints(minHeight: minHeight),
            decoration: BoxDecoration(
              color: colors.bg2,
              borderRadius: radii.lgAll,
              border: Border.all(color: colors.line),
            ),
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: EdgeInsets.all(space.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.homeNameNumber(
                          name.number.toString().padLeft(3, '0'),
                        ),
                        style: typo.caption.copyWith(color: colors.muted),
                      ),
                      CategoryChip(
                        slug: name.categorySlug,
                        label: name.categoryLabel,
                        variant: CategoryChipVariant.small,
                      ),
                    ],
                  ),
                  SizedBox(height: space.xl),
                  ArabicText(
                    text: name.arabic,
                    size: ArabicSize.hero,
                    withShadow: true,
                  ),
                  SizedBox(height: space.md),
                  Text(
                    name.transliteration,
                    textDirection: TextDirection.ltr,
                    style: typo.headline.copyWith(
                      fontStyle: FontStyle.italic,
                      color: colors.muted,
                    ),
                  ),
                  if (constellation != null) ...[
                    SizedBox(height: space.sm),
                    _ConstellationLabel(constellation: constellation!),
                  ],
                  SizedBox(height: space.lg),
                  _EtymologyFade(text: name.etymology),
                  SizedBox(height: space.lg),
                  if (action != null) ...[
                    _DailyActionPreview(action: action!),
                    SizedBox(height: space.lg),
                  ],
                  _RitualActions(nameNumber: name.number),
                ],
              ),
            ),
          ),
        )
        .animate()
        .fadeIn(duration: 450.ms)
        .slideY(begin: 0.04, end: 0, curve: Curves.easeOut);
  }
}

class _ConstellationLabel extends StatelessWidget {
  const _ConstellationLabel({required this.constellation});

  final NameConstellation constellation;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typo = context.typo;

    return Text(
      constellation.titleFr,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
      style: typo.caption.copyWith(color: colors.accent),
    );
  }
}

class _EtymologyFade extends StatelessWidget {
  const _EtymologyFade({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typo = context.typo;

    return SizedBox(
      height: 72,
      child: Stack(
        children: [
          Text(
            text,
            maxLines: 4,
            overflow: TextOverflow.clip,
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr,
            style: typo.body.copyWith(color: colors.muted),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.64, 1.0],
                  colors: [
                    colors.bg2.withValues(alpha: 0),
                    colors.bg2.withValues(alpha: 0.88),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DailyActionPreview extends StatelessWidget {
  const _DailyActionPreview({required this.action});

  final NameActionItem action;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typo = context.typo;
    final space = context.space;
    final l10n = context.l10n;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.bg,
        border: Border.all(color: colors.line),
        borderRadius: context.radii.mdAll,
      ),
      child: Padding(
        padding: EdgeInsets.all(space.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.volunteer_activism_outlined, color: colors.accent),
            SizedBox(width: space.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.homeDailyActionTitle,
                    style: typo.caption.copyWith(color: colors.muted),
                  ),
                  SizedBox(height: space.xs / 2),
                  Text(
                    action.textFr,
                    textDirection: TextDirection.ltr,
                    style: typo.body.copyWith(color: colors.ink, height: 1.4),
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

class _RitualActions extends StatelessWidget {
  const _RitualActions({required this.nameNumber});

  final int nameNumber;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: () => context.push('/name/$nameNumber/experience'),
        icon: const Icon(Icons.auto_awesome_outlined),
        label: Text(l10n.homeExploreTodayName),
      ),
    );
  }
}
