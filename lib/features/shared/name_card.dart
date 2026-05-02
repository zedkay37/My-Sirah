import 'package:flutter/material.dart';
import 'package:sirah_app/core/theme/app_colors.dart';
import 'package:sirah_app/core/utils/build_context_x.dart';
import 'package:sirah_app/features/journey/domain/name_progress_resolver.dart';
import 'package:sirah_app/features/names/data/models/prophet_name.dart';
import 'package:sirah_app/features/shared/arabic_text.dart';
import 'package:sirah_app/features/shared/category_chip.dart';

class NameCard extends StatelessWidget {
  const NameCard({
    super.key,
    required this.name,
    required this.isFavorite,
    required this.onTap,
    this.onFavoriteTap,
    this.stage = JourneyNameStage.unknown,
  });

  final ProphetName name;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback? onFavoriteTap;
  final JourneyNameStage stage;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typo = context.typo;
    final space = context.space;
    final radii = context.radii;
    final l10n = context.l10n;
    final stageColor = _stageColor(colors);
    final hasJourneyProgress = stage != JourneyNameStage.unknown;

    return Semantics(
      button: true,
      label: '${name.transliteration}, numéro ${name.number}',
      child: InkWell(
        onTap: onTap,
        borderRadius: radii.mdAll,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: space.md,
            vertical: space.sm + 4,
          ),
          child: Row(
            children: [
              // Numéro
              SizedBox(
                width: 40,
                child: Text(
                  '#${name.number.toString().padLeft(3, '0')}',
                  style: typo.caption.copyWith(
                    color: hasJourneyProgress ? stageColor : colors.muted,
                    fontWeight: hasJourneyProgress
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ),
              SizedBox(width: space.sm),
              // Contenu principal
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ArabicText(
                      text: name.arabic,
                      size: ArabicSize.medium,
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      name.transliteration,
                      textDirection: TextDirection.ltr,
                      style: typo.body.copyWith(
                        fontStyle: FontStyle.italic,
                        color: colors.muted,
                      ),
                    ),
                    SizedBox(height: space.xs),
                    CategoryChip(
                      slug: name.categorySlug,
                      label: name.categoryLabel,
                      variant: CategoryChipVariant.small,
                    ),
                  ],
                ),
              ),
              // Icône favori
              if (onFavoriteTap != null)
                Semantics(
                  label: isFavorite ? l10n.favoriteRemove : l10n.favoriteAdd,
                  button: true,
                  child: IconButton(
                    onPressed: onFavoriteTap,
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? colors.error : colors.muted,
                      size: 20,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Color _stageColor(AppColors colors) {
    return switch (stage) {
      JourneyNameStage.recognized => colors.accent,
      JourneyNameStage.practiced => colors.success,
      JourneyNameStage.meditated => colors.accent2,
      JourneyNameStage.viewed => colors.warning,
      JourneyNameStage.unknown => colors.muted,
    };
  }
}
