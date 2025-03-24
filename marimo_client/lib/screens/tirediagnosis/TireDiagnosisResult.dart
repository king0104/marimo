// TireDiagnosisResult.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marimo_client/theme.dart';
import 'widgets/ResultDetailCard.dart';

class TireDiagnosisResult extends StatelessWidget {
  const TireDiagnosisResult({Key? key}) : super(key: key);

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
      appBar: AppBar(
        elevation: 0,
        backgroundColor: backgroundColor,
        centerTitle: true,
        title: Text(
          'AI 진단',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: black,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: black),
          onPressed: () => Navigator.of(context).pop(),
        ),
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
                // ✅ 여기로 감싸줘야 높이 계산이 의미 있어짐!
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ResultDetailCard(
                    cardHeight: availableHeight,
                    treadDepth: 5.6,
                  ),
                ),
              ),
              SizedBox(height: bottomOffset), // ✅ 정확히 104만큼 띄우기 위해 필요
            ],
          ),
        ),
      ),
    );
  }
}
