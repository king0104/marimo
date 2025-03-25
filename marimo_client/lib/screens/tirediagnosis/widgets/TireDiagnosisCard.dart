// TireDiagnosisCard.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'ImagePicker.dart';
import 'AnalysisButton.dart';

class TireDiagnosisCard extends StatelessWidget {
  final List<XFile> selectedImages;
  final Function(XFile) onAddImage;
  final Function(int) onRemoveImage;
  final VoidCallback onAnalysisPressed;

  const TireDiagnosisCard({
    Key? key,
    required this.selectedImages,
    required this.onAddImage,
    required this.onRemoveImage,
    required this.onAnalysisPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320.h,
      height: 420.h,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04), // 투명도 4%
              blurRadius: 11.8, // Blur 값
              spreadRadius: 4, // Spread 값
              offset: Offset(0, 0), // X와 Y Position 값
            ),
          ],
        ),
        child: Card(
          elevation: 0, // 🔹 Card 자체의 elevation은 0으로 설정
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
              children: [
                Center(
                  child: Text(
                    '타이어 사진을 1장 등록해 주세요.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14.sp, color: Colors.black87),
                  ),
                ),
                SizedBox(height: 65.h),
                Center(
                  child: TireImagePicker(
                    selectedImages: selectedImages,
                    onAddImage: onAddImage,
                    onRemoveImage: onRemoveImage,
                    buttonSize: 36.h,
                  ),
                ),
                Spacer(),
                AnalysisButton(
                  enabled: selectedImages.isNotEmpty,
                  onPressed: onAnalysisPressed,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
