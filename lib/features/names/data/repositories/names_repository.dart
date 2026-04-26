import 'package:sirah_app/features/names/data/models/prophet_name.dart';
import 'package:sirah_app/features/names/data/sources/names_json_source.dart';

class NamesRepository {
  NamesRepository(this._names);

  final List<ProphetName> _names;

  static Future<NamesRepository> load() async {
    final names = await NamesJsonSource.load();
    return NamesRepository(names);
  }

  List<ProphetName> getAll() => _names;

  List<ProphetName> getByCategory(String slug) =>
      _names.where((n) => n.categorySlug == slug).toList();

  List<ProphetName> search(String query) {
    if (query.isEmpty) return _names;
    final q = query.toLowerCase();
    return _names.where((n) {
      return n.arabic.contains(query) ||
          n.transliteration.toLowerCase().contains(q) ||
          n.etymology.toLowerCase().contains(q) ||
          n.commentary.toLowerCase().contains(q);
    }).toList();
  }

  ProphetName? getByNumber(int number) {
    try {
      return _names.firstWhere((n) => n.number == number);
    } on StateError {
      return null;
    }
  }

  ProphetName getDailyName() {
    final epoch = DateTime(2025, 1, 1);
    final days = DateTime.now().difference(epoch).inDays;
    return _names[days % _names.length];
  }
}
