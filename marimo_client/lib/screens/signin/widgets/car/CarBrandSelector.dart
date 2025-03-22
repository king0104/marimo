import 'package:flutter/material.dart';
import 'package:marimo_client/theme.dart'; // ✅ brandColor 등 불러오기

class CarBrandSelector extends StatefulWidget {
  final List<Map<String, String?>> manufacturers;
  final Function(String) onSelected;

  const CarBrandSelector({
    super.key,
    required this.manufacturers,
    required this.onSelected,
  });

  @override
  State<CarBrandSelector> createState() => _CarBrandSelectorState();
}

class _CarBrandSelectorState extends State<CarBrandSelector> {
  String? selectedManufacturer;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 20,
      runSpacing: 20,
      children:
          widget.manufacturers.map((manufacturer) {
            bool isSelected = selectedManufacturer == manufacturer["name"];

            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedManufacturer = manufacturer["name"];
                });
                widget.onSelected(selectedManufacturer!);
              },
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? brandColor : iconColor,
                    width: isSelected ? 2 : 0.5,
                  ),
                ),
                child: Center(
                  child:
                      manufacturer["logo"] != null
                          ? Image.asset(
                            manufacturer["logo"]!,
                            width: 60,
                            height: 60,
                            color: isSelected ? null : iconColor,
                          )
                          : const Icon(Icons.add, color: iconColor, size: 30),
                ),
              ),
            );
          }).toList(),
    );
  }
}
