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
    final screenWidth = MediaQuery.of(context).size.width;
    final compact = screenHeight < 900 || screenWidth < 460;
    final cardHeight = (screenHeight * 0.50).clamp(420.0, 540.0).toDouble();
    final sectionGap = compact ? space.sm : space.md;

    return Semantics(
          label: '${name.transliteration}, nom du jour numéro ${name.number}',
          child: Container(
            height: cardHeight,
            decoration: BoxDecoration(
              color: colors.bg2,
              borderRadius: radii.lgAll,
              border: Border.all(color: colors.line),
            ),
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: EdgeInsets.all(compact ? space.md : space.lg),
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
                        style: typo.caption.copyWith(
                          color: colors.muted,
                          letterSpacing: 0.3,
                        ),
                      ),
                      CategoryChip(
                        slug: name.categorySlug,
                        label: name.categoryLabel,
                        variant: CategoryChipVariant.small,
                      ),
                    ],
                  ),
                  Expanded(
                    child: Center(
                      child: _NameIdentity(
                        arabic: name.arabic,
                        transliteration: name.transliteration,
                      ),
                    ),
                  ),
                  _EtymologyPreview(text: name.shortMeaningFr),
                  SizedBox(height: compact ? space.xs : space.sm),
                  if (action != null) ...[
                    _DailyActionPreview(action: action!),
                    SizedBox(height: sectionGap),
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

class _NameIdentity extends StatelessWidget {
  const _NameIdentity({required this.arabic, required this.transliteration});

  final String arabic;
  final String transliteration;

  @override
  Widget build(BuildContext context) {
    final typo = context.typo;
    final colors = context.colors;
    final space = context.space;
    final compact = MediaQuery.of(context).size.height < 900;

    return SizedBox(
      height: compact ? 142 : 158,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ArabicText(
              text: arabic,
              size: ArabicSize.large,
              withShadow: true,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: space.xs),
            Text(
              transliteration,
              textDirection: TextDirection.ltr,
              style: typo.headline.copyWith(
                fontStyle: FontStyle.italic,
                color: colors.muted,
                height: 1.08,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EtymologyPreview extends StatelessWidget {
  const _EtymologyPreview({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typo = context.typo;

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 50),
      child: Text(
        text,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
        style: typo.body.copyWith(color: colors.muted, height: 1.34),
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
        color: colors.bg.withValues(alpha: 0.54),
        border: Border.all(color: colors.line),
        borderRadius: context.radii.mdAll,
      ),
      child: Padding(
        padding: EdgeInsets.all(space.sm),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: colors.accent.withValues(alpha: 0.09),
                borderRadius: context.radii.smAll,
                border: Border.all(color: colors.line),
              ),
              child: Padding(
                padding: EdgeInsets.all(space.xs),
                child: Icon(
                  Icons.volunteer_activism_outlined,
                  color: colors.accent,
                  size: 20,
                ),
              ),
            ),
            SizedBox(width: space.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.homeDailyActionTitle,
                    textDirection: TextDirection.ltr,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: typo.overline.copyWith(color: colors.muted),
                  ),
                  SizedBox(height: space.xs / 2),
                  Text(
                    action.textFr,
                    textDirection: TextDirection.ltr,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: typo.body.copyWith(
                      color: colors.ink,
                      fontWeight: FontWeight.w600,
                      height: 1.28,
                    ),
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
    final space = context.space;

    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: () => context.push('/name/$nameNumber/experience'),
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(44),
          padding: EdgeInsets.symmetric(vertical: space.sm),
        ),
        icon: const Icon(Icons.auto_awesome_outlined),
        label: Text(l10n.homeExploreTodayName),
      ),
    );
  }
}
