// CustomAppHeader.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomAppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onBackPressed;
  final List<Widget>? actions;

  const CustomAppHeader({
    Key? key,
    required this.title,
    required this.onBackPressed,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 🔹 상태바 (사용자 상태바를 그대로 유지)
        Container(height: MediaQuery.of(context).padding.top),

        // 🔹 헤더
        Container(
          height: 60.h, // 📌 헤더 높이 고정
          decoration: BoxDecoration(
            color: Color(0xFFFBFBFB), // 📌 Figma 배경색 (#FBFBFB) 적용
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                offset: Offset(0, 1),
                blurRadius: 1,
              ),
            ],
          ),
          child: Stack(
            children: [
              // 🔙 뒤로가기 버튼
              Positioned(
                left: 12.w,
                top: 0,
                bottom: 0,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: onBackPressed,
                  child: SizedBox(
                    width: 44.w,
                    height: 44.w,
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/images/icons/icon_back.svg',
                        width: 18.sp,
                        height: 18.sp,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),

              // 📌 중앙 정렬된 타이틀
              Center(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500, // 📌 Figma font-weight: 500 적용
                    color: Colors.black,
                  ),
                ),
              ),
              // ✅ 오른쪽 액션 버튼
              if (actions != null)
                Positioned(
                  right: 5.w,
                  top: 0,
                  bottom: 0,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: actions!,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(60.h);
}
