// PictureComparison.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marimo_client/theme.dart';

class PictureComparison extends StatelessWidget {
  final double imageTextGap;
  final double pictureHeight;

  const PictureComparison({
    super.key,
    required this.imageTextGap,
    required this.pictureHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Text(
                '비교',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: iconColor,
                ),
              ),
              SizedBox(height: imageTextGap),
              SizedBox(
                height: pictureHeight,
                child: Image.asset(
                  'assets/images/tires/tire_sample.png',
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Text(
                '내 타이어',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: iconColor,
                ),
              ),
              SizedBox(height: imageTextGap),
              SizedBox(
                height: pictureHeight,
                child: Image.asset(
                  'assets/images/tires/tire_mine.png',
                  fit: BoxFit.cover,
                  // width: double.infinity,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
