import 'package:sirah_app/features/asmaul_husna/data/models/husna_name.dart';
import 'package:sirah_app/features/asmaul_husna/data/sources/husna_json_source.dart';

class HusnaRepository {
  HusnaRepository._(this._names);

  final List<HusnaName> _names;

  static Future<HusnaRepository> load() async {
    final names = await HusnaJsonSource.load();
    return HusnaRepository._(names);
  }

  List<HusnaName> getAll() => List.unmodifiable(_names);

  HusnaName? getById(int id) {
    try {
      return _names.firstWhere((n) => n.id == id);
    } catch (_) {
      return null;
    }
  }
}
