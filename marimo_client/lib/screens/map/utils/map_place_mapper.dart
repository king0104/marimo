import 'package:marimo_client/models/map/gas_station_place.dart';

Place mapGasStationJsonToPlace(Map<String, dynamic> json) {
  return Place(
    id: json['id'].toString(), // int → string 변환
    name: json['name'] ?? '',
    brand: json['brand'] ?? '',
    address: json['address'] ?? '',
    roadAddress: json['roadAddress'] ?? '',
    lat: (json['latitude'] as num?)?.toDouble() ?? 0.0,
    lng: (json['longitude'] as num?)?.toDouble() ?? 0.0,
    hasSelfService: json['hasSelfService'] ?? false,
    hasMaintenance: json['hasMaintenance'] ?? false,
    hasCarWash: json['hasCarWash'] ?? false,
    hasCvs: json['hasCvs'] ?? false,
    price: (json['price'] as num?)?.toDouble(),
    discountedPrice: (json['discountedPrice'] as num?)?.toDouble(),
    discountAmount: json['discountAmount'] ?? 0,
    distance: json['distance'] ?? 0,
    oilType: json['oilType'] ?? '',
  );
}

List<String> _generateTagsFromFlags(Map<String, dynamic> json) {
  final tags = <String>[];
  if (json['hasSelfService'] == true) tags.add('셀프');
  if (json['hasCarWash'] == true) tags.add('세차');
  if (json['hasMaintenance'] == true) tags.add('정비');
  if (json['hasCvs'] == true) tags.add('편의점');
  return tags;
}
