// CarPaymentCategorySelector.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:marimo_client/commons/icons/OilIcon.dart';
import 'package:marimo_client/commons/icons/RepairIcon.dart';
import 'package:marimo_client/commons/icons/WashIcon.dart';
import 'package:marimo_client/providers/car_payment_provider.dart';
import 'package:marimo_client/commons/CustomDropdownList.dart'; // 분리된 드롭다운 리스트 import
import 'package:marimo_client/theme.dart';

class CarPaymentCategorySelector extends StatefulWidget {
  const CarPaymentCategorySelector({super.key});

  @override
  State<CarPaymentCategorySelector> createState() =>
      _CarPaymentCategorySelectorState();
}

class _CarPaymentCategorySelectorState
    extends State<CarPaymentCategorySelector> {
  final LayerLink _layerLink = LayerLink();

  final List<String> categories = ['주유', '정비', '세차'];

  Widget _getIcon(String category) {
    switch (category) {
      case '주유':
        return const OilIcon(size: 44);
      case '정비':
        return const RepairIcon(size: 44);
      case '세차':
        return const WashIcon(size: 44);
      default:
        return const SizedBox();
    }
  }

  void _toggleDropdown(BuildContext context) {
    final provider = context.read<CarPaymentProvider>();
    final selected = provider.selectedCategory;

    showDropdownList(
      context: context,
      items: categories,
      selectedItem: selected,
      onItemSelected: (item) {
        provider.setSelectedCategory(item);
      },
      layerLink: _layerLink,
      width: 73,
      height: 152,
    );
  }

  @override
  Widget build(BuildContext context) {
    final selected = context.watch<CarPaymentProvider>().selectedCategory;

    return Row(
      children: [
        _getIcon(selected ?? '주유'),
        SizedBox(width: 12.w),
        CompositedTransformTarget(
          link: _layerLink,
          child: GestureDetector(
            onTap: () => _toggleDropdown(context),
            child: Row(
              children: [
                Text(
                  selected ?? '선택',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 10.w),
                SvgPicture.asset(
                  'assets/images/icons/icon_down.svg',
                  width: 3.w,
                  height: 4.h,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
