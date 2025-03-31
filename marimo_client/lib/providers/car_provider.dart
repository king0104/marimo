import 'package:flutter/material.dart';
import '../models/car_model.dart';

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
}
