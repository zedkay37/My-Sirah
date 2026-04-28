import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sirah_app/core/providers/names_providers.dart';
import 'package:sirah_app/core/providers/settings_provider.dart';
import 'package:sirah_app/features/names/data/names_notifier.dart';
import 'package:sirah_app/core/utils/build_context_x.dart';
import 'package:sirah_app/features/shared/name_card.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final typo = context.typo;
    final space = context.space;
    final l10n = context.l10n;

    final namesAsync = ref.watch(namesProvider);
    final favorites = ref.watch(settingsProvider.select((s) => s.favorites));
    final learned = ref.watch(settingsProvider.select((s) => s.learned));
    final notifier = ref.read(namesNotifierProvider);

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(
        backgroundColor: colors.bg,
        surfaceTintColor: colors.bg,
        elevation: 0,
        title: Text(l10n.favoritesTitle, style: typo.headline),
      ),
      body: namesAsync.when(
        loading: () => Center(
          child: CircularProgressIndicator(
            color: colors.accent,
            strokeWidth: 2,
          ),
        ),
        error: (_, __) => const SizedBox.shrink(),
        data: (names) {
          final favNames = names
              .where((n) => favorites.contains(n.number))
              .toList();

          if (favNames.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.favorite_border, size: 48, color: colors.muted),
                  SizedBox(height: space.md),
                  Text(
                    l10n.favoritesEmpty,
                    style: typo.body.copyWith(color: colors.muted),
                  ),
                  SizedBox(height: space.sm),
                  TextButton(
                    onPressed: () => context.go('/library/deck/prophet_names'),
                    child: Text(
                      l10n.favoritesEmptyCta,
                      style: typo.button.copyWith(color: colors.accent),
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: favNames.length,
            itemBuilder: (ctx, i) {
              final name = favNames[i];
              return NameCard(
                name: name,
                isFavorite: true,
                isLearned: learned.contains(name.number),
                onTap: () => context.push('/name/${name.number}'),
                onFavoriteTap: () => notifier.toggleFavorite(name.number),
              );
            },
          );
        },
      ),
    );
  }
}
