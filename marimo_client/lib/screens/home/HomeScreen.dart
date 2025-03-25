import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'widgets/WeatherWidget.dart';
import 'widgets/NotificationBadges.dart';
import 'widgets/CarProfileCard.dart';
import 'widgets/CarImageWidget.dart';
import 'widgets/CarStatusWidget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20.w, top: 12.h, right: 20.w), // ✅ 기존 패딩 유지
            child: Column(
              children: [
                Row(
                  children: [
                    const WeatherWidget(),
                    const Spacer(), // ✅ 중간 띄우기 (알림 제외)
                  ],
                ),
                SizedBox(height: 40.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: 280.h,
                        child: const CarImageWidget(), // ✅ BoxFit.cover 사용한 이미지 제외
                      ),
                    ),
                    Expanded(flex: 2, child: const CarProfileCard()),
                  ],
                ),
                SizedBox(height: 20.h),
                const CarStatusWidget(),
                SizedBox(height: 120),
              ],
            ),
          ),

          // ✅ NotificationBadges만 패딩을 무시하고 오른쪽 끝으로 배치
          Positioned(
            top: 12.h, // 기존 상단 패딩과 맞추기
            right: 0, // 오른쪽 끝에 배치 (부모 패딩 무시)
            child: NotificationBadges(),
          ),
        ],
      ),
    );
  }
}
