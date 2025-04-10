class RepairShopPlace {
  final int id; // ← Integer로 직접 받음
  final String name;
  final String type;
  final String address;
  final String roadAddress;
  final double lat;
  final double lng;
  final String status;
  final String openTime;
  final String closeTime;
  final String phone;

  const RepairShopPlace({
    required this.id,
    required this.name,
    required this.type,
    required this.address,
    required this.roadAddress,
    required this.lat,
    required this.lng,
    required this.status,
    required this.openTime,
    required this.closeTime,
    required this.phone,
  });

  factory RepairShopPlace.fromJson(Map<String, dynamic> json) {
    return RepairShopPlace(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      address: json['address'] ?? '',
      roadAddress: json['roadAddress'] ?? '',
      lat: (json['latitude'] ?? 0).toDouble(),
      lng: (json['longitude'] ?? 0).toDouble(),
      status: json['status'] ?? '',
      openTime: json['openTime'] ?? '',
      closeTime: json['closeTime'] ?? '',
      phone: json['phone'] ?? '',
    );
  }
}
