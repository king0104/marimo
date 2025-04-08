class GasStationFilterParams {
  final bool? hasSelfService;
  final bool? hasMaintenance;
  final bool? hasCarWash;
  final bool? hasCvs;
  final List<String>? brandList;
  final String? oilType;

  final int radius; // ✅ 추가

  const GasStationFilterParams({
    this.hasSelfService,
    this.hasMaintenance,
    this.hasCarWash,
    this.hasCvs,
    this.brandList,
    this.oilType,
    this.radius = 3, // ✅ 기본값: 3km
  });
}

/// ✅ 브랜드명 → 코드 매핑 (오피넷 기준)
const Map<String, String> brandNameToCode = {
  'SK': 'SKE',
  'GS': 'GSC',
  'S-OIL': 'SOL',
  '현대오일': 'HDO',
};

/// ✅ 필터 옵션들을 DTO로 매핑하는 함수
GasStationFilterParams parseFilterOptions(
  Map<String, Set<String>> selectedOptions, {
  int radius = 3,
}) {
  // ✅ Boolean 필드 처리
  bool? flag(String category, String label) =>
      selectedOptions[category]?.contains(label) == true ? true : null;

  // ✅ 리스트 필드 (예: 브랜드)
  List<String>? pickList(String category) {
    final list = selectedOptions[category]?.toList();
    return (list != null && list.isNotEmpty) ? list : null;
  }

  // ✅ 오피넷 코드 변환된 브랜드 리스트
  List<String>? pickMappedBrandList(String category) {
    final rawList = selectedOptions[category]?.toList();
    if (rawList == null || rawList.isEmpty) return null;

    final mapped = rawList.map((e) => brandNameToCode[e] ?? e).toList();
    return mapped.isNotEmpty ? mapped : null;
  }

  // ✅ 기름 종류는 단일 선택만 허용
  String? pickSingle(String category) {
    final set = selectedOptions[category];
    return (set != null && set.isNotEmpty) ? set.first : null;
  }

  return GasStationFilterParams(
    hasSelfService: flag('운영 정보', '셀프 주유'),
    hasMaintenance: flag('부가 서비스', '경정비'),
    hasCarWash: flag('부가 서비스', '세차장'),
    hasCvs: flag('부가 서비스', '편의점'),
    brandList: pickMappedBrandList('브랜드'),
    oilType: pickSingle('기름 종류'),
    radius: radius, // ✅ 반영
  );
}
