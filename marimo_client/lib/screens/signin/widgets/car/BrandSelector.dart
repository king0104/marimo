import 'package:flutter/material.dart';
import 'package:marimo_client/theme.dart'; // ✅ brandColor 등 불러오기

class BrandSelector extends StatefulWidget {
  final List<Map<String, String?>> brands;
  final Function(String) onSelected;

  const BrandSelector({
    super.key,
    required this.brands,
    required this.onSelected,
  });

  @override
  State<BrandSelector> createState() => _BrandSelectorState();
}

class _BrandSelectorState extends State<BrandSelector> {
  String? selectedManufacturer;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 20,
      runSpacing: 20,
      children:
          widget.brands.map((manufacturer) {
            bool isSelected = selectedManufacturer == manufacturer["name"];

            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedManufacturer = manufacturer["name"];
                });
                widget.onSelected(selectedManufacturer!);
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
                              color: brandColor, // ✅ 강조 색상
                              spreadRadius: 1.5, // ✅ 테두리 두께 느낌
                              blurRadius: 0, // ✅ 흐림 없이 딱 떨어지게
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
