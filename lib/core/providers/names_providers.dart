import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sirah_app/core/providers/settings_provider.dart';
import 'package:sirah_app/features/names/data/models/prophet_name.dart';
import 'package:sirah_app/features/names/data/repositories/names_repository.dart';
import 'package:sirah_app/features/names/data/sources/categories_json_source.dart';

// Repository chargé une seule fois au démarrage
final namesRepositoryProvider = FutureProvider<NamesRepository>(
  (ref) => NamesRepository.load(),
);

// Liste complète des 201 noms
final namesProvider = FutureProvider<List<ProphetName>>((ref) async {
  final repo = await ref.watch(namesRepositoryProvider.future);
  return repo.getAll();
});

// Nom du jour — déterministe par date
final dailyNameProvider = FutureProvider<ProphetName>((ref) async {
  final repo = await ref.watch(namesRepositoryProvider.future);
  return repo.getDailyName();
});

// Catégories depuis categories.json
final categoriesProvider = FutureProvider<List<NameCategory>>(
  (_) => CategoriesJsonSource.load(),
);

// Filtre actif dans la liste (slug de catégorie, null = tous)
final categoryFilterProvider = StateProvider<String?>((_) => null);

// Map<categorySlug, learnedCount> — recalculé quand learned ou names changent
final learnedCountsProvider = Provider<Map<String, int>>((ref) {
  final namesAsync = ref.watch(namesProvider);
  final learned = ref.watch(settingsProvider.select((s) => s.learned));

  return namesAsync.when(
    data: (names) {
      final counts = <String, int>{};
      for (final name in names) {
        if (learned.contains(name.number)) {
          counts[name.categorySlug] = (counts[name.categorySlug] ?? 0) + 1;
        }
      }
      return counts;
    },
    loading: () => {},
    error: (_, __) => {},
  );
});
