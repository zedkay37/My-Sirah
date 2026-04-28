class JourneyMapLayout {
  const JourneyMapLayout({
    required this.deckId,
    required this.galaxy,
    required this.constellations,
    required this.stars,
  });

  final String deckId;
  final MapNode galaxy;
  final List<ConstellationMapNode> constellations;
  final Map<String, List<StarMapNode>> stars;

  factory JourneyMapLayout.fromJson(Map<String, dynamic> json) {
    final starGroups = <String, List<StarMapNode>>{};
    final rawStars = json['stars'];
    if (rawStars is Map<String, dynamic>) {
      for (final entry in rawStars.entries) {
        final value = entry.value;
        if (value is List<dynamic>) {
          starGroups[entry.key] = value
              .whereType<Map<String, dynamic>>()
              .map(StarMapNode.fromJson)
              .toList();
        }
      }
    }

    return JourneyMapLayout(
      deckId: json['deckId'] as String? ?? '',
      galaxy: MapNode.fromJson(
        (json['galaxy'] as Map<String, dynamic>?) ?? const {},
      ),
      constellations:
          (json['constellations'] as List<dynamic>? ?? const <dynamic>[])
              .whereType<Map<String, dynamic>>()
              .map(ConstellationMapNode.fromJson)
              .toList(),
      stars: starGroups,
    );
  }

  ConstellationMapNode? constellationNode(String id) {
    for (final node in constellations) {
      if (node.id == id) return node;
    }
    return null;
  }

  List<StarMapNode> starsFor(String constellationId) {
    return stars[constellationId] ?? const [];
  }
}

class MapNode {
  const MapNode({required this.x, required this.y, required this.radius});

  final double x;
  final double y;
  final double radius;

  factory MapNode.fromJson(Map<String, dynamic> json) {
    return MapNode(
      x: _double(json['x']),
      y: _double(json['y']),
      radius: _double(json['radius']),
    );
  }
}

class ConstellationMapNode extends MapNode {
  const ConstellationMapNode({
    required this.id,
    required super.x,
    required super.y,
    required super.radius,
  });

  final String id;

  factory ConstellationMapNode.fromJson(Map<String, dynamic> json) {
    return ConstellationMapNode(
      id: json['id'] as String? ?? '',
      x: _double(json['x']),
      y: _double(json['y']),
      radius: _double(json['radius']),
    );
  }
}

class StarMapNode {
  const StarMapNode({
    required this.number,
    required this.x,
    required this.y,
    required this.size,
  });

  final int number;
  final double x;
  final double y;
  final double size;

  factory StarMapNode.fromJson(Map<String, dynamic> json) {
    return StarMapNode(
      number: json['number'] as int? ?? 0,
      x: _double(json['x']),
      y: _double(json['y']),
      size: _double(json['size'], fallback: 1),
    );
  }
}

double _double(Object? value, {double fallback = 0}) {
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? fallback;
  return fallback;
}
