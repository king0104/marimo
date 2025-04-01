// car_provider.dart
import 'package:flutter/material.dart';

import '../models/car_model.dart';
import 'package:marimo_client/services/car_service.dart';

class CarProvider with ChangeNotifier {
  final List<CarModel> _cars = [];

  List<CarModel> get cars => _cars;

  void addCar(CarModel car) {
    _cars.add(car);
    notifyListeners();
  }

  void removeCarById(String id) {
    _cars.removeWhere((car) => car.id == id);
    notifyListeners();
  }

  bool get hasAnyCar => _cars.isNotEmpty;

  void clearCars() {
    _cars.clear();
    notifyListeners();
  }

  CarModel? getCarById(String id) {
    try {
      return _cars.firstWhere((car) => car.id == id);
    } catch (e) {
      return null;
    }
  }

  // ✅ [추가] 서버에서 차량 목록 불러오기
  Future<void> fetchCarsFromServer(String accessToken) async {
    try {
      final fetchedCars = await CarService.getCars(accessToken: accessToken);
      _cars.clear();
      _cars.addAll(fetchedCars);
      notifyListeners();
    } catch (e) {
      print('🚨 차량 목록 불러오기 실패: $e');
      rethrow;
    }
  }
}
