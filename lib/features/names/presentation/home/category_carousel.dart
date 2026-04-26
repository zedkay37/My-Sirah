import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sirah_app/core/providers/names_providers.dart';
import 'package:sirah_app/core/utils/build_context_x.dart';
import 'package:sirah_app/features/names/data/sources/categories_json_source.dart';
import 'package:sirah_app/features/shared/progress_ring.dart';

class CategoryCarousel extends ConsumerWidget {
  const CategoryCarousel({
    super.key,
    required this.categories,
    required this.learnedCounts,
  });

  final List<NameCategory> categories;
  final Map<String, int> learnedCounts;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final space = context.space;

    return SizedBox(
      height: 130,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: space.md),
        itemCount: categories.length,
        separatorBuilder: (_, __) => SizedBox(width: space.sm),
        itemBuilder: (ctx, i) {
          final cat = categories[i];
          return _CategoryCard(
            category: cat,
            learnedCount: learnedCounts[cat.slug] ?? 0,
            onTap: () {
              ref.read(categoryFilterProvider.notifier).state = cat.slug;
              context.go('/discover');
            },
          );
        },
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.category,
    required this.learnedCount,
    required this.onTap,
  });

  final NameCategory category;
  final int learnedCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typo = context.typo;
    final space = context.space;
    final radii = context.radii;
    final l10n = context.l10n;

    final catColor = colors.categoryColor(category.slug);
    final catBg = colors.categoryBg(category.slug);
    final progress =
        category.count > 0 ? learnedCount / category.count : 0.0;

    return Semantics(
      label: '${category.labelFr}, $learnedCount sur ${category.count} appris',
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 120,
          padding: EdgeInsets.all(space.md),
          decoration: BoxDecoration(
            color: catBg,
            borderRadius: BorderRadius.circular(radii.lg),
            border: Border.all(color: catColor.withValues(alpha: 0.25)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      category.labelFr,
                      style: typo.button.copyWith(color: catColor),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  ProgressRing(
                    progress: progress,
                    size: 24,
                    strokeWidth: 3,
                    color: catColor,
                    backgroundColor: catColor.withValues(alpha: 0.15),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                l10n.homeCategoryLearned(learnedCount, category.count),
                style: typo.caption.copyWith(color: colors.muted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
