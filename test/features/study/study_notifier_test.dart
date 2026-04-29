// ignore_for_file: invalid_use_of_protected_member
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sirah_app/core/providers/settings_provider.dart';
import 'package:sirah_app/core/providers/user_state.dart';
import 'package:sirah_app/features/study/data/study_notifier.dart';
import 'package:sirah_app/features/study/presentation/review/review_controller.dart';

// ── Stub SettingsNotifier (pas de Hive, pas de notifications) ─────────────────

class _StubSettingsNotifier extends SettingsNotifier {
  _StubSettingsNotifier([UserState? initial]) : _initial = initial;
  final UserState? _initial;

  @override
  UserState build() => _initial ?? const UserState();

  /// On court-circuite _save : pas de Hive, pas de NotificationService.
  @override
  Future<void> levelUp(int nameNumber) async {
    final boxes = Map<int, int>.from(state.leitnerBoxes);
    final current = boxes[nameNumber] ?? 0;
    boxes[nameNumber] = (current + 1).clamp(0, 2);
    state = state.copyWith(leitnerBoxes: boxes);
  }

  @override
  Future<void> levelDown(int nameNumber) async {
    final boxes = Map<int, int>.from(state.leitnerBoxes);
    final current = boxes[nameNumber] ?? 0;
    boxes[nameNumber] = (current - 1).clamp(0, 2);
    state = state.copyWith(leitnerBoxes: boxes);
  }

  @override
  Future<void> markNameRecognized(int number) async {
    final recognized = Set<int>.from(state.recognizedNames)..add(number);
    state = state.copyWith(recognizedNames: recognized);
  }
}

// ── Helpers ───────────────────────────────────────────────────────────────────

ProviderContainer _makeContainer(UserState initial) {
  return ProviderContainer(
    overrides: [
      settingsProvider.overrideWith(() => _StubSettingsNotifier(initial)),
    ],
  );
}

// ── Tests ─────────────────────────────────────────────────────────────────────

void main() {
  group('StudyNotifier', () {
    group('getItemsForReview', () {
      test('retourne les noms niveau 0 en premier, puis niveau 1', () {
        final state = const UserState().copyWith(
          leitnerBoxes: {
            1: 0, // niveau 0
            2: 1, // niveau 1
            3: 2, // niveau 2 → exclu
            4: 0, // niveau 0
            5: 1, // niveau 1
          },
        );
        final container = _makeContainer(state);
        addTearDown(container.dispose);

        final notifier = container.read(studyNotifierProvider);
        final result = notifier.getItemsForReview([1, 2, 3, 4, 5]);

        // Niveau 2 exclu
        expect(result, isNot(contains(3)));

        // Niveau 0 avant niveau 1
        final idx1 = result.indexOf(1); // level 0
        final idx4 = result.indexOf(4); // level 0
        final idx2 = result.indexOf(2); // level 1
        final idx5 = result.indexOf(5); // level 1

        expect(
          idx1,
          lessThan(idx2),
          reason: 'les noms niveau 0 doivent précéder les noms niveau 1',
        );
        expect(
          idx4,
          lessThan(idx5),
          reason: 'les noms niveau 0 doivent précéder les noms niveau 1',
        );
      });

      test('exclut les noms de niveau 2 (maîtrisés)', () {
        final state = const UserState().copyWith(
          leitnerBoxes: {1: 2, 2: 2, 3: 2},
        );
        final container = _makeContainer(state);
        addTearDown(container.dispose);

        final notifier = container.read(studyNotifierProvider);
        expect(notifier.getItemsForReview([1, 2, 3]), isEmpty);
      });

      test('considère les noms absents de la map comme niveau 0', () {
        // Aucune entrée dans leitnerBoxes → tous les noms sont niveau 0
        final container = _makeContainer(const UserState());
        addTearDown(container.dispose);

        final notifier = container.read(studyNotifierProvider);
        final result = notifier.getItemsForReview([10, 20, 30]);

        expect(result, containsAll([10, 20, 30]));
        expect(result.length, 3);
      });

      test('retourne une liste vide si allNumbers est vide', () {
        final container = _makeContainer(const UserState());
        addTearDown(container.dispose);

        final notifier = container.read(studyNotifierProvider);
        expect(notifier.getItemsForReview([]), isEmpty);
      });
    });

    group('levelUp', () {
      test(
        'augmente le niveau d\'un nom de 0 à 1 dans le settingsProvider',
        () async {
          final container = _makeContainer(const UserState());
          addTearDown(container.dispose);

          final notifier = container.read(studyNotifierProvider);
          await notifier.levelUp(42);

          final boxes = container.read(settingsProvider).leitnerBoxes;
          expect(boxes[42], 1);
        },
      );

      test('est plafonné à 2 (ne dépasse pas le niveau max)', () async {
        final state = const UserState().copyWith(leitnerBoxes: {7: 2});
        final container = _makeContainer(state);
        addTearDown(container.dispose);

        final notifier = container.read(studyNotifierProvider);
        await notifier.levelUp(7);

        final boxes = container.read(settingsProvider).leitnerBoxes;
        expect(boxes[7], 2);
      });
    });

    group('review controller', () {
      test('Je connais marque le nom comme reconnu', () async {
        final container = _makeContainer(const UserState());
        addTearDown(container.dispose);

        await container.read(reviewControllerProvider([42]).notifier).know();

        expect(container.read(settingsProvider).leitnerBoxes[42], 1);
        expect(container.read(settingsProvider).recognizedNames, contains(42));
      });
    });

    group('levelDown', () {
      test('réduit le niveau d\'un nom de 2 à 1', () async {
        final state = const UserState().copyWith(leitnerBoxes: {5: 2});
        final container = _makeContainer(state);
        addTearDown(container.dispose);

        final notifier = container.read(studyNotifierProvider);
        await notifier.levelDown(5);

        final boxes = container.read(settingsProvider).leitnerBoxes;
        expect(boxes[5], 1);
      });

      test(
        'est planché à 0 (ne descend pas en dessous du niveau min)',
        () async {
          final container = _makeContainer(const UserState());
          addTearDown(container.dispose);

          final notifier = container.read(studyNotifierProvider);
          await notifier.levelDown(99); // absent = 0, clamp(0,2) = 0

          final boxes = container.read(settingsProvider).leitnerBoxes;
          expect(boxes[99], 0);
        },
      );
    });
  });
}
