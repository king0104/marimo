// CarPaymentCategorySelector.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:marimo_client/commons/icons/OilIcon.dart';
import 'package:marimo_client/commons/icons/RepairIcon.dart';
import 'package:marimo_client/commons/icons/WashIcon.dart';
import 'package:marimo_client/providers/car_payment_provider.dart';
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
  OverlayEntry? _overlayEntry;

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

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _toggleDropdown(BuildContext context) {
    if (_overlayEntry != null) {
      _removeOverlay();
      return;
    }

    final provider = context.read<CarPaymentProvider>();
    final selected = provider.selectedCategory;

    _overlayEntry = OverlayEntry(
      builder:
          (context) => GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: _removeOverlay,
            child: Stack(
              children: [
                Positioned(
                  width: 73.w,
                  height: 152.h,
                  child: CompositedTransformFollower(
                    link: _layerLink,
                    showWhenUnlinked: false,
                    offset: Offset(0, 45.h),
                    child: Material(
                      color: Colors.transparent,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          child: Column(
                            children:
                                categories.map((cat) {
                                  final isSelected = selected == cat;
                                  return InkWell(
                                    onTap: () {
                                      provider.setSelectedCategory(cat);
                                      _removeOverlay();
                                    },
                                    child: Container(
                                      height: (152.h - 24.h) / 3,
                                      alignment: Alignment.center,
                                      child: Text(
                                        cat,
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w500,
                                          color:
                                              isSelected
                                                  ? brandColor
                                                  : Colors.black,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );

    Overlay.of(context).insert(_overlayEntry!);
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
