class GasStationFilterParams {
  final bool? hasSelfService;
  final bool? hasMaintenance;
  final bool? hasCarWash;
  final bool? hasCvs;
  final List<String>? brandList;
  final List<String>? oilTypeList;

  const GasStationFilterParams({
    this.hasSelfService,
    this.hasMaintenance,
    this.hasCarWash,
    this.hasCvs,
    this.brandList,
    this.oilTypeList,
  });
}

/// ✅ 브랜드명 → 코드 매핑 (오피넷 기준)
const Map<String, String> brandNameToCode = {
  'SK': 'SKE',
  'GS': 'GSC',
  'S-OIL': 'SOL',
  '현대오일': 'HDO',
};

GasStationFilterParams parseFilterOptions(
  Map<String, Set<String>> selectedOptions,
) {
  bool? flag(String category, String label) =>
      selectedOptions[category]?.contains(label) == true ? true : null;

  List<String>? pickList(String category) {
    final list = selectedOptions[category]?.toList();
    return (list != null && list.isNotEmpty) ? list : null;
  }

  /// ✅ 브랜드 리스트 매핑 처리
  List<String>? pickMappedBrandList(String category) {
    final rawList = selectedOptions[category]?.toList();
    if (rawList == null || rawList.isEmpty) return null;

    final mapped = rawList.map((e) => brandNameToCode[e] ?? e).toList();
    return mapped.isNotEmpty ? mapped : null;
  }

  return GasStationFilterParams(
    hasSelfService: flag('운영 정보', '셀프 주유'),
    hasMaintenance: flag('부가 서비스', '경정비'),
    hasCarWash: flag('부가 서비스', '세차장'),
    hasCvs: flag('부가 서비스', '편의점'),
    brandList: pickMappedBrandList('브랜드'), // ✅ 이 부분 수정됨
    oilTypeList: pickList('기름 종류'),
  );
}
