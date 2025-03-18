// CustomAppHeader.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomAppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onBackPressed;
  
  const CustomAppHeader({
    Key? key, 
    required this.title,
    required this.onBackPressed,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    // MediaQuery를 사용하여 상태 표시줄 높이 가져오기
    final statusBarHeight = MediaQuery.of(context).padding.top;
    
    return Container(
      // 전체 높이는 상태 표시줄 높이 + 헤더 높이(60)
      height: statusBarHeight + 60.h,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: Offset(0, 1),
            blurRadius: 1,
          ),
        ],
      ),
      child: Padding(
        // 상단 패딩에 상태 표시줄 높이만큼 추가
        padding: EdgeInsets.only(top: statusBarHeight),
        child: Stack(
          children: [
            // 뒤로가기 버튼
            Positioned(
              left: 16.w,
              top: 0,
              bottom: 0,
              child: Center(
                child: GestureDetector(
                  onTap: onBackPressed,
                  child: SvgPicture.asset(
                    'assets/images/icons/icon_back.svg',
                    width: 18.sp,
                    height: 18.sp,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            
            // 중앙 정렬된 타이틀
            Center(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  @override
  Size get preferredSize {
    // 상태 표시줄 높이를 포함한 전체 높이를 반환
    // build 메서드 외부에서는 MediaQuery에 접근할 수 없으므로 대략적인 값 사용
    return Size.fromHeight(60.h + 24.h); // 24.h는 대략적인 상태 표시줄 높이
  }
}