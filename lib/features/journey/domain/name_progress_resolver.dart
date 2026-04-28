enum JourneyNameStage { unknown, viewed, meditated, practiced, recognized }

class NameProgressSummary {
  const NameProgressSummary({
    required this.viewed,
    required this.meditated,
    required this.practiced,
    required this.recognized,
    required this.total,
    required this.weightedProgress,
  });

  final int viewed;
  final int meditated;
  final int practiced;
  final int recognized;
  final int total;
  final double weightedProgress;
}

class NameProgressResolver {
  const NameProgressResolver({
    required this.viewed,
    required this.meditated,
    required this.practiced,
    required this.recognized,
  });

  final Set<int> viewed;
  final Set<int> meditated;
  final Set<int> practiced;
  final Set<int> recognized;

  JourneyNameStage stageFor(int number) {
    if (recognized.contains(number)) return JourneyNameStage.recognized;
    if (practiced.contains(number)) return JourneyNameStage.practiced;
    if (meditated.contains(number)) return JourneyNameStage.meditated;
    if (viewed.contains(number)) return JourneyNameStage.viewed;
    return JourneyNameStage.unknown;
  }

  NameProgressSummary summarize(Iterable<int> numbers) {
    final list = numbers.toList(growable: false);
    if (list.isEmpty) {
      return const NameProgressSummary(
        viewed: 0,
        meditated: 0,
        practiced: 0,
        recognized: 0,
        total: 0,
        weightedProgress: 0,
      );
    }

    var viewedCount = 0;
    var meditatedCount = 0;
    var practicedCount = 0;
    var recognizedCount = 0;
    var score = 0.0;

    for (final number in list) {
      if (viewed.contains(number)) viewedCount++;
      if (meditated.contains(number)) meditatedCount++;
      if (practiced.contains(number)) practicedCount++;
      if (recognized.contains(number)) recognizedCount++;
      score += stageFor(number).weight;
    }

    return NameProgressSummary(
      viewed: viewedCount,
      meditated: meditatedCount,
      practiced: practicedCount,
      recognized: recognizedCount,
      total: list.length,
      weightedProgress: score / list.length,
    );
  }
}

extension JourneyNameStageWeight on JourneyNameStage {
  double get weight {
    return switch (this) {
      JourneyNameStage.recognized => 1,
      JourneyNameStage.practiced => 0.75,
      JourneyNameStage.meditated => 0.5,
      JourneyNameStage.viewed => 0.25,
      JourneyNameStage.unknown => 0,
    };
  }
}
