// car_payment_provider.dart
import 'package:flutter/material.dart';
import 'package:marimo_client/models/payment/car_payment_entry.dart';

class CarPaymentProvider with ChangeNotifier {
  final List<CarPaymentEntry> _entries = [];

  List<CarPaymentEntry> get entries => List.unmodifiable(_entries);

  void addEntry(CarPaymentEntry entry) {
    _entries.add(entry);
    notifyListeners();
  }

  Map<String, int> get categoryTotals {
    final Map<String, int> totals = {'주유': 0, '정비': 0, '세차': 0};
    for (final entry in _entries) {
      if (totals.containsKey(entry.category)) {
        totals[entry.category] = totals[entry.category]! + entry.amount;
      }
    }
    return totals;
  }

  int get totalAmount => categoryTotals.values.fold(0, (a, b) => a + b);

  Map<String, String> get percentages {
    final total = totalAmount;
    return categoryTotals.map((category, amount) {
      final percent = total == 0 ? 0 : (amount / total * 100);
      return MapEntry(category, '${percent.toStringAsFixed(1)}%');
    });
  }

  // ✅ 선택된 월 상태
  int _selectedMonth = DateTime.now().month;

  int get selectedMonth => _selectedMonth;

  void setSelectedMonth(int month) {
    _selectedMonth = month;
    notifyListeners();
  }

  // ✅ 선택된 월의 항목만 필터링
  List<CarPaymentEntry> get filteredEntries {
    return _entries
        .where((entry) => entry.date.month == _selectedMonth)
        .toList();
  }

  // ✅ 선택된 월의 카테고리별 총합
  Map<String, int> get categoryTotalsForSelectedMonth {
    final Map<String, int> totals = {'주유': 0, '정비': 0, '세차': 0};
    for (final entry in filteredEntries) {
      if (totals.containsKey(entry.category)) {
        totals[entry.category] = totals[entry.category]! + entry.amount;
      }
    }
    return totals;
  }

  // ✅ 선택된 월의 총합
  int get totalAmountForSelectedMonth =>
      categoryTotalsForSelectedMonth.values.fold(0, (a, b) => a + b);

  // ✅ 선택된 월의 비율
  Map<String, String> get percentagesForSelectedMonth {
    final total = totalAmountForSelectedMonth;
    return categoryTotalsForSelectedMonth.map((category, amount) {
      final percent = total == 0 ? 0 : (amount / total * 100);
      return MapEntry(category, '${percent.toStringAsFixed(1)}%');
    });
  }

  // 선택된 카테고리 상태
  String? _selectedCategory = '주유'; // ← 기본값 설정
  String? get selectedCategory => _selectedCategory;

  void setSelectedCategory(String? category) {
    _selectedCategory = category;
    // print('[Provider] setSelectedCategory: $_selectedCategory');
    notifyListeners();
  }

  // ✅ 선택된 날짜 상태 (추가)
  DateTime _selectedDate = DateTime.now();

  DateTime get selectedDate => _selectedDate;

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  // ✅ 선택된 금액 상태
  int _selectedAmount = 0;
  int get selectedAmount => _selectedAmount;

  void setSelectedAmount(int amount) {
    _selectedAmount = amount;
    notifyListeners();
  }

  bool _isFromPlusButton = false;

  bool get isFromPlusButton => _isFromPlusButton;

  void markAsFromPlusButton(bool value) {
    _isFromPlusButton = value;
  }

  // ✅ 선택된 정비 부품 목록
  List<String> _selectedRepairItems = [];

  List<String> get selectedRepairItems => _selectedRepairItems;

  void setSelectedRepairItems(List<String> items) {
    _selectedRepairItems = items;
    notifyListeners();
  }

  void toggleRepairItem(String item) {
    if (_selectedRepairItems.contains(item)) {
      _selectedRepairItems.remove(item);
    } else {
      _selectedRepairItems.add(item);
    }
    notifyListeners();
  }
}
