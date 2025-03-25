class Place {
  final String name;
  final double lat;
  final double lng;
  final String type;
  final double rating;
  final double distance;
  final List<String> tags;
  final int? price;

  Place({
    required this.name,
    required this.lat,
    required this.lng,
    required this.type,
    required this.rating,
    required this.distance,
    required this.tags,
    this.price,
  });

  // ✅ 이거 추가!
  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      name: json['name'] as String? ?? '',
      lat: (json['lat'] ?? 0).toDouble(),
      lng: (json['lng'] ?? 0).toDouble(),
      type: json['type'] as String? ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      distance: (json['distance'] ?? 0).toDouble(),
      tags: List<String>.from(json['tags'] ?? []),
      price: json['price'] as int?, // nullable 그대로
    );
  }
}
