import 'package:flutter/foundation.dart';

class FilterProvider with ChangeNotifier {
  final Map<String, Set<String>> _filtersByCategory = {};
  int _radiusKm = 3; // ✅ 추가: 검색 반경 (기본값 3km)

  /// 카테고리별 필터 상태 반환
  Map<String, Set<String>> get filtersByCategory => _filtersByCategory;

  /// 모든 필터를 Set 형태로 평탄화해서 반환 (기존 방식과 호환)
  Set<String> get filters =>
      _filtersByCategory.values.expand((set) => set).toSet();

  int get radiusKm => _radiusKm; // ✅ 반경 Getter

  void setRadius(int radius) {
    _radiusKm = radius; // ✅ 반경 Setter
    notifyListeners();
  }

  /// 특정 카테고리에 필터 추가
  void addFilter(String category, String value) {
    _filtersByCategory.putIfAbsent(category, () => <String>{});
    _filtersByCategory[category]!.add(value);
    notifyListeners();
  }

  /// 특정 카테고리에서 필터 제거
  void removeFilter(String category, String value) {
    if (_filtersByCategory.containsKey(category)) {
      _filtersByCategory[category]!.remove(value);
      if (_filtersByCategory[category]!.isEmpty) {
        _filtersByCategory.remove(category); // 빈 카테고리는 제거
      }
      notifyListeners();
    }
  }

  /// 전체 필터 초기화
  void clearFilters() {
    _filtersByCategory.clear();
    notifyListeners();
  }

  /// 기름 종류 단일 선택
  void setSingleFilter(String category, String value) {
    _filtersByCategory[category] = {value};
    notifyListeners();
  }
}
