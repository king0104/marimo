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
      width: 320,
      height: 420,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
          side: BorderSide(
            color: Colors.grey.withOpacity(0.2),
            width: 1.w,
          ),
        ),
        color: Colors.white,
        margin: EdgeInsets.zero,
        child: Padding(
          padding: EdgeInsets.only(
            left: 25,
            right: 25, 
            top: 23, // 상단 패딩을 23픽셀로 변경
            bottom: 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 문구 추가 (상단 여백이 23픽셀로 조정됨)
              Center(
                child: Text(
                  '타이어 사진을 1장 등록해주세요.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.black87,
                  ),
                ),
              ),
              
              // 텍스트와 이미지 피커 사이의 간격 조정
              SizedBox(height: 65),
              
              // 이미지 선택 위젯
              Center(
                child: TireImagePicker(
                  selectedImages: selectedImages,
                  onAddImage: onAddImage,
                  onRemoveImage: onRemoveImage,
                  buttonSize: 36,
                ),
              ),
              
              // 나머지 공간은 Spacer로 자동 조정
              Spacer(),
              
              // 분석 버튼
              AnalysisButton(
                enabled: selectedImages.isNotEmpty,
                onPressed: onAnalysisPressed,
              ),
            ],
          ),
        ),
      ),
    );
  }
}