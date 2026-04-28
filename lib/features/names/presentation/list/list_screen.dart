import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sirah_app/core/providers/names_providers.dart';
import 'package:sirah_app/core/providers/settings_provider.dart';
import 'package:sirah_app/features/names/data/names_notifier.dart';
import 'package:sirah_app/core/utils/build_context_x.dart';
import 'package:sirah_app/features/names/data/models/prophet_name.dart';
import 'package:sirah_app/features/names/data/sources/categories_json_source.dart';
import 'package:sirah_app/features/shared/name_card.dart';

class ListScreen extends ConsumerStatefulWidget {
  const ListScreen({super.key});

  @override
  ConsumerState<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends ConsumerState<ListScreen> {
  final _searchCtrl = TextEditingController();
  String _query = '';
  String? _selectedSlug;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<ProphetName> _filter(List<ProphetName> all) {
    var result = all;

    if (_selectedSlug != null) {
      result = result.where((n) => n.categorySlug == _selectedSlug).toList();
    }

    final q = _query.trim().toLowerCase();
    if (q.isNotEmpty) {
      result = result
          .where(
            (n) =>
                n.arabic.contains(_query.trim()) ||
                n.transliteration.toLowerCase().contains(q) ||
                n.etymology.toLowerCase().contains(q) ||
                n.commentary.toLowerCase().contains(q),
          )
          .toList();
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typo = context.typo;
    final space = context.space;
    final radii = context.radii;
    final l10n = context.l10n;

    final namesAsync = ref.watch(namesProvider);
    final categories = ref.watch(categoriesProvider);
    final favorites = ref.watch(settingsProvider.select((s) => s.favorites));
    final learned = ref.watch(settingsProvider.select((s) => s.learned));
    final notifier = ref.read(namesNotifierProvider);

    // Sync avec le filtre posé depuis CategoryCarousel
    ref.listen<String?>(categoryFilterProvider, (_, next) {
      if (next != null) {
        setState(() => _selectedSlug = next);
        ref.read(categoryFilterProvider.notifier).state = null;
      }
    });

    return Column(
      children: [
        // ── Barre de recherche ────────────────────────────────────────────
        Padding(
          padding: EdgeInsets.fromLTRB(space.md, space.md, space.md, space.sm),
          child: TextField(
            controller: _searchCtrl,
            onChanged: (v) => setState(() => _query = v),
            style: typo.body,
            decoration: InputDecoration(
              hintText: l10n.discoverSearchHint,
              hintStyle: typo.body.copyWith(color: colors.muted),
              prefixIcon: Icon(Icons.search_outlined, color: colors.muted),
              suffixIcon: _query.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear, color: colors.muted, size: 18),
                      onPressed: () {
                        _searchCtrl.clear();
                        setState(() => _query = '');
                      },
                    )
                  : null,
              filled: true,
              fillColor: colors.bg2,
              border: OutlineInputBorder(
                borderRadius: radii.pillAll,
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: radii.pillAll,
                borderSide: BorderSide(color: colors.line),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: radii.pillAll,
                borderSide: BorderSide(color: colors.accent),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: space.md,
                vertical: space.sm,
              ),
            ),
          ),
        ),

        // ── Filtres catégorie ─────────────────────────────────────────────
        SizedBox(
          height: 40,
          child: categories.when(
            data: (cats) => _CategoryFilterBar(
              categories: cats,
              selectedSlug: _selectedSlug,
              onSelect: (slug) => setState(() => _selectedSlug = slug),
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ),

        SizedBox(height: space.xs),

        // ── Liste des noms ────────────────────────────────────────────────
        Expanded(
          child: namesAsync.when(
            data: (names) {
              final filtered = _filter(names);

              if (filtered.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.search_off_outlined,
                        size: 48,
                        color: colors.muted,
                      ),
                      SizedBox(height: space.md),
                      Text(
                        l10n.discoverNoResults,
                        style: typo.body.copyWith(color: colors.muted),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                itemCount: filtered.length,
                itemBuilder: (ctx, i) {
                  final name = filtered[i];
                  return NameCard(
                    name: name,
                    isFavorite: favorites.contains(name.number),
                    isLearned: learned.contains(name.number),
                    onTap: () =>
                        context.push('/name/${name.number}/experience'),
                    onFavoriteTap: () => notifier.toggleFavorite(name.number),
                  );
                },
              );
            },
            loading: () => Center(
              child: CircularProgressIndicator(
                color: colors.accent,
                strokeWidth: 2,
              ),
            ),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }
}

// ── Barre de filtres catégorie ─────────────────────────────────────────────────

class _CategoryFilterBar extends StatelessWidget {
  const _CategoryFilterBar({
    required this.categories,
    required this.selectedSlug,
    required this.onSelect,
  });

  final List<NameCategory> categories;
  final String? selectedSlug;
  final void Function(String? slug) onSelect;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typo = context.typo;
    final space = context.space;
    final radii = context.radii;
    final l10n = context.l10n;

    return ListView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: space.md),
      children: [
        // "Tous" chip
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.only(right: space.xs),
            child: GestureDetector(
              onTap: () => onSelect(null),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: EdgeInsets.symmetric(
                  horizontal: space.md,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: selectedSlug == null
                      ? colors.accent.withValues(alpha: 0.12)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(radii.pill),
                  border: Border.all(
                    color:
                        selectedSlug == null ? colors.accent : colors.line,
                  ),
                ),
                child: Text(
                  l10n.discoverFilterAll,
                  style: typo.caption.copyWith(
                    fontWeight: FontWeight.w600,
                    color: selectedSlug == null ? colors.accent : colors.muted,
                  ),
                ),
              ),
            ),
          ),
        ),
        // Category chips
        ...categories.map(
          (cat) => Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.only(right: space.xs),
              child: GestureDetector(
                onTap: () =>
                    onSelect(selectedSlug == cat.slug ? null : cat.slug),
                child: _CategoryFilterChip(
                  slug: cat.slug,
                  label: cat.labelFr,
                  isSelected: selectedSlug == cat.slug,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CategoryFilterChip extends StatelessWidget {
  const _CategoryFilterChip({
    required this.slug,
    required this.label,
    required this.isSelected,
  });

  final String slug;
  final String label;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typo = context.typo;
    final space = context.space;
    final radii = context.radii;

    final catColor = colors.categoryColor(slug);
    final catBg = colors.categoryBg(slug);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      padding: EdgeInsets.symmetric(horizontal: space.md, vertical: 3),
      decoration: BoxDecoration(
        color: isSelected ? catBg : Colors.transparent,
        borderRadius: BorderRadius.circular(radii.pill),
        border: Border.all(
          color: isSelected ? catColor : colors.line,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: catColor,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: space.xs),
          Text(
            label,
            style: typo.caption.copyWith(
              fontWeight: FontWeight.w600,
              color: isSelected ? catColor : colors.muted,
            ),
          ),
        ],
      ),
    );
  }
}
