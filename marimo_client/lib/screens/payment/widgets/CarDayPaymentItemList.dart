// CarDayPaymentItemList.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'CarDayPaymentItem.dart';

class CarDayPaymentItemList extends StatelessWidget {
  final DateTime date;

  const CarDayPaymentItemList({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> entries = [
      {'category': '주유', 'amount': 10000, 'subText': '11.26L'},
      {'category': '정비', 'amount': 25000, 'subText': null},
      {'category': '세차', 'amount': 5000, 'subText': null},
    ];

    return Column(
      children:
          entries.map((entry) {
            return Padding(
              padding: EdgeInsets.only(left: 6.w, right: 6.w, bottom: 20.h),
              child: CarDayPaymentItem(
                category: entry['category'],
                amount: entry['amount'],
                subText: entry['subText'],
              ),
            );
          }).toList(),
    );
  }
}
