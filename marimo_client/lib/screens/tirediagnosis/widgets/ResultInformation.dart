// ResultInformation.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marimo_client/theme.dart';

class ResultInformation extends StatelessWidget {
  const ResultInformation({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
            children: const [
              TextSpan(text: '수준 : '),
              TextSpan(
                text: '양호 ',
                style: TextStyle(
                  color: pointColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextSpan(text: '😊'),
            ],
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          '사용감 : 트레드가 5.6mm 남았어요',
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400),
        ),
        SizedBox(height: 16.h),
        Text(
          '타이어가 건강한 편입니다!\n그래도 항상 주기적 점검은 해주셔야 하는거 알죠!?',
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
            color: Colors.black,
            height: 1.6,
          ),
        ),
      ],
    );
  }
}
