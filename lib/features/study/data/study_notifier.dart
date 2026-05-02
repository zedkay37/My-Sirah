import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sirah_app/core/providers/settings_provider.dart';

class StudyNotifier {
  const StudyNotifier(this._ref);
  final Ref _ref;

  Map<int, int> get leitnerBoxes => _ref.read(settingsProvider).leitnerBoxes;

  String get studyMode => _ref.read(settingsProvider).studyMode;

  Set<String> get completedParcours =>
      _ref.read(settingsProvider).completedParcours;

  List<int> getItemsForReview(List<int> allNumbers) {
    final boxes = leitnerBoxes;
    final level0 = allNumbers.where((n) => (boxes[n] ?? 0) == 0).toList();
    final level1 = allNumbers.where((n) => (boxes[n] ?? 0) == 1).toList();
    return [...level0, ...level1];
  }

  Future<void> levelUp(int nameNumber) =>
      _ref.read(settingsProvider.notifier).levelUp(nameNumber);

  Future<void> markNameRecognized(int nameNumber) =>
      _ref.read(settingsProvider.notifier).markNameRecognized(nameNumber);

  Future<void> levelDown(int nameNumber) =>
      _ref.read(settingsProvider.notifier).levelDown(nameNumber);

  Future<void> setStudyMode(String mode) =>
      _ref.read(settingsProvider.notifier).setStudyMode(mode);

  Future<void> markParcoursComplete(String id) =>
      _ref.read(settingsProvider.notifier).markParcoursComplete(id);
}

final studyNotifierProvider = Provider<StudyNotifier>(
  (ref) => StudyNotifier(ref),
);
