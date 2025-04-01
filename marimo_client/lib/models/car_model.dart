class CarModel {
  final String id;
  final String? memberId;
  final String? brandId;
  final String? nickname;
  final String? modelName;
  final String? plateNumber;
  final String? vehicleIdentificationNumber;
  final String? fuelType;
  final DateTime? lastCheckedDate;
  final DateTime? tireCheckedDate;
  final int? totalDistance;
  final double? fuelEfficiency;
  final double? fuelLevel;
  final DateTime? lastUpdateDate;
  final String? obd2Status;
  final int? score;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool? deleted;
  final DateTime? deletedAt;

  CarModel({
    required this.id,
    this.memberId,
    this.brandId,
    this.nickname,
    this.modelName,
    this.plateNumber,
    this.vehicleIdentificationNumber,
    this.fuelType,
    this.lastCheckedDate,
    this.tireCheckedDate,
    this.totalDistance,
    this.fuelEfficiency,
    this.fuelLevel,
    this.lastUpdateDate,
    this.obd2Status,
    this.score,
    this.createdAt,
    this.updatedAt,
    this.deleted,
    this.deletedAt,
  });

  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      id: json['id'],
      memberId: json['memberId'],
      brandId: json['brandId'],
      nickname: json['nickname'],
      modelName: json['modelName'],
      plateNumber: json['plateNumber'],
      vehicleIdentificationNumber: json['vehicleIdentificationNumber'],
      fuelType: json['fuelType'],
      lastCheckedDate:
          json['lastCheckedDate'] != null
              ? DateTime.tryParse(json['lastCheckedDate'])
              : null,
      tireCheckedDate:
          json['tireCheckedDate'] != null
              ? DateTime.tryParse(json['tireCheckedDate'])
              : null,
      totalDistance: json['totalDistance'],
      fuelEfficiency: (json['fuelEfficiency'] as num?)?.toDouble(),
      fuelLevel: (json['fuelLevel'] as num?)?.toDouble(),
      lastUpdateDate:
          json['lastUpdateDate'] != null
              ? DateTime.tryParse(json['lastUpdateDate'])
              : null,
      obd2Status: json['obd2Status'],
      score: json['score'],
      createdAt:
          json['createdAt'] != null
              ? DateTime.tryParse(json['createdAt'])
              : null,
      updatedAt:
          json['updatedAt'] != null
              ? DateTime.tryParse(json['updatedAt'])
              : null,
      deleted: json['deleted'],
      deletedAt:
          json['deletedAt'] != null
              ? DateTime.tryParse(json['deletedAt'])
              : null,
    );
  }
}
