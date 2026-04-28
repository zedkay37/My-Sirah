import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sirah_app/core/providers/settings_provider.dart';
import 'package:sirah_app/core/providers/user_state.dart';
import 'package:sirah_app/features/names/data/names_notifier.dart';

class _StubSettingsNotifier extends SettingsNotifier {
  @override
  UserState build() => const UserState();

  @override
  Future<void> markNameRecognized(int number) async {
    final recognized = Set<int>.from(state.recognizedNames)..add(number);
    state = state.copyWith(recognizedNames: recognized);
  }
}

void main() {
  test('NamesNotifier marks a name as recognized', () async {
    final container = ProviderContainer(
      overrides: [settingsProvider.overrideWith(() => _StubSettingsNotifier())],
    );
    addTearDown(container.dispose);

    await container.read(namesNotifierProvider).markNameRecognized(42);

    expect(container.read(settingsProvider).recognizedNames, {42});
  });
}
