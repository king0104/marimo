// TireDiagnosisResult.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marimo_client/theme.dart';
import 'widgets/ResultDetailCard.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marimo_client/commons/CustomAppHeader.dart';

class TireDiagnosisResult extends StatelessWidget {
  final XFile? userImage;

  const TireDiagnosisResult({super.key, this.userImage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: CustomAppHeader(
        title: 'AI 진단',
        onBackPressed: () => Navigator.of(context).pop(),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 헤더 아래 고정된 16.h 위치에 텍스트 배치
              SizedBox(height: 16.h),
              Text(
                '측정 결과',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: black,
                ),
              ),

              SizedBox(height: 16.h),

              // 카드 자체 높이는 비율 기반 혹은 내부 콘텐츠 기반
              ResultDetailCard(
                cardHeight: 500.h, // 비율 기반으로 예시
                treadDepth: 1.2,
                userImage: userImage,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
