import 'dart:collection';

import 'package:sirah_app/features/genealogy/data/models/family_member.dart';
import 'package:sirah_app/features/genealogy/data/sources/genealogy_json_source.dart';

class GenealogyRepository {
  GenealogyRepository(this._members)
    : _byId = {for (final m in _members) m.id: m};

  final List<FamilyMember> _members;
  final Map<String, FamilyMember> _byId;
  late final Map<String, Set<String>> _graph = _buildGraph();

  static Future<GenealogyRepository> load() async {
    final members = await GenealogyJsonSource.load();
    return GenealogyRepository(members);
  }

  // ── Queries ──────────────────────────────────────────────────────────────

  List<FamilyMember> getAll() => _members;

  FamilyMember getProphet() {
    final prophet = _byId['muhammad'];
    if (prophet == null) {
      throw StateError(
        'genealogy.json is missing the required "muhammad" entry',
      );
    }
    return prophet;
  }

  FamilyMember? getById(String id) => _byId[id];

  List<FamilyMember> getByRole(FamilyRole role) =>
      _members.where((m) => m.role == role).toList();

  List<FamilyMember> getChildren({String? motherId}) {
    if (motherId == null) {
      return _members.where((m) => m.role == FamilyRole.child).toList();
    }
    return _members
        .where((m) => m.role == FamilyRole.child && m.motherId == motherId)
        .toList();
  }

  List<FamilyMember> search(String query) {
    if (query.isEmpty) return _members;
    final q = query.toLowerCase();
    return _members.where((m) {
      return m.arabic.contains(query) ||
          m.transliteration.toLowerCase().contains(q) ||
          (m.bio?.toLowerCase().contains(q) ?? false);
    }).toList();
  }

  // ── BFS path ─────────────────────────────────────────────────────────────

  /// Returns the shortest path between two family members (inclusive).
  /// Returns an empty list if no path exists.
  List<FamilyMember> getPath(String fromId, String toId) {
    if (fromId == toId) {
      final member = _byId[fromId];
      return member != null ? [member] : [];
    }

    final visited = <String>{fromId};
    final queue = Queue<List<String>>();
    queue.add([fromId]);

    while (queue.isNotEmpty) {
      final path = queue.removeFirst();
      final current = path.last;

      for (final neighbor in _graph[current] ?? const <String>{}) {
        if (neighbor == toId) {
          return [
            ...path,
            toId,
          ].map((id) => _byId[id]).whereType<FamilyMember>().toList();
        }
        if (!visited.contains(neighbor)) {
          visited.add(neighbor);
          queue.add([...path, neighbor]);
        }
      }
    }

    return [];
  }

  // ── Graph construction ───────────────────────────────────────────────────

  Map<String, Set<String>> _buildGraph() {
    final graph = <String, Set<String>>{};

    void addEdge(String a, String b) {
      graph.putIfAbsent(a, () => {}).add(b);
      graph.putIfAbsent(b, () => {}).add(a);
    }

    for (final m in _members) {
      if (m.parentId != null) addEdge(m.id, m.parentId!);
      if (m.motherId != null) addEdge(m.id, m.motherId!);
      if (m.spouseOf != null) addEdge(m.id, m.spouseOf!);
      for (final pid in m.parentIds) {
        addEdge(m.id, pid);
      }
    }

    return graph;
  }
}
