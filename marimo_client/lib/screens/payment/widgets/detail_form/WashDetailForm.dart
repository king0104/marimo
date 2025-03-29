// WashDetailForm.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WashDetailForm extends StatelessWidget {
  final int amount;

  const WashDetailForm({super.key, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 12.h),
        Text('날짜', style: TextStyle(fontSize: 14.sp)),
        SizedBox(height: 8.h),
        Text(
          '2025년 3월 11일',
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 24.h),
        Text('장소', style: TextStyle(fontSize: 14.sp)),
        SizedBox(height: 8.h),
        TextField(decoration: InputDecoration(hintText: '장소를 입력하세요')),
        SizedBox(height: 24.h),
        Text('메모', style: TextStyle(fontSize: 14.sp)),
        SizedBox(height: 8.h),
        TextField(
          maxLength: 20,
          decoration: InputDecoration(hintText: '메모할 수 있어요 (최대 20자)'),
        ),
        const Spacer(),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(onPressed: () {}, child: const Text('저장')),
        ),
        SizedBox(height: 24.h),
      ],
    );
  }
}
