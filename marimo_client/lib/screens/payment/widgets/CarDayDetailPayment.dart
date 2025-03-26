// CarDayDetailPayment.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'CarDayPaymentItemList.dart';

class CarDayDetailPayment extends StatelessWidget {
  final int selectedMonth;

  const CarDayDetailPayment({super.key, required this.selectedMonth});

  @override
  Widget build(BuildContext context) {
    // 날짜별 데이터 리스트로 가정 (나중에 Provider로 대체 가능)
    final List<DateTime> dummyDates = [
      DateTime(2025, selectedMonth, 11),
      DateTime(2025, selectedMonth, 2),
    ];

    return Column(
      children:
          dummyDates
              .map(
                (date) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.h),
                    Text(
                      '${date.month}월 ${date.day}일',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    CarDayPaymentItemList(date: date),
                  ],
                ),
              )
              .toList(),
    );
  }
}
