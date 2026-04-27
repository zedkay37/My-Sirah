import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sirah_app/core/providers/settings_provider.dart';

class NamesNotifier {
  const NamesNotifier(this._ref);
  final Ref _ref;

  Set<int> get favorites => _ref.read(settingsProvider).favorites;
  Set<int> get learned => _ref.read(settingsProvider).learned;
  Set<int> get viewed => _ref.read(settingsProvider).viewed;

  Future<void> toggleFavorite(int number) =>
      _ref.read(settingsProvider.notifier).toggleFavorite(number);

  Future<void> markLearned(int number) =>
      _ref.read(settingsProvider.notifier).markLearned(number);

  Future<void> markViewed(int number) =>
      _ref.read(settingsProvider.notifier).markViewed(number);
}

final namesNotifierProvider = Provider<NamesNotifier>(
  (ref) => NamesNotifier(ref),
);
