import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marimo_client/screens/my/widgets/MyPageHeader.dart';
import 'package:marimo_client/screens/my/widgets/MyPageMenu.dart';
import 'package:marimo_client/screens/my/widgets/ScoreGauge.dart';

class MyScreen extends StatelessWidget {
  const MyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            const MyPageHeader(), // 마이 페이지 상단
            SizedBox(height: 20.h),
            const ScoreGauge(), // 봉봉이 점수 게이지
            SizedBox(height: 20.h),
            const MyPageMenu(), // 메뉴 리스트
            SizedBox(height: 120),
          ],
        ),
      ),
    );
  }
}
