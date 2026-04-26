import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sirah_app/core/providers/settings_provider.dart';

class LeitnerRepository {
  const LeitnerRepository(this._ref);
  final Ref _ref;

  Map<int, int> get boxes =>
      _ref.read(settingsProvider).leitnerBoxes;

  List<int> getItemsForReview(List<int> allNumbers) {
    final boxes = this.boxes;
    final level0 = allNumbers
        .where((n) => (boxes[n] ?? 0) == 0)
        .toList();
    final level1 = allNumbers
        .where((n) => (boxes[n] ?? 0) == 1)
        .toList();
    return [...level0, ...level1];
  }

  Future<void> levelUp(int nameNumber) =>
      _ref.read(settingsProvider.notifier).levelUp(nameNumber);

  Future<void> levelDown(int nameNumber) =>
      _ref.read(settingsProvider.notifier).levelDown(nameNumber);
}

final leitnerRepositoryProvider = Provider<LeitnerRepository>(
  (ref) => LeitnerRepository(ref),
);
