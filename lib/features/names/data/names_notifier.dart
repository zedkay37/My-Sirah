import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sirah_app/core/providers/settings_provider.dart';

class NamesNotifier {
  const NamesNotifier(this._ref);
  final Ref _ref;

  Set<int> get favorites => _ref.read(settingsProvider).favorites;
  Set<int> get learned => _ref.read(settingsProvider).learned;
  Set<int> get viewed => _ref.read(settingsProvider).viewed;
  Set<int> get meditatedNames => _ref.read(settingsProvider).meditatedNames;
  Set<int> get practicedNames => _ref.read(settingsProvider).practicedNames;
  Set<int> get recognizedNames => _ref.read(settingsProvider).recognizedNames;

  Future<void> toggleFavorite(int number) =>
      _ref.read(settingsProvider.notifier).toggleFavorite(number);

  Future<void> markLearned(int number) =>
      _ref.read(settingsProvider.notifier).markLearned(number);

  Future<void> markViewed(int number) =>
      _ref.read(settingsProvider.notifier).markViewed(number);

  Future<void> markNameMeditated(int number) =>
      _ref.read(settingsProvider.notifier).markNameMeditated(number);

  Future<void> markNamePracticed(int number) =>
      _ref.read(settingsProvider.notifier).markNamePracticed(number);

  Future<void> markNameRecognized(int number) =>
      _ref.read(settingsProvider.notifier).markNameRecognized(number);
}

final namesNotifierProvider = Provider<NamesNotifier>(
  (ref) => NamesNotifier(ref),
);
