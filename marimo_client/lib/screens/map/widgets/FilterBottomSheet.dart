import 'package:flutter/material.dart';
import 'package:marimo_client/providers/map/filter_provider.dart';
import 'package:provider/provider.dart';

class FilterBottomSheet extends StatefulWidget {
  final void Function(int radius)? onApply; // ✅ 반경도 함께 전달할 수 있도록 수정
  const FilterBottomSheet({super.key, this.onApply});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late Map<String, Set<String>> selectedFiltersByCategory;
  int _radius = 3; // ✅ 기본값 3km

  final Map<String, List<String>> filterOptions = {
    '운영 정보': ['셀프 주유'],
    '부가 서비스': ['세차장', '경정비', '편의점'],
    '브랜드': ['SK', 'GS', 'S-OIL', '현대오일'],
    '기름 종류': ['일반 휘발유', '고급 휘발유', '경유', 'LPG', '등유'],
  };

  @override
  void initState() {
    super.initState();
    final filterProvider = context.read<FilterProvider>();
    selectedFiltersByCategory = {
      for (final entry in filterOptions.entries)
        entry.key: filterProvider.filtersByCategory[entry.key] ?? <String>{},
    };
    _radius = filterProvider.radiusKm; // ✅ Provider에서 반경 값으로 초기화
  }

  void _toggleOption(String category, String option) {
    final filterProvider = context.read<FilterProvider>();

    setState(() {
      final selectedSet = selectedFiltersByCategory[category] ?? <String>{};

      if (category == '기름 종류') {
        // ✅ 단일 선택만 허용
        selectedSet.clear(); // 기존 선택 제거
        selectedSet.add(option);
        filterProvider.setSingleFilter(category, option); // 단일 필터 메서드 호출 필요
      } else {
        // ✅ 일반 다중 선택 필터
        if (selectedSet.contains(option)) {
          selectedSet.remove(option);
          filterProvider.removeFilter(category, option);
        } else {
          selectedSet.add(option);
          filterProvider.addFilter(category, option);
        }
      }

      selectedFiltersByCategory[category] = selectedSet;
    });
  }

  void _resetFilters() {
    final filterProvider = context.read<FilterProvider>();
    setState(() {
      for (final key in selectedFiltersByCategory.keys) {
        selectedFiltersByCategory[key] = <String>{};
      }
      _radius = 3; // ✅ 초기화 시 반경도 3km로 되돌림
      filterProvider.clearFilters();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 560,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            // 상단 필터 콘텐츠
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    const Text(
                      '필터 옵션',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ✅ 반경 선택 슬라이더 추가
                    const Text(
                      '검색 반경',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Slider(
                      value: _radius.toDouble(),
                      onChanged: (value) {
                        setState(() {
                          _radius = value.round();
                        });
                      },
                      min: 1,
                      max: 5,
                      divisions: 2,
                      label: '${_radius}km',
                    ),

                    const SizedBox(height: 16),

                    ...filterOptions.entries.map(
                      (entry) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entry.key,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Wrap(
                                spacing: 6,
                                runSpacing: 6,
                                children:
                                    entry.value.map((option) {
                                      final isSelected =
                                          selectedFiltersByCategory[entry.key]
                                              ?.contains(option) ??
                                          false;
                                      return GestureDetector(
                                        onTap:
                                            () => _toggleOption(
                                              entry.key,
                                              option,
                                            ),
                                        child: AnimatedContainer(
                                          duration: const Duration(
                                            milliseconds: 200,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color:
                                                isSelected
                                                    ? Colors.black
                                                    : Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              30,
                                            ),
                                            border: Border.all(
                                              color:
                                                  isSelected
                                                      ? Colors.black
                                                      : Colors.grey.shade400,
                                            ),
                                          ),
                                          child: Text(
                                            option,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color:
                                                  isSelected
                                                      ? Colors.white
                                                      : Colors.black,
                                              fontWeight:
                                                  isSelected
                                                      ? FontWeight.w600
                                                      : FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // 하단 버튼 영역
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _resetFilters,
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        side: BorderSide(color: Colors.grey.shade400),
                        foregroundColor: Colors.black,
                      ),
                      child: const Text('초기화', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        final filterProvider = context.read<FilterProvider>();

                        // 기존 필터 초기화
                        filterProvider.clearFilters();

                        // 새 필터 반영
                        selectedFiltersByCategory.forEach((category, options) {
                          for (final option in options) {
                            filterProvider.addFilter(category, option);
                          }
                        });

                        filterProvider.setRadius(_radius); // ✅ Provider에 반영
                        Navigator.pop(context);
                        widget.onApply?.call(_radius); // ✅ radius 전달
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        backgroundColor: const Color(0xFF3B82F6),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('적용', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
