import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationBadges extends StatelessWidget {
  const NotificationBadges({super.key});

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(15.w, 0), // ✅ 오른쪽으로 15.w 만큼 이동 (화면 밖으로 살짝 나가도록)
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildBadge(count: 4, color: Colors.red, icon: Icons.warning_rounded),
          SizedBox(height: 8.h),
          _buildBadge(
            count: 15,
            color: const Color(0xFF4888FF),
            icon: Icons.info_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildBadge({
    required int count,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      width: 85.w, // ✅ 크기 조정 (숫자가 빠졌으므로 줄여도 됨)
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color, width: 1), // ✅ 컨테이너 테두리 색상 유지
      ),
      child: Stack(
        clipBehavior: Clip.none, // ✅ 배지가 컨테이너 밖으로 나갈 수 있도록 설정
        children: [
          // ✅ 아이콘만 남기고, 숫자는 제거!
          Container(
            width: 30.w,
            height: 30.w,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, color: Colors.white, size: 20.w),
          ),

          // ✅ 숫자는 아이콘 위 뱃지에서만 표시
          Positioned(
            top: -4.h,
            right: 20.w, // ✅ 뱃지를 왼쪽으로 조금 이동
            child: Container(
              width: 22.w, // ✅ 두 자리 숫자 기준으로 크기 고정
              height: 22.w, // ✅ 정사각형 크기 유지
              decoration: BoxDecoration(
                color: Colors.white, // ✅ 배경색 흰색
                shape: BoxShape.circle,
                border: Border.all(color: color, width: 1), // ✅ 아웃라인을 컨테이너 테두리 색과 동일하게
              ),
              child: Center(
                child: Text(
                  count.toString(),
                  style: TextStyle(
                    color: Colors.black, // ✅ 숫자 색상을 검은색으로 변경
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
