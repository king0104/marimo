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
    return Container(
      width: 180.w, // ✅ 고정된 너비로 설정
      height: 32.h, // ✅ 고정된 높이 (텍스트와 맞춤)
      padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 3.w),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: const Color(0xffACACAC), width: 0.5),
      ),
      child: Stack(
        children: [
          // ✅ 애니메이션으로 이동하는 검은색 선택 박스 (텍스트와 함께 움직임)
          AnimatedAlign(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            alignment:
                isLeftSelected ? Alignment.centerLeft : Alignment.centerRight,
            child: Container(
              width: 84.w, // ✅ 선택 박스 너비를 텍스트 크기에 맞춤
              height: 24.h,
              margin: EdgeInsets.symmetric(horizontal: 2.w),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),
          ),

          // ✅ 텍스트를 같은 Row 안에 배치하여 이동 시 정렬 유지
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildToggleText("고장 정보", isLeft: true, onTap: onLeftTap),
              _buildToggleText("상태 정보", isLeft: false, onTap: onRightTap),
            ],
          ),
        ],
      ),
    );
  }

  /// ✅ **터치 가능한 전체 영역을 `GestureDetector`로 감싸기 + 정렬 유지**
  Widget _buildToggleText(
    String title, {
    required bool isLeft,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque, // ✅ 빈 공간도 터치 가능
        onTap: onTap,
        child: Align(
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14.sp, // ✅ 폰트 크기를 유지하면서 적절한 크기 조정
              fontWeight: FontWeight.w500,
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
