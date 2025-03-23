// PictureComparison.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PictureComparison extends StatelessWidget {
  const PictureComparison({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Text(
                '비교',
                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 8.h),
              Image.asset(
                'assets/images/tires/tire_sample.png',
                width: 130.w,
                height: 130.w,
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Text(
                '내 타이어',
                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 8.h),
              Image.asset(
                'assets/images/tires/tire_mine.png',
                width: 130.w,
                height: 130.w,
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
