class Place {
  final String id;
  final String name;
  final String brand;
  final String address;
  final String roadAddress;
  final double lat;
  final double lng;
  final bool hasSelfService;
  final bool hasMaintenance;
  final bool hasCarWash;
  final bool hasCvs;
  final double? price;
  final double? discountedPrice;
  final double discountAmount; // 🔄 타입 변경
  final int distance;
  final String oilType;
  final bool isOilCardRegistered;
  final bool isOilCardMonthlyRequirementSatisfied;

  const Place({
    required this.id,
    required this.name,
    required this.brand,
    required this.address,
    required this.roadAddress,
    required this.lat,
    required this.lng,
    required this.hasSelfService,
    required this.hasMaintenance,
    required this.hasCarWash,
    required this.hasCvs,
    required this.price,
    required this.discountedPrice,
    required this.discountAmount,
    required this.distance,
    required this.oilType,
    required this.isOilCardRegistered, // ✅ 추가
    required this.isOilCardMonthlyRequirementSatisfied, // ✅ 추가
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      brand: json['brand'] ?? '',
      address: json['address'] ?? '',
      roadAddress: json['roadAddress'] ?? '',
      lat: (json['latitude'] ?? 0).toDouble(),
      lng: (json['longitude'] ?? 0).toDouble(),
      hasSelfService: json['hasSelfService'] ?? false,
      hasMaintenance: json['hasMaintenance'] ?? false,
      hasCarWash: json['hasCarWash'] ?? false,
      hasCvs: json['hasCvs'] ?? false,
      price: (json['price'] as num?)?.toDouble(),
      discountedPrice: (json['discountedPrice'] as num?)?.toDouble(),
      discountAmount: (json['discountAmount'] as num?)?.toDouble() ?? 0.0,
      distance: (json['distance'] as num?)?.toInt() ?? 0, // 🔄 수정됨
      oilType: json['oilType'] ?? '휘발유',
      // ✅ JSON 파싱 필드 추가
      isOilCardRegistered: json['isOilCardRegistered'] ?? false,
      isOilCardMonthlyRequirementSatisfied:
          json['isOilCardMonthlyRequirementSatisfied'] ?? false,
    );
  }
}
