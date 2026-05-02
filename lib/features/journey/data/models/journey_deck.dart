class JourneyDeck {
  const JourneyDeck({
    required this.id,
    required this.titleFr,
    required this.subtitleFr,
    required this.itemType,
    required this.totalItems,
    required this.status,
  });

  final String id;
  final String titleFr;
  final String subtitleFr;
  final String itemType;
  final int totalItems;
  final String status;

  bool get isActive => status == 'active';

  factory JourneyDeck.fromJson(Map<String, dynamic> json) {
    return JourneyDeck(
      id: json['id'] as String? ?? '',
      titleFr: json['titleFr'] as String? ?? '',
      subtitleFr: json['subtitleFr'] as String? ?? '',
      itemType: json['itemType'] as String? ?? '',
      totalItems: json['totalItems'] as int? ?? 0,
      status: json['status'] as String? ?? 'hidden',
    );
  }
}
