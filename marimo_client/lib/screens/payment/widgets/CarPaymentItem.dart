// CarPaymentItem.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CarPaymentItem extends StatelessWidget {
  final Widget icon; // ✅ 아이콘 위젯으로 변경
  final String label;
  final String amount;
  final String percentage;

  const CarPaymentItem({
    super.key,
    required this.icon,
    required this.label,
    required this.amount,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        icon, // ✅ 위젯으로 받은 아이콘 직접 렌더링
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
