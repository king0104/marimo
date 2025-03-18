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
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                SizedBox(height: 12.h),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    WeatherWidget(),
                    NotificationBadges(),
                  ],
                ),
                SizedBox(height: 20.h),
                const CarImageWidget(),
                SizedBox(height: 20.h),
                const CarProfileCard(),
                SizedBox(height: 20.h),
                const CarStatusWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}