// PictureComparison.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marimo_client/theme.dart';

class PictureComparison extends StatelessWidget {
  final double imageTextGap;
  final double pictureHeight;
  final ImageProvider? myTireImage;

  const PictureComparison({
    super.key,
    required this.imageTextGap,
    required this.pictureHeight,
    this.myTireImage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 비교 타이어
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
                width: double.infinity,
                child: Image.asset(
                  'assets/images/tires/tire_sample.png',
                  fit: BoxFit.contain,
                  width: double.infinity,
                ),
              ),
            ],
          ),
        ),

        // 내 타이어
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
                width: double.infinity,
                child:
                    myTireImage != null
                        ? ClipRRect(
                          borderRadius: BorderRadius.zero,
                          child: Image(
                            image: myTireImage!,
                            fit: BoxFit.cover, // ✅ 이미지 여백 없이 채움
                            alignment: Alignment.center,
                            width: double.infinity,
                          ),
                        )
                        : Container(
                          color: Colors.grey[300],
                          child: Center(
                            child: Text(
                              '이미지 없음',
                              style: TextStyle(fontSize: 12.sp),
                            ),
                          ),
                        ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
