import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TireDiagnosisButton extends StatelessWidget {
  const TireDiagnosisButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // ✅ 버튼을 부모 크기만큼 확장
      child: ElevatedButton(
        onPressed: () {
          debugPrint("🚀 AI 진단 받기 클릭!!");
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0x1A4888FF),
          foregroundColor: Colors.black,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Color(0xFF4888FF), width: 0.5),
          ),
          elevation: 0,
          shadowColor: Colors.transparent,
          overlayColor: const Color(0x1A4888FF),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 8.w,
            vertical: 10.h,
          ), // ✅ 내부 패딩 추가
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 타이어 아이콘
              Image.asset(
                'assets/images/icons/icon_tire.webp',
                width: 32.w,
                height: 32.h,
              ),
              SizedBox(width: 7.w),

              // 주행 거리 정보
              Expanded(
                child: Text(
                  "마지막 점검 후 20000km 주행",
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 10.w),

              // AI 진단 받기 버튼 & 아이콘
              Text(
                "AI 진단 받기",
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w300,
                  color: const Color(0xFF0E0E0E),
                ),
              ),
              SizedBox(width: 4.w),
              Icon(
                Icons.chevron_right,
                size: 15.sp,
                color: const Color(0xFF0E0E0E),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
