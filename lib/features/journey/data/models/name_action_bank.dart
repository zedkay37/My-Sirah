import 'package:freezed_annotation/freezed_annotation.dart';

part 'name_action_bank.freezed.dart';
part 'name_action_bank.g.dart';

@freezed
abstract class NameActionBank with _$NameActionBank {
  const factory NameActionBank({
    required String theme,
    @Default([]) List<NameActionItem> actions,
  }) = _NameActionBank;

  factory NameActionBank.fromJson(Map<String, dynamic> json) =>
      _$NameActionBankFromJson(json);
}

@freezed
abstract class NameActionItem with _$NameActionItem {
  const factory NameActionItem({
    required String id,
    required String textFr,
    @Default('needs_review') String editorialStatus,
    @Default('short') String duration,
    @Default('simple') String difficulty,
    @Default([]) List<String> contexts,
    @Default([]) List<int> nameNumbers,
    @Default('') String sourceNote,
    @Default([]) List<String> sourceRefs,
    @Default('') String reviewedBy,
    @Default('') String validatedAt,
    @Default('') String reviewNotes,
  }) = _NameActionItem;

  factory NameActionItem.fromJson(Map<String, dynamic> json) =>
      _$NameActionItemFromJson(json);
}
