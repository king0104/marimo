import 'package:flutter/foundation.dart';
import 'package:marimo_client/models/map/gas_station_place.dart';

class StationCardsProvider with ChangeNotifier {
  List<Place> _places = [];

  List<Place> get places => _places;

  void updatePlaces(List<Place> newPlaces) {
    _places = newPlaces;
    notifyListeners();
  }
}
