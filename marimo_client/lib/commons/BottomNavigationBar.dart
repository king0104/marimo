import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.black,
          currentIndex: currentIndex,
          onTap: onTap,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined, size: 24.sp),
              activeIcon: Icon(Icons.home, size: 24.sp),
              label: "홈",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.directions_car_outlined, size: 24.sp),
              activeIcon: Icon(Icons.directions_car, size: 24.sp),
              label: "모니터링",
            ),
            const BottomNavigationBarItem(
              icon: CircleAvatar(
                backgroundColor: Color(0xFF4888FF),
                child: Icon(Icons.bluetooth, color: Colors.white),
              ),
              label: "연결하기",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map_outlined, size: 24.sp),
              activeIcon: Icon(Icons.map, size: 24.sp),
              label: "차량지도",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline, size: 24.sp),
              activeIcon: Icon(Icons.person, size: 24.sp),
              label: "마이페이지",
            ),
          ],
          selectedLabelStyle: TextStyle(fontSize: 12.sp),
          unselectedLabelStyle: TextStyle(fontSize: 12.sp),
        ),
      ),
    );
  }
}