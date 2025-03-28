class CarModel {
  final String id;
  final String memberId;
  final String brandId;
  final String nickname;
  final String modelName;
  final String plateNumber;
  final String vehicleIdentificationNumber;
  final String fuelType;
  final DateTime? lastCheckedDate;
  final DateTime? tireCheckedDate;
  final int totalDistance;
  final double fuelEfficiency;
  final double fuelLevel;
  final DateTime? lastUpdateDate;
  final String obd2Status;
  final int score;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool deleted;
  final DateTime? deletedAt;

  CarModel({
    required this.id,
    required this.memberId,
    required this.brandId,
    required this.nickname,
    required this.modelName,
    required this.plateNumber,
    required this.vehicleIdentificationNumber,
    required this.fuelType,
    this.lastCheckedDate,
    this.tireCheckedDate,
    required this.totalDistance,
    required this.fuelEfficiency,
    required this.fuelLevel,
    this.lastUpdateDate,
    required this.obd2Status,
    required this.score,
    this.createdAt,
    this.updatedAt,
    required this.deleted,
    this.deletedAt,
  });
}
