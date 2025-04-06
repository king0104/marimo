import 'package:flutter/material.dart';

class NavigationProvider extends ChangeNotifier {
  int _selectedIndex = 0;
  bool _shouldApplyRepairFilter = false;

  int get selectedIndex => _selectedIndex;
  bool get shouldApplyRepairFilter => _shouldApplyRepairFilter;

  void setIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  void triggerRepairFilter() {
    _shouldApplyRepairFilter = true;
    notifyListeners();
  }

  void consumeRepairFilter() {
    _shouldApplyRepairFilter = false;
  }
}
