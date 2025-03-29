// CategoryAndAmount.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:marimo_client/commons/icons/OilIcon.dart';
import 'package:marimo_client/commons/icons/RepairIcon.dart';
import 'package:marimo_client/commons/icons/WashIcon.dart';

class CategoryAndAmount extends StatelessWidget {
  final String category;
  final int amount;

  const CategoryAndAmount({
    Key? key,
    required this.category,
    required this.amount,
  }) : super(key: key);

  // 카테고리에 따른 아이콘 반환
  Widget _getCategoryIcon() {
    switch (category) {
      case '주유':
        return const OilIcon(size: 44);
      case '정비':
        return const RepairIcon(size: 44);
      case '세차':
        return const WashIcon(size: 44);
      default:
        return const SizedBox(); // 기본값
    }
  }

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat('#,###');

    return Row(
      children: [
        // 카테고리 아이콘
        _getCategoryIcon(),
        SizedBox(width: 12.w),

        // 카테고리 텍스트
        Text(
          category,
          style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w500),
        ),

        Spacer(),

        // 금액 표시
        Text(
          '${numberFormat.format(amount)} 원',
          style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
