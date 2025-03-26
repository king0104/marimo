// CarDayPaymentItem.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CarDayPaymentItem extends StatelessWidget {
  final String category;
  final int amount;
  final String? subText;

  const CarDayPaymentItem({
    super.key,
    required this.category,
    required this.amount,
    this.subText,
  });

  String getIconPath(String category) {
    switch (category) {
      case '주유':
        return 'assets/images/icons/icon_oil_white.svg';
      case '정비':
        return 'assets/images/icons/icon_repair_white.svg';
      case '세차':
        return 'assets/images/icons/icon_wash_white.svg';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44.w,
          height: 44.h,
          decoration: const BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: SvgPicture.asset(
              getIconPath(category),
              width: 20.w,
              height: 20.w,
            ),
          ),
        ),
        SizedBox(width: 18.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                category + (subText != null ? '  $subText' : ''),
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        Text(
          '${amount.toString()} 원',
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
        ),
        Icon(Icons.chevron_right, size: 20.w, color: Colors.grey),
      ],
    );
  }
}
