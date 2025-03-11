import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ListToggle extends StatelessWidget {
  final bool isLeftSelected;
  final VoidCallback onLeftTap;
  final VoidCallback onRightTap;

  const ListToggle({
    super.key,
    required this.isLeftSelected,
    required this.onLeftTap,
    required this.onRightTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180.w, // ✅ 토글 너비 고정
      height: 24.h, // ✅ 토글 높이 고정
      child: Stack(
        children: [
          // ✅ 배경 박스 (연한 회색)
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: const Color(0xffACACAC)),
            ),
          ),

          // ✅ 애니메이션 이동하는 검은색 선택 박스
          AnimatedAlign(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            alignment:
                isLeftSelected ? Alignment.centerLeft : Alignment.centerRight,
            child: Container(
              width: 88.w,
              height: 24.h,
              margin: EdgeInsets.all(3.h),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),
          ),

          // ✅ 텍스트 및 클릭 가능 영역 확장
          Positioned.fill(
            child: Row(
              children: [
                _buildToggleText("고장 정보", isLeft: true, onTap: onLeftTap),
                _buildToggleText("상태 정보", isLeft: false, onTap: onRightTap),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ✅ **터치 가능한 전체 영역을 `GestureDetector`로 감싸기 + 글자 찌부 방지**
  Widget _buildToggleText(
    String title, {
    required bool isLeft,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque, // ✅ 빈 공간도 터치 가능
        onTap: onTap,
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 10.sp, // ✅ OBD2 상세와 동일한 크기
              fontWeight: FontWeight.w500, // ✅ 동일한 Weight 설정
              color:
                  (isLeftSelected == isLeft)
                      ? Colors.white
                      : const Color(0xFF747474),
            ),
          ),
        ),
      ),
    );
  }
}
