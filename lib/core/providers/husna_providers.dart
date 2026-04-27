import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sirah_app/core/providers/settings_provider.dart';
import 'package:sirah_app/features/asmaul_husna/data/models/husna_name.dart';
import 'package:sirah_app/features/asmaul_husna/data/repositories/husna_repository.dart';

final husnaRepositoryProvider = FutureProvider<HusnaRepository>(
  (_) => HusnaRepository.load(),
);

final husnaProvider = FutureProvider<List<HusnaName>>((ref) async {
  final repo = await ref.watch(husnaRepositoryProvider.future);
  return repo.getAll();
});

final husnaLearnedCountProvider = Provider<int>((ref) {
  return ref.watch(settingsProvider.select((s) => s.husnaLearned.length));
});
