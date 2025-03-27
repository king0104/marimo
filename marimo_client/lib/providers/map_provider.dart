import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class MapStateProvider with ChangeNotifier {
  NLatLng? _lastKnownPosition;

  NLatLng? get lastKnownPosition => _lastKnownPosition;

  void updatePosition(NLatLng position) {
    _lastKnownPosition = position;
    notifyListeners();
  }
}
