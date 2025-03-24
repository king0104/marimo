// ResultDetailCard.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'PictureComparison.dart';
import 'ResultInformation.dart';
import 'CompleteButton.dart';
import 'RepairshopButton.dart';
import 'package:marimo_client/theme.dart';

class ResultDetailCard extends StatelessWidget {
  final double cardHeight;
  final double treadDepth;

  const ResultDetailCard({
    super.key,
    required this.cardHeight,
    required this.treadDepth,
  });

  @override
  Widget build(BuildContext context) {
    // 비율 기반 거리 계산
    final double paddingTop = cardHeight * 0.03; // 15 / 500
    final double pictureGap = cardHeight * 0.014; // 7 / 500
    final double pictureHeight = cardHeight * 0.43; // 215 / 500
    final double levelToInfoGap = cardHeight * 0.052; // 26 / 500
    final double infoToDescGap = cardHeight * 0.05; // 25 / 500
    final double bottomGap = cardHeight * 0.054; // 27 / 500

    // 🔸 정비소 버튼 위치 = 사진 상단 패딩 + 타이어 텍스트 높이 + 사진 높이 + 여백의 절반
    final double repairButtonTop =
        paddingTop +
        12.sp +
        pictureGap +
        pictureHeight +
        levelToInfoGap * 2 / 3;

    return Container(
      width: double.infinity,
      height: cardHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 11.8,
            spreadRadius: 4,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
          side: BorderSide(color: Colors.grey.withOpacity(0.2), width: 1.w),
        ),
        color: Colors.white,
        margin: EdgeInsets.zero,
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(top: paddingTop, bottom: bottomGap),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  PictureComparison(
                    imageTextGap: pictureGap,
                    pictureHeight: pictureHeight,
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: levelToInfoGap),
                          ResultInformation(treadDepth: treadDepth),
                          SizedBox(height: infoToDescGap),
                          const Spacer(),
                          const CompleteButton(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 🔸 조건부 렌더링
            if (treadDepth < 3)
              Positioned(
                top: repairButtonTop,
                right: 20.w,
                child: const RepairshopButton(),
              ),
          ],
        ),
      ),
    );
  }
}
