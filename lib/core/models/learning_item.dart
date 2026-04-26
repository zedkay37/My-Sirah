import 'package:freezed_annotation/freezed_annotation.dart';

part 'learning_item.freezed.dart';

@freezed
abstract class LearningItem with _$LearningItem {
  const factory LearningItem({
    required String id,
    required String deckId,
    required String front,
    required String back,
    String? arabicText,
    int? nameNumber,
  }) = _LearningItem;
}
