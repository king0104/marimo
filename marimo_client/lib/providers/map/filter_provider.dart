import 'package:flutter/foundation.dart';

class FilterProvider with ChangeNotifier {
  Set<String> _filters = {};

  Set<String> get filters => _filters;

  void addFilter(String filter) {
    _filters.add(filter);
    notifyListeners();
  }

  void removeFilter(String filter) {
    _filters.remove(filter);
    notifyListeners();
  }

  void clearFilters() {
    _filters.clear();
    notifyListeners();
  }
}
