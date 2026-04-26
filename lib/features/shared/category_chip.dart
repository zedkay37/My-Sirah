import 'package:flutter/material.dart';
import 'package:sirah_app/core/utils/build_context_x.dart';

enum CategoryChipVariant { filled, outlined, small }

class CategoryChip extends StatelessWidget {
  const CategoryChip({
    super.key,
    required this.slug,
    required this.label,
    this.variant = CategoryChipVariant.filled,
    this.onTap,
    this.isSelected = false,
  });

  final String slug;
  final String label;
  final CategoryChipVariant variant;
  final VoidCallback? onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typo = context.typo;
    final space = context.space;
    final radii = context.radii;
    final catColor = colors.categoryColor(slug);
    final catBg = colors.categoryBg(slug);

    final isSmall = variant == CategoryChipVariant.small;
    final isFilled = variant == CategoryChipVariant.filled || isSelected;

    final bg = isFilled ? catBg : Colors.transparent;
    final border = Border.all(
      color: catColor.withValues(alpha: isFilled ? 0 : 0.4),
      width: 1,
    );

    return GestureDetector(
      onTap: onTap,
      child: Semantics(
        label: label,
        button: onTap != null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: EdgeInsets.symmetric(
            horizontal: isSmall ? space.sm : space.md,
            vertical: isSmall ? 3 : space.xs,
          ),
          decoration: BoxDecoration(
            color: bg,
            border: border,
            borderRadius: BorderRadius.circular(radii.pill),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: isSmall ? 6 : 8,
                height: isSmall ? 6 : 8,
                decoration: BoxDecoration(
                  color: catColor,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: space.xs),
              Text(
                label,
                style: (isSmall ? typo.caption : typo.button).copyWith(
                  color: isFilled ? catColor : colors.muted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
