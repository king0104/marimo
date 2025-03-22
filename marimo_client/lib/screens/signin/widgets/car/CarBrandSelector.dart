import 'package:flutter/material.dart';

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
  String? selectedManufacturer; // 선택된 제조사

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
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
                  color: isSelected ? Colors.white : Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? Colors.blue : Colors.transparent,
                    width: 2,
                  ),
                  boxShadow: [
                    if (!isSelected)
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                  ],
                ),
                child: Center(
                  child:
                      manufacturer["logo"] != null
                          ? Image.asset(
                            manufacturer["logo"]!,
                            width: 50,
                            height: 50,
                            color: isSelected ? null : Colors.grey[400],
                          )
                          : const Icon(Icons.add, color: Colors.grey, size: 30),
                ),
              ),
            );
          }).toList(),
    );
  }
}
