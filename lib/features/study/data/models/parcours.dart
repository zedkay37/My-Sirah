import 'package:freezed_annotation/freezed_annotation.dart';

part 'parcours.freezed.dart';
part 'parcours.g.dart';

@freezed
abstract class Parcours with _$Parcours {
  const factory Parcours({
    required String id,
    required String titleFr,
    required String titleAr,
    required String descriptionFr,
    required List<int> nameNumbers,
    required String colorHex,
  }) = _Parcours;

  factory Parcours.fromJson(Map<String, dynamic> json) =>
      _$ParcoursFromJson(json);
}
