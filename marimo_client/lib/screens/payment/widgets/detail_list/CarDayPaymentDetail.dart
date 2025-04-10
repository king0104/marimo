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

    // ✅ 1. 날짜 + 시각까지 포함해서 정렬
    final reversedEntries =
        [...entries].reversed.toList(); // 🔁 순서만 뒤집기// ✅ 항목 역순 정렬

    // ✅ 2. 그룹핑은 여전히 날짜 단위 (시각 제외)
    final Map<DateTime, List<CarPaymentEntry>> groupedByDate = {};

    for (final entry in reversedEntries) {
      final dateOnly = DateTime(
        entry.date.year,
        entry.date.month,
        entry.date.day,
      );
      groupedByDate
          .putIfAbsent(dateOnly, () => [])
          .add(entry); // 순서 유지 // ✅ 최신 항목 먼저 넣기
    }

    // ✅ 3. 키만 정렬할 필요 없음: 이미 entry 순서대로 그룹핑됨
    final sortedDates =
        groupedByDate.keys.toList()
          ..sort((a, b) => b.compareTo(a)); // 최신 날짜가 먼저

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
