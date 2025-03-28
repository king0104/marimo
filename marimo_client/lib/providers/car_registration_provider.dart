import 'package:flutter/material.dart';

class CarRegistrationProvider with ChangeNotifier {
  String? nickname;
  String? brand;
  String? modelName;
  String? plateNumber;
  String? vehicleIdentificationNumber;
  String? fuelType;
  DateTime? lastCheckedDate;

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
    plateNumber = value;
    notifyListeners();
  }

  void setVin(String value) {
    vehicleIdentificationNumber = value;
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
      "fuelType": fuelType,
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
