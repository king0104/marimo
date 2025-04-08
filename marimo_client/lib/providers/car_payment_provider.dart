// car_payment_provider.dart
import 'package:flutter/material.dart';
import 'package:marimo_client/models/payment/car_payment_entry.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:marimo_client/services/payment/car_payment_service.dart';

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
      if (totals.containsKey(entry.categoryKr)) {
        totals[entry.categoryKr] = totals[entry.categoryKr]! + entry.amount;
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

  // ✅ 선택된 연도 상태
  int _selectedYear = DateTime.now().year;

  int get selectedYear => _selectedYear;

  void setSelectedYear(int year) {
    _selectedYear = year;
    notifyListeners();
  }

  // ✅ 선택된 월 상태
  int _selectedMonth = DateTime.now().month;

  int get selectedMonth => _selectedMonth;

  void setSelectedMonth(int month) {
    // print('Provider - 월 변경: 이전 값 $selectedMonth, 새 값 $month');
    _selectedMonth = month;
    notifyListeners();
    // print('Provider - 월 변경 완료: 현재 값 $selectedMonth');
  }

  // ✅ 선택된 연도와 월의 항목만 필터링
  List<CarPaymentEntry> get filteredEntries {
    return _entries
        .where(
          (entry) =>
              entry.date.year == _selectedYear &&
              entry.date.month == _selectedMonth,
        )
        .toList();
  }

  // ✅ 선택된 연도와 월의 카테고리별 총합
  Map<String, int> get categoryTotalsForSelectedMonth {
    final Map<String, int> totals = {'주유': 0, '정비': 0, '세차': 0};
    for (final entry in filteredEntries) {
      if (totals.containsKey(entry.categoryKr)) {
        totals[entry.categoryKr] = totals[entry.categoryKr]! + entry.amount;
      }
    }
    return totals;
  }

  // ✅ 선택된 연도와 월의 총합
  int get totalAmountForSelectedMonth =>
      categoryTotalsForSelectedMonth.values.fold(0, (a, b) => a + b);

  // ✅ 선택된 연도와 월의 비율
  Map<String, String> get percentagesForSelectedMonth {
    final total = totalAmountForSelectedMonth;
    return categoryTotalsForSelectedMonth.map((category, amount) {
      final percent = total == 0 ? 0 : (amount / total * 100);
      return MapEntry(category, '${percent.toStringAsFixed(1)}%');
    });
  }

  // ✅ 이전 달 대비 증감액 계산
  int get previousMonthDifference {
    // 이전 달 계산
    int prevMonth = _selectedMonth - 1;
    int prevYear = _selectedYear;

    // 1월인 경우 이전 달은 작년 12월
    if (prevMonth == 0) {
      prevMonth = 12;
      prevYear--;
    }

    // 이전 달 데이터 필터링
    final prevMonthEntries =
        _entries
            .where(
              (entry) =>
                  entry.date.year == prevYear && entry.date.month == prevMonth,
            )
            .toList();

    // 이전 달 총액 계산
    final prevMonthTotal = prevMonthEntries.fold(
      0,
      (total, entry) => total + entry.amount,
    );

    // 현재 달 총액과의 차이 반환
    return totalAmountForSelectedMonth - prevMonthTotal;
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

  String _location = '';
  String get location => _location;
  void setLocation(String value) {
    _location = value;
    notifyListeners();
  }

  String _memo = '';
  String get memo => _memo;
  void setMemo(String value) {
    _memo = value;
    notifyListeners();
  }

  String _fuelType = '';
  String get fuelType => _fuelType;
  void setFuelType(String value) {
    _fuelType = value;
    notifyListeners();
  }

  final Map<String, String> fuelDisplayToEnum = {
    '일반 휘발유': 'NORMAL_GASOLINE',
    '고급 휘발유': 'PREMIUM_GASOLINE',
    '경유': 'DIESEL',
    'LPG': 'LPG',
  };

  Map<String, dynamic> toJsonForDB({
    required String carId,
    String? category,
    String? location,
    String? memo,
    String? fuelType,
    List<String>? repairParts,
  }) {
    final baseJson = {
      "carId": carId,
      "price": selectedAmount,
      "paymentDate": selectedDate.toIso8601String(),
      if (location != null && location.isNotEmpty) "location": location,
      if (memo != null && memo.isNotEmpty) "memo": memo,
    };

    print("🔍 toJsonForDB > baseJson: $baseJson");

    switch (category) {
      case '주유':
        return {
          ...baseJson,
          if (fuelType != null && fuelType.isNotEmpty)
            "fuelType": fuelDisplayToEnum[fuelType] ?? fuelType,
        };
      case '정비':
        return {
          ...baseJson,
          if (repairParts != null && repairParts.isNotEmpty)
            "repairParts": repairParts, // ✅ 복수형 유지
        };
      default:
        return baseJson;
    }
  }

  void resetInput() {
    _selectedAmount = 0;
    _selectedDate = DateTime.now();
    _selectedRepairItems = [];
    notifyListeners();
  }

  // ✅ 진단 일자 상태 추가
  DateTime? _tireDiagnosisDate;
  DateTime? get tireDiagnosisDate => _tireDiagnosisDate;

  void setTireDiagnosisDate(DateTime date) async {
    _tireDiagnosisDate = date;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('tireDiagnosisDate', date.toIso8601String()); // ✅ 저장
  }

  Future<void> loadTireDiagnosisDate() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('tireDiagnosisDate');
    if (saved != null) {
      _tireDiagnosisDate = DateTime.tryParse(saved);
      notifyListeners();
    }
  }

  // ✅ paymentId 추가
  String? _lastPaymentId;
  String? get lastPaymentId => _lastPaymentId;

  Future<void> setLastPaymentId(String id) async {
    _lastPaymentId = id;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastPaymentId', id); // ✅ 로컬에 저장
  }

  Future<void> loadLastPaymentId() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('lastPaymentId');
    if (saved != null) {
      _lastPaymentId = saved;
      notifyListeners();
    }
  }

  Future<void> clearLastPaymentId() async {
    _lastPaymentId = null;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('lastPaymentId');
  }

  // 전체 차계부 조회
  Future<void> fetchPaymentsForSelectedMonth({
    required String accessToken,
    required String carId,
  }) async {
    try {
      final payments = await CarPaymentService.fetchPaymentsByMonth(
        carId: carId,
        year: _selectedYear,
        month: _selectedMonth,
        accessToken: accessToken,
      );

      _entries.clear();
      _entries.addAll(payments);
      notifyListeners();

      print('📥 전체 차계부 조회 완료: ${payments.length}건');
    } catch (e) {
      print('❌ 전체 차계부 조회 실패: $e');
    }
  }

  bool _hasFetchedInitial = false;

  Future<void> fetchPaymentsOnceIfNeeded({
    required String accessToken,
    required String carId,
  }) async {
    if (_hasFetchedInitial) return;
    _hasFetchedInitial = true;

    await fetchPaymentsForSelectedMonth(accessToken: accessToken, carId: carId);
  }

  Future<void> updateMonthAndFetch({
    required int month,
    required int year,
    required String accessToken,
    required String carId,
  }) async {
    _selectedMonth = month;
    _selectedYear = year;
    notifyListeners();
    await fetchPaymentsForSelectedMonth(accessToken: accessToken, carId: carId);
  }
}
