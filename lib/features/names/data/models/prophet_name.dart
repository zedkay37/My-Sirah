import 'package:freezed_annotation/freezed_annotation.dart';

part 'prophet_name.freezed.dart';
part 'prophet_name.g.dart';

@freezed
abstract class ProphetName with _$ProphetName {
  const factory ProphetName({
    // JSON: "id" → numéro 1-201
    @JsonKey(name: 'id') required int number,
    // JSON: "arabic" → مُحَمَّد
    required String arabic,
    // JSON: "transliteration" → Muḥammad
    required String transliteration,
    // JSON: "categorySlug" → clé technique "praise"
    @JsonKey(name: 'categorySlug') required String categorySlug,
    // JSON: "category" → label FR "Louange"
    @JsonKey(name: 'category') required String categoryLabel,
    required String etymology,
    required String commentary,
    required String references,
    required String primarySource,
    required String secondarySources,
  }) = _ProphetName;

  factory ProphetName.fromJson(Map<String, dynamic> json) =>
      _$ProphetNameFromJson(json);
}
