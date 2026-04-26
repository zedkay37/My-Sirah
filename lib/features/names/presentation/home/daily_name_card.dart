import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:sirah_app/core/utils/build_context_x.dart';
import 'package:sirah_app/features/names/data/models/prophet_name.dart';
import 'package:sirah_app/features/shared/arabic_text.dart';
import 'package:sirah_app/features/shared/category_chip.dart';

class DailyNameCard extends StatelessWidget {
  const DailyNameCard({super.key, required this.name});

  final ProphetName name;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typo = context.typo;
    final space = context.space;
    final radii = context.radii;
    final l10n = context.l10n;
    final screenHeight = MediaQuery.of(context).size.height;

    return Semantics(
      label: '${name.transliteration}, nom du jour numéro ${name.number}',
      child: Container(
        height: screenHeight * 0.58,
        decoration: BoxDecoration(
          color: colors.bg2,
          borderRadius: radii.lgAll,
          border: Border.all(color: colors.line),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => context.push('/name/${name.number}'),
          borderRadius: radii.lgAll,
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
                const Spacer(),
                ArabicText(
                  text: name.arabic,
                  size: ArabicSize.hero,
                  withShadow: true,
                ),
                SizedBox(height: space.sm),
                Text(
                  name.transliteration,
                  style: typo.headline.copyWith(
                    fontStyle: FontStyle.italic,
                    color: colors.muted,
                  ),
                ),
                SizedBox(height: space.xl),
                _EtymologyFade(text: name.etymology),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => context.push('/name/${name.number}'),
                    child: Text(l10n.homeDiscoverName),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 450.ms)
        .slideY(begin: 0.04, end: 0, curve: Curves.easeOut);
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
            style: typo.body.copyWith(color: colors.muted),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.3, 1.0],
                  colors: [
                    colors.bg2.withValues(alpha: 0),
                    colors.bg2,
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
