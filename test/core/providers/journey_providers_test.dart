import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sirah_app/core/providers/journey_providers.dart';
import 'package:sirah_app/core/providers/names_providers.dart';
import 'package:sirah_app/core/providers/settings_provider.dart';
import 'package:sirah_app/core/providers/user_state.dart';
import 'package:sirah_app/features/journey/domain/name_progress_resolver.dart';
import 'package:sirah_app/features/names/data/models/prophet_name.dart';

const _names = [
  ProphetName(
    number: 1,
    arabic: 'محمد',
    transliteration: 'Muhammad',
    categorySlug: 'praise',
    categoryLabel: 'Louange',
    etymology: '',
    commentary: '',
    references: '',
    primarySource: '',
    secondarySources: '',
  ),
  ProphetName(
    number: 2,
    arabic: 'أحمد',
    transliteration: 'Ahmad',
    categorySlug: 'praise',
    categoryLabel: 'Louange',
    etymology: '',
    commentary: '',
    references: '',
    primarySource: '',
    secondarySources: '',
  ),
];

class _StubSettingsNotifier extends SettingsNotifier {
  @override
  UserState build() => const UserState(
    viewed: {1, 2},
    meditatedNames: {2},
    practicedNames: {2},
    recognizedNames: {2},
  );
}

void main() {
  test('journeyProgressResolverProvider exposes the V2 stage resolver', () {
    final container = ProviderContainer(
      overrides: [settingsProvider.overrideWith(_StubSettingsNotifier.new)],
    );
    addTearDown(container.dispose);

    final resolver = container.read(journeyProgressResolverProvider);

    expect(resolver.stageFor(1), JourneyNameStage.viewed);
    expect(resolver.stageFor(2), JourneyNameStage.recognized);
  });

  test('journeyProgressSummaryProvider summarizes all loaded names', () async {
    final container = ProviderContainer(
      overrides: [
        settingsProvider.overrideWith(_StubSettingsNotifier.new),
        namesProvider.overrideWith((_) async => _names),
      ],
    );
    addTearDown(container.dispose);

    await container.read(namesProvider.future);
    final summary = container.read(journeyProgressSummaryProvider).requireValue;

    expect(summary.viewed, 2);
    expect(summary.meditated, 1);
    expect(summary.practiced, 1);
    expect(summary.recognized, 1);
    expect(summary.total, 2);
    expect(summary.weightedProgress, closeTo(0.625, 0.001));
  });
}
