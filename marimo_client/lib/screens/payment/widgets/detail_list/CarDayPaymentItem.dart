// CarDayPaymentItem.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marimo_client/commons/icons/OilIcon.dart';
import 'package:marimo_client/commons/icons/RepairIcon.dart';
import 'package:marimo_client/commons/icons/WashIcon.dart';

class CarDayPaymentItem extends StatelessWidget {
  final String category;
  final int amount;
  final String? subText;
  final String paymentId;
  final VoidCallback onTap;

  const CarDayPaymentItem({
    super.key,
    required this.category,
    required this.amount,
    this.subText,
    required this.paymentId,
    required this.onTap,
  });

  Widget _getCategoryIcon(String category) {
    switch (category) {
      case '주유':
        return const OilIcon(size: 36);
      case '정비':
        return const RepairIcon(size: 36);
      case '세차':
        return const WashIcon(size: 36);
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedAmount = NumberFormat(
      '###,###,###,###,###,###',
    ).format(amount);

    return Row(
      children: [
        _getCategoryIcon(category),
        SizedBox(width: 8.w),
        Expanded(
          child: Row(
            children: [
              Text(
                category,
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
              ),
              if (subText != null) ...[
                SizedBox(width: 4.w),
                Text(
                  subText!,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ],
          ),
        ),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: '$formattedAmount',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
              ),
              WidgetSpan(child: SizedBox(width: 4.w)),
              TextSpan(
                text: '원',
                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w300),
              ),
            ],
          ),
        ),
        SizedBox(width: 9.w), // ✅ "원"과 아이콘 사이 여백
        GestureDetector(
          onTap: onTap,
          child: SvgPicture.asset(
            'assets/images/icons/icon_detail.svg',
            width: 6.w,
            height: 10.h,
          ),
        ),
      ],
    );
  }
}
