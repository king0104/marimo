// CarDayDetailPayment.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'CarDayPaymentItemList.dart';

class CarDayDetailPayment extends StatelessWidget {
  final int selectedMonth;

  const CarDayDetailPayment({super.key, required this.selectedMonth});

  @override
  Widget build(BuildContext context) {
    // 날짜별 데이터 리스트 (나중에 Provider로 대체 가능)
    final List<DateTime> dummyDates = [
      DateTime(2025, selectedMonth, 16),
      DateTime(2025, selectedMonth, 12),
      DateTime(2025, selectedMonth, 11),
      DateTime(2025, selectedMonth, 1),
    ];

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: dummyDates.length,
      itemBuilder: (context, index) {
        final date = dummyDates[index];
        return Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${date.month}월 ${date.day}일',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w300),
              ),
              SizedBox(height: 16.h),
              CarDayPaymentItemList(date: date),
            ],
          ),
        );
      },
    );
  }
}
