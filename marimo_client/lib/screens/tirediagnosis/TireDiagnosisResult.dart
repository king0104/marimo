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
    final double totalHeight = MediaQuery.of(context).size.height;
    final double appBarHeight = kToolbarHeight;
    final double verticalPadding = 16.h;
    final double bottomOffset = 104.h;
    final double availableHeight =
        totalHeight - appBarHeight - verticalPadding * 2 - bottomOffset;

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
              SizedBox(height: verticalPadding),
              Text(
                '측정 결과',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: black,
                ),
              ),
              SizedBox(height: verticalPadding),
              Expanded(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ResultDetailCard(
                    cardHeight: availableHeight,
                    treadDepth: 5.6,
                    userImage: userImage, // 사용자 이미지 전달
                  ),
                ),
              ),
              SizedBox(height: bottomOffset),
            ],
          ),
        ),
      ),
    );
  }
}
