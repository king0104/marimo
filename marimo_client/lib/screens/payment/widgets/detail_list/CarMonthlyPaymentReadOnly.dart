// CarMonthlyPaymentReadOnly.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:marimo_client/providers/car_payment_provider.dart';
import 'package:marimo_client/theme.dart';

class CarMonthlyPaymentReadOnly extends StatelessWidget {
  const CarMonthlyPaymentReadOnly({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CarPaymentProvider>();
    final selectedMonth = provider.selectedMonth;
    final selectedYear = provider.selectedYear;
    final total = provider.totalAmountForSelectedMonth;
    final difference = provider.previousMonthDifference;

    // 디버깅을 위한 코드 추가
    // print(
    //   'CarMonthlyPaymentReadOnly - selectedMonth: $selectedMonth, selectedYear: $selectedYear',
    // );
    // print('CarMonthlyPaymentReadOnly hash: ${provider.hashCode}');

    final formattedTotal = NumberFormat(
      '###,###,###,###,###,###',
    ).format(total);

    final formattedDifference = NumberFormat(
      '###,###,###,###,###,###',
    ).format(difference.abs());

    final differencePrefix = difference >= 0 ? '+' : '-';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 연도 텍스트 (드롭다운 없음)
            Text(
              '$selectedYear년',
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700),
            ),
            SizedBox(width: 4.w),
            // 월 텍스트 (드롭다운 없음)
            Text(
              '$selectedMonth월',
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              formattedTotal,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
                color: brandColor,
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              '원',
              style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w300),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        Text(
          '지난 달보다 $differencePrefix$formattedDifference원',
          style: TextStyle(
            fontSize: 12.sp,
            color: const Color(0xFF8E8E8E),
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }
}
