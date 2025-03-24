import 'package:flutter/material.dart';
import '../models/car_model.dart';

class CarProvider with ChangeNotifier {
  CarModel? _car;

  CarModel? get car => _car;

  void setCar(CarModel car) {
    _car = car;
    notifyListeners();
  }

  void clearCar() {
    _car = null;
    notifyListeners();
  }

  bool get hasCar => _car != null;
}
