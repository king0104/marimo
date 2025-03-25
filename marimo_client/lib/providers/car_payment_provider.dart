// CarPaymentProvider.dart
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
}
