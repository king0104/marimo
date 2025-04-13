import 'package:flutter/material.dart';

class CarRegistrationProvider with ChangeNotifier {
  String? nickname;
  String? brand;
  String? modelName;
  String? plateNumber;
  String? vehicleIdentificationNumber;
  String? fuelType;
  DateTime? lastCheckedDate;

  bool isPlateNumberValid = false;
  bool isVinValid = false;

  final fuelDisplayToEnum = {
    '휘발유': 'NORMAL_GASOLINE',
    '고급휘발유': 'PREMIUM_GASOLINE',
    '경유': 'DIESEL',
    'LPG': 'LPG',
  };

  void setNickname(String value) {
    nickname = value;
    notifyListeners();
  }

  void setBrand(String value) {
    brand = value;
    notifyListeners();
  }

  void setModelName(String value) {
    modelName = value;
    notifyListeners();
  }

  void setPlateNumber(String value) {
    plateNumber = value.trim();

    // 차량 번호 유효성 검사
    final regex = RegExp(r'^\d{2,3}[가-힣]\d{4}$');
    isPlateNumberValid = regex.hasMatch(plateNumber ?? '');

    notifyListeners();
  }

  void setVin(String value) {
    vehicleIdentificationNumber = value.trim();

    final vinRegex = RegExp(r'^[A-HJ-NPR-Z0-9]{17}$');
    isVinValid = vinRegex.hasMatch(vehicleIdentificationNumber ?? '');

    notifyListeners();
  }

  void setFuelType(String value) {
    fuelType = value;
    notifyListeners();
  }

  void setLastCheckedDate(DateTime date) {
    lastCheckedDate = date;
    notifyListeners();
  }

  Map<String, dynamic> toJson() {
    return {
      "nickname": nickname,
      "brand": brand,
      "modelName": modelName,
      "plateNumber": plateNumber,
      "vehicleIdentificationNumber": vehicleIdentificationNumber,
      "lastCheckedDate": lastCheckedDate?.toIso8601String(),
      "fuelType": fuelDisplayToEnum[fuelType],
    };
  }

  void clear() {
    nickname = null;
    brand = null;
    modelName = null;
    plateNumber = null;
    vehicleIdentificationNumber = null;
    fuelType = null;
    notifyListeners();
  }
}
