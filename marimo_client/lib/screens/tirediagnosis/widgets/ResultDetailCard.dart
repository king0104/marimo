// ResultDetailCard.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'PictureComparison.dart';
import 'ResultInformation.dart';
import 'CompleteButton.dart';
import 'RepairshopButton.dart';
import 'package:marimo_client/theme.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ResultDetailCard extends StatelessWidget {
  final double cardHeight;
  final double treadDepth;
  final XFile? userImage;

  const ResultDetailCard({
    super.key,
    required this.cardHeight,
    required this.treadDepth,
    this.userImage,
  });

  @override
  Widget build(BuildContext context) {
    // 📐 기준 500 기준 px → .h 변환
    final double titleTop = 15.h;
    // final double pictureTop = 38.h;
    final double pictureHeight = 215.h;
    final double levelTextTop = 279.h;
    final double buttonBottom = 27.h;

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
            // ✅ [1] 타이어 비교 사진만 전체 너비로 (여백 없음)
            Positioned(
              top: titleTop,
              left: 0,
              right: 0,
              child: PictureComparison(
                imageTextGap: 7.h,
                pictureHeight: pictureHeight,
                myTireImage:
                    userImage != null ? FileImage(File(userImage!.path)) : null,
              ),
            ),

            // ✅ [2] 나머지 요소는 기존처럼 Padding 유지
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: Stack(
                children: [
                  Positioned(
                    top: levelTextTop,
                    left: 0,
                    right: 0,
                    child: ResultInformation(
                      treadDepth: treadDepth,
                      cardHeight: cardHeight,
                    ),
                  ),
                  Positioned(
                    bottom: buttonBottom,
                    left: 0,
                    right: 0,
                    child: const CompleteButton(),
                  ),
                ],
              ),
            ),

            if (treadDepth < 3)
              Positioned(
                top: 270.h, // ✅ 카드 위에서부터 275px
                right: 17.w, // ✅ 오른쪽에서부터 17px
                child: const RepairshopButton(),
              ),
          ],
        ),
      ),
    );
  }
}
