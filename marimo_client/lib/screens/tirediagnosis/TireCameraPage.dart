// TireCameraPage.dart
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'widgets/TireCameraGuide.dart';
import 'package:marimo_client/commons/CustomAppHeader.dart';

class TireCameraPage extends StatelessWidget {
  final Function(XFile) onImageCaptured;

  const TireCameraPage({
    Key? key,
    required this.onImageCaptured,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppHeader(
        title: 'AI 진단',
        onBackPressed: () => Navigator.of(context).pop(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 📌 "타이어 사진 촬영" 문구
          Padding(
            padding: EdgeInsets.only(left: 20, top: 16), // 왼쪽 20, 헤더 아래 16
            child: Text(
              "타이어 사진 촬영",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),

          SizedBox(height: 16), // 📌 문구와 카메라 프리뷰 사이 16의 간격 추가

          // 📸 타이어 촬영 가이드 (카메라 미리보기 포함)
          Expanded(
            child: TireCameraGuide(
              onImageCaptured: (XFile image) {
                onImageCaptured(image); // 이미지 캡처 후 콜백 전달
                Navigator.of(context).pop(); // 이전 화면으로 돌아가기
              },
            ),
          ),
        ],
      ),
    );
  }
}
