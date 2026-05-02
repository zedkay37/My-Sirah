import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sirah_app/core/providers/names_providers.dart';
import 'package:sirah_app/core/providers/settings_provider.dart';
import 'package:sirah_app/features/journey/data/repositories/journey_repository.dart';
import 'package:sirah_app/features/journey/data/sources/journey_decks_json_source.dart';
import 'package:sirah_app/features/journey/data/sources/journey_map_layout_json_source.dart';
import 'package:sirah_app/features/journey/domain/name_progress_resolver.dart';

final journeyRepositoryProvider = FutureProvider<JourneyRepository>(
  (ref) => JourneyRepository.load(),
);

final nameConstellationsProvider = FutureProvider<List<NameConstellation>>((
  ref,
) async {
  final repo = await ref.watch(journeyRepositoryProvider.future);
  return repo.getConstellations();
});

final journeyDecksProvider = FutureProvider<List<JourneyDeck>>(
  (_) => JourneyDecksJsonSource.load(),
);

final journeyMapLayoutProvider = FutureProvider<JourneyMapLayout>(
  (_) => JourneyMapLayoutJsonSource.load(),
);

final journeyProgressResolverProvider = Provider<NameProgressResolver>((ref) {
  final settings = ref.watch(settingsProvider);
  return NameProgressResolver(
    viewed: settings.viewed,
    meditated: settings.meditatedNames,
    practiced: settings.practicedNames,
    recognized: settings.recognizedNames,
  );
});

final journeyProgressSummaryProvider = FutureProvider<NameProgressSummary>((
  ref,
) async {
  final names = await ref.watch(namesProvider.future);
  final progress = ref.watch(journeyProgressResolverProvider);
  final numbers = names.map((name) => name.number);
  return progress.summarize(numbers);
});
