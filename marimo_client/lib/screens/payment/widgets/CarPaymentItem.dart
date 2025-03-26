// CarPaymentItem.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CarPaymentItem extends StatelessWidget {
  final String iconPath;
  final String label;
  final String amount;
  final String percentage;

  const CarPaymentItem({
    super.key,
    required this.iconPath,
    required this.label,
    required this.amount,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 44.w,
              height: 44.h,
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
            ),
            SvgPicture.asset(iconPath, width: 20.w, height: 20.w),
          ],
        ),
        SizedBox(width: 18.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
            ),
            Text(
              percentage,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const Spacer(),
        Text(
          amount,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
