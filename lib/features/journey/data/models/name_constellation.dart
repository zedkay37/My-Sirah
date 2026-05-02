import 'package:freezed_annotation/freezed_annotation.dart';

part 'name_constellation.freezed.dart';
part 'name_constellation.g.dart';

@freezed
abstract class NameConstellation with _$NameConstellation {
  const factory NameConstellation({
    required String id,
    required String titleFr,
    required String titleAr,
    required String descriptionFr,
    required List<int> nameNumbers,
    required String colorHex,
  }) = _NameConstellation;

  factory NameConstellation.fromJson(Map<String, dynamic> json) =>
      _$NameConstellationFromJson(json);
}
