// CarDayPaymentDetail.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:marimo_client/providers/car_payment_provider.dart';
import 'package:marimo_client/models/payment/car_payment_entry.dart';
import 'CarDayPaymentItemList.dart';

class CarDayPaymentDetail extends StatelessWidget {
  const CarDayPaymentDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final entries = context.select<CarPaymentProvider, List<CarPaymentEntry>>(
      (provider) => provider.filteredEntries,
    );

    /// ⏱ 그룹핑 한 번만
    final Map<DateTime, List<CarPaymentEntry>> groupedByDate = {};
    for (final entry in entries) {
      final date = DateTime(entry.date.year, entry.date.month, entry.date.day);
      groupedByDate.putIfAbsent(date, () => []).add(entry);
    }

    /// ⏱ 정렬도 한 번만
    final sortedDates =
        groupedByDate.keys.toList()..sort((a, b) => b.compareTo(a));

    return ListView.builder(
      cacheExtent: 1000, // ✅ 미리 렌더링 범위
      itemCount: sortedDates.length,
      itemBuilder: (context, index) {
        final date = sortedDates[index];
        final items = groupedByDate[date]!;

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
              CarDayPaymentItemList(date: date, entries: items),
            ],
          ),
        );
      },
    );
  }
}
