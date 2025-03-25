import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CommonBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CommonBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // 스택 전체를 Container로 감싸 margin을 주어 위치를 조정합니다.
    return Container(
      color: Colors.transparent,
      margin: EdgeInsets.only(bottom: 20, left: 20.w, right: 20.w), // 스택 전체를 아래에서 20.h 띄움
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 70,
            width: 325.w,
            padding: EdgeInsets.symmetric(horizontal: 10.w),//바 내부 여백 조정
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50.r),
                topRight: Radius.circular(50.r),
                bottomLeft: Radius.circular(50.r),
                bottomRight: Radius.circular(50.r),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50.r),
                topRight: Radius.circular(50.r),
                bottomLeft: Radius.circular(50.r),
                bottomRight: Radius.circular(50.r),
              ),
              // 여기에 Padding 추가해서 내부 BottomNavigationBar의 아래쪽 공간을 확보합니다.
              child: Padding(
                padding: EdgeInsets.only(top: 0), // 원하는 만큼 아래쪽에 여백을 줍니다.
                child: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: Colors.transparent,
                  currentIndex: currentIndex,
                  onTap: onTap,
                  selectedItemColor: Color(0xFF4888FF),
                  unselectedItemColor: Color(0xFF8E8E8E),
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  selectedFontSize: 0,
                  unselectedFontSize: 0,
                  items: [
                    BottomNavigationBarItem(
                      icon: SvgPicture.asset('assets/images/icons/icon_home.svg', width: 20.sp, height: 20.sp),
                      activeIcon: SvgPicture.asset('assets/images/icons/icon_home.svg', width: 20.sp, height: 20.sp, color: Color(0xFF4888FF)),
                      label: "",
                    ),
                    BottomNavigationBarItem(
                      icon: SvgPicture.asset('assets/images/icons/icon_car.svg', width: 20.sp, height: 20.sp),
                      activeIcon: SvgPicture.asset('assets/images/icons/icon_car.svg', width: 20.sp, height: 20.sp,color: Color(0xFF4888FF)),
                      label: "",
                    ),
                    BottomNavigationBarItem(
                      icon: SizedBox(height: 24.sp), // 중앙 버튼을 위한 공간 확보용
                      label: "",
                    ),
                    BottomNavigationBarItem(
                      icon: SvgPicture.asset('assets/images/icons/icon_map.svg', width: 20.sp, height: 20.sp),
                      activeIcon: SvgPicture.asset('assets/images/icons/icon_map.svg', width: 20.sp, height: 20.sp,color: Color(0xFF4888FF)),
                      label: "",
                    ),
                    BottomNavigationBarItem(
                      icon: SvgPicture.asset('assets/images/icons/icon_my.svg', width: 20.sp, height: 20.sp),
                      activeIcon: SvgPicture.asset('assets/images/icons/icon_my.svg', width: 20.sp, height: 20.sp,color: Color(0xFF4888FF)),
                      label: "",
                    ),
                  ],
                ),
              ), // <-- Padding 닫는 위치
            ),
          ),
          Positioned(
            top: -10.h,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 56.w,
                height: 56.w,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF9DBFFF), Color(0xFF4888FF)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Image.asset(
                  'assets/images/icons/connect.png',  // 이미지 경로
                  width: 28.sp,  // 크기는 기존 아이콘과 동일하게
                  color: Colors.white,  // 이미지 색상
                ),
              ),
            ),
          ),
        ], // <-- Stack의 children 닫는 위치
      ), // <-- Stack 닫는 위치
    ); // <-- Container 닫는 위치
  }
}
