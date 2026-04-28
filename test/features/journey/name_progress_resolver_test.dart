import 'package:flutter_test/flutter_test.dart';
import 'package:sirah_app/features/journey/domain/name_progress_resolver.dart';

void main() {
  test('stageFor returns the highest known progression stage', () {
    const resolver = NameProgressResolver(
      viewed: {1, 2, 3, 4},
      meditated: {2, 3, 4},
      practiced: {3, 4},
      recognized: {4},
    );

    expect(resolver.stageFor(1), JourneyNameStage.viewed);
    expect(resolver.stageFor(2), JourneyNameStage.meditated);
    expect(resolver.stageFor(3), JourneyNameStage.practiced);
    expect(resolver.stageFor(4), JourneyNameStage.recognized);
    expect(resolver.stageFor(5), JourneyNameStage.unknown);
  });

  test('summarize counts each stage and computes weighted progress', () {
    const resolver = NameProgressResolver(
      viewed: {1, 2, 3, 4},
      meditated: {2, 3, 4},
      practiced: {3, 4},
      recognized: {4},
    );

    final summary = resolver.summarize([1, 2, 3, 4, 5]);

    expect(summary.viewed, 4);
    expect(summary.meditated, 3);
    expect(summary.practiced, 2);
    expect(summary.recognized, 1);
    expect(summary.total, 5);
    expect(summary.weightedProgress, closeTo(0.5, 0.001));
  });
}
