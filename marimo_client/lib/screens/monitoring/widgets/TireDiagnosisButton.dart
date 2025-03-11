import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // ✅ ScreenUtil 추가

class TireDiagnosisButton extends StatelessWidget {
  const TireDiagnosisButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // ✅ 부모 크기만큼 확장
      child: ElevatedButton(
        onPressed: () {
          debugPrint("🚀 AI 진단 받기 클릭!!");
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0x1A4888FF), // ✅ 배경색 (10% 투명도)
          foregroundColor: const Color(0xFF000000), // ✅ 글씨 및 아이콘 색상
          padding: EdgeInsets.zero, // ✅ 버튼의 기본 패딩 제거
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(
              color: Color(0xFF4888FF),
              width: 0.5,
            ), // ✅ 테두리 추가
          ),
          elevation: 0, // ✅ 그림자 제거
          shadowColor: Colors.transparent, // ✅ 눌렀을 때 그림자 제거
          overlayColor: const Color(0x1A4888FF),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 8.w,
            vertical: 10.h,
          ), // ✅ `w`, `h` 적용 가능
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // ✅ 내부 요소 확장
            children: [
              Image.asset(
                'assets/images/icons/icon_tire.webp',
                width: 32.w, // ✅ `sp` 대신 `w` 사용
                height: 32.h,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  "마지막 점검 후 20000km 주행",
                  style: TextStyle(
                    fontSize: 12.sp, // ✅ `sp` 사용 (const 제거)
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis, // ✅ 긴 글자는 ... 처리
                ),
              ),
              SizedBox(width: 10.w),
              Text(
                "AI 진단 받기",
                style: TextStyle(
                  fontSize: 10.sp, // ✅ `sp` 사용
                  fontWeight: FontWeight.w300,
                  color: const Color(0xFF0E0E0E),
                ),
              ),
              SizedBox(width: 5.w),
              Icon(
                Icons.chevron_right,
                size: 18.sp, // ✅ 아이콘 크기 자동 조정
                color: const Color(0xFF0E0E0E),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
