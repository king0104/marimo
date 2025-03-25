// TireCameraPage.dart
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'widgets/TireCameraGuide.dart';
import 'package:marimo_client/commons/CustomAppHeader.dart';

class TireCameraPage extends StatefulWidget {
  final Function(XFile) onImageCaptured;

  const TireCameraPage({Key? key, required this.onImageCaptured})
    : super(key: key);

  @override
  _TireCameraPageState createState() => _TireCameraPageState();
}

class _TireCameraPageState extends State<TireCameraPage> {
  XFile? _capturedImage;

  void _handleImageCaptured(XFile image) {
    setState(() {
      _capturedImage = image; // 상태 업데이트
    });

    widget.onImageCaptured(image); // 부모 위젯에 이미지 전달
    Navigator.of(context).pop(); // 이전 화면으로 돌아가기
  }

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
              onImageCaptured: _handleImageCaptured, // 이미지 캡처 후 처리
            ),
          ),

          if (_capturedImage != null) ...[
            SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "사진이 성공적으로 캡처되었습니다!",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.green,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
