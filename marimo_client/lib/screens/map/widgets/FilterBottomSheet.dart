import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:marimo_client/providers/map/filter_provider.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late Map<String, Set<String>> selectedFiltersByCategory;

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
  }

  void _toggleOption(String category, String option) {
    final filterProvider = context.read<FilterProvider>();

    setState(() {
      final selectedSet = selectedFiltersByCategory[category] ?? <String>{};

      if (selectedSet.contains(option)) {
        selectedSet.remove(option);
        filterProvider.removeFilter(category, option);
      } else {
        selectedSet.add(option);
        filterProvider.addFilter(category, option);
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
      filterProvider.clearFilters();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 510,
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

                        Navigator.pop(context);
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
