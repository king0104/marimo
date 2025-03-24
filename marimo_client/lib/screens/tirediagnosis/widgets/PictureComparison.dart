// PictureComparison.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marimo_client/theme.dart';

class PictureComparison extends StatelessWidget {
  final double imageTextGap;
  final double pictureHeight;
  final ImageProvider? myTireImage; // ✅ 내 타이어 이미지 추가

  const PictureComparison({
    super.key,
    required this.imageTextGap,
    required this.pictureHeight,
    this.myTireImage, // ✅ 선택적 전달
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
                child:
                    myTireImage != null
                        ? Image(
                          image: myTireImage!,
                          fit: BoxFit.cover,
                          width: double.infinity,
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
