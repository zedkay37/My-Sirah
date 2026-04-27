import 'package:freezed_annotation/freezed_annotation.dart';

part 'husna_name.freezed.dart';
part 'husna_name.g.dart';

@freezed
abstract class HusnaName with _$HusnaName {
  const factory HusnaName({
    required int id,
    required String arabic,
    required String transliteration,
    required String meaningFr,
    @Default('') String etymology,
    @Default('') String reference,
  }) = _HusnaName;

  factory HusnaName.fromJson(Map<String, dynamic> json) =>
      _$HusnaNameFromJson(json);
}
