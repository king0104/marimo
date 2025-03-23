// ResultDetailCard.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'PictureComparison.dart';
import 'ResultInformation.dart';
import 'CompleteButton.dart';

class ResultDetailCard extends StatelessWidget {
  const ResultDetailCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      height: 500, // 높이만 더 크게 조정
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 11.8,
              spreadRadius: 4,
              offset: Offset(0, 0),
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
          child: Padding(
            padding: EdgeInsets.only(left: 25, right: 25, top: 23, bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: const [
                PictureComparison(),
                SizedBox(height: 16),
                ResultInformation(),
                Spacer(),
                CompleteButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
