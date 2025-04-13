import 'package:flutter/material.dart';
import 'package:marimo_client/theme.dart';

class BrandSelector extends StatefulWidget {
  final List<Map<String, dynamic>> brands; // ✅ 변경됨
  final Function(String) onSelected;
  final String? selectedBrand;

  const BrandSelector({
    super.key,
    required this.brands,
    required this.onSelected,
    this.selectedBrand,
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
            final name = manufacturer["name"] as String;
            final logo = manufacturer["logo"] as String?;
            final isEnabled = manufacturer["enabled"] != false;
            final isSelected = selectedManufacturer == name;

            return GestureDetector(
              onTap:
                  isEnabled
                      ? () {
                        setState(() {
                          selectedManufacturer = name;
                        });
                        widget.onSelected(name);
                      }
                      : null,
              child: Opacity(
                opacity: isEnabled ? 1.0 : 0.4, // ✅ 시각적으로 비활성 표시
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
                        logo != null
                            ? ColorFiltered(
                              colorFilter:
                                  isEnabled
                                      ? const ColorFilter.mode(
                                        Colors.transparent,
                                        BlendMode.multiply,
                                      )
                                      : const ColorFilter.matrix(<double>[
                                        0.2126,
                                        0.7152,
                                        0.0722,
                                        0,
                                        0,
                                        0.2126,
                                        0.7152,
                                        0.0722,
                                        0,
                                        0,
                                        0.2126,
                                        0.7152,
                                        0.0722,
                                        0,
                                        0,
                                        0,
                                        0,
                                        0,
                                        1,
                                        0,
                                      ]),
                              child: Image.asset(
                                logo,
                                width: 65,
                                height: 65,
                                fit: BoxFit.contain,
                              ),
                            )
                            : const Icon(Icons.add, color: iconColor, size: 30),
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }
}
