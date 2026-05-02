import 'package:sirah_app/features/journey/data/repositories/journey_repository.dart';

String constellationDisplayTitle(NameConstellation constellation) {
  final title = constellation.titleFr.trim();
  final displayTitle = title.replaceFirst(
    RegExp(r'^Constellation\s*-\s*', caseSensitive: false),
    '',
  );
  return displayTitle.isEmpty ? title : displayTitle;
}

String? constellationArabicTitle(NameConstellation constellation) {
  final title = constellation.titleAr.trim();
  return _containsArabicScript(title) ? title : null;
}

bool _containsArabicScript(String value) {
  for (final rune in value.runes) {
    if ((rune >= 0x0600 && rune <= 0x06FF) ||
        (rune >= 0x0750 && rune <= 0x077F) ||
        (rune >= 0x08A0 && rune <= 0x08FF) ||
        (rune >= 0xFB50 && rune <= 0xFDFF) ||
        (rune >= 0xFE70 && rune <= 0xFEFF)) {
      return true;
    }
  }
  return false;
}
