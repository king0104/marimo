import 'package:flutter/material.dart';
import 'package:marimo_client/theme.dart'; // ✅ brandColor 등 불러오기

class BrandSelector extends StatefulWidget {
  final List<Map<String, String?>> brands;
  final Function(String) onSelected;

  // ✅ 외부에서 현재 선택된 브랜드 전달
  final String? selectedBrand;

  const BrandSelector({
    super.key,
    required this.brands,
    required this.onSelected,
    this.selectedBrand, // ✅ 선택 브랜드 상태 주입
  });

  @override
  State<BrandSelector> createState() => _BrandSelectorState();
}

class _BrandSelectorState extends State<BrandSelector> {
  late String? selectedManufacturer;

  @override
  void initState() {
    super.initState();
    selectedManufacturer = widget.selectedBrand;
  }

  @override
  void didUpdateWidget(covariant BrandSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedBrand != widget.selectedBrand) {
      setState(() {
        selectedManufacturer = widget.selectedBrand;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 20,
      runSpacing: 20,
      children:
          widget.brands.map((manufacturer) {
            final name = manufacturer["name"];
            final isSelected = selectedManufacturer == name;

            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedManufacturer = name;
                });
                widget.onSelected(name!); // ✅ 부모에게 선택 전달
              },
              child: Container(
                width: 65,
                height: 65,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? Colors.transparent : iconColor,
                    width: 0.5,
                  ),
                  boxShadow:
                      isSelected
                          ? [
                            BoxShadow(
                              color: brandColor,
                              spreadRadius: 1.5,
                              blurRadius: 0,
                            ),
                          ]
                          : [],
                ),
                child: Center(
                  child:
                      manufacturer["logo"] != null
                          ? Image.asset(
                            manufacturer["logo"]!,
                            width: 65,
                            height: 65,
                            fit: BoxFit.contain,
                          )
                          : const Icon(Icons.add, color: iconColor, size: 30),
                ),
              ),
            );
          }).toList(),
    );
  }
}
