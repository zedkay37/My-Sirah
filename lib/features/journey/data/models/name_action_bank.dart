import 'package:freezed_annotation/freezed_annotation.dart';

part 'name_action_bank.freezed.dart';
part 'name_action_bank.g.dart';

@freezed
abstract class NameActionBank with _$NameActionBank {
  const factory NameActionBank({
    required String theme,
    @Default([]) List<String> actions,
  }) = _NameActionBank;

  factory NameActionBank.fromJson(Map<String, dynamic> json) =>
      _$NameActionBankFromJson(json);
}
