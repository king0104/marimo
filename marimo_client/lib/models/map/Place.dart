class Place {
  final String name;
  final String type; // 'gas', 'repair', 'carwash'
  final double lat;
  final double lng;
  final double distance; // 단위: km
  final double price; // 주유소일 경우만 사용
  final double rating; // 평점
  final List<String> tags;

  Place({
    required this.name,
    required this.type,
    required this.lat,
    required this.lng,
    required this.distance,
    required this.price,
    required this.rating,
    required this.tags,
  });
}
