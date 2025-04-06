import 'package:flutter/foundation.dart';

class CategoryProvider with ChangeNotifier {
  String _selectedCategory = 'none';

  String get selectedCategory => _selectedCategory;

  void selectCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }
}
