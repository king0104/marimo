// AnalysiButton.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnalysisButton extends StatelessWidget {
  final bool enabled;
  final VoidCallback onPressed;

  // ✅ 피그마 디자인 색상 적용
  static const Color brandColor = Color(0xFF4888FF);

  const AnalysisButton({
    Key? key,
    required this.enabled,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 270,
        height: 45,
        child: ElevatedButton(
          onPressed: enabled ? onPressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: enabled ? brandColor : brandColor.withOpacity(0.5), // ✅ 색상 변경
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
            disabledBackgroundColor: brandColor.withOpacity(0.3), // ✅ 비활성화 시 연한 파란색
            disabledForegroundColor: Colors.white.withOpacity(0.7),
            elevation: 0,
            padding: EdgeInsets.zero, // 패딩 제거하여 정확한 크기 유지
          ),
          child: Text(
            '타이어 마모도 측정하기',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
