import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'widgets/WeatherWidget.dart';
import 'widgets/NotificationBadges.dart';
import 'widgets/CarProfileCard.dart';
import 'widgets/CarImageWidget.dart';
import 'widgets/CarStatusWidget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<Offset> _weatherOffset;
  late Animation<Offset> _imageOffset;
  late Animation<Offset> _profileOffset;
  late Animation<Offset> _badgeOffset;

  late Animation<double> _fadeWeather;
  late Animation<double> _fadeImage;
  late Animation<double> _fadeProfile;
  late Animation<double> _fadeStatus;
  late Animation<double> _fadeBadge;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _weatherOffset = Tween<Offset>(
      begin: const Offset(-0.3, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.25)),
    );

    _fadeWeather = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.25),
    );

    _imageOffset = Tween<Offset>(
      begin: const Offset(-0.3, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.2, 0.45)),
    );

    _fadeImage = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 0.45),
    );

    _profileOffset = Tween<Offset>(
      begin: const Offset(0.3, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.35, 0.6)),
    );

    _fadeProfile = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.35, 0.6),
    );

    _fadeStatus = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.55, 0.8),
    );

    _badgeOffset = Tween<Offset>(
      begin: const Offset(0.3, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.75, 1.0)),
    );

    _fadeBadge = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.75, 1.0),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20.w, top: 12.h, right: 20.w),
            child: Column(
              children: [
                SlideTransition(
                  position: _weatherOffset,
                  child: FadeTransition(
                    opacity: _fadeWeather,
                    child: Row(children: const [WeatherWidget(), Spacer()]),
                  ),
                ),
                SizedBox(height: 40.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: SlideTransition(
                        position: _imageOffset,
                        child: FadeTransition(
                          opacity: _fadeImage,
                          child: SizedBox(
                            height: 280.h,
                            child: const CarImageWidget(),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: SlideTransition(
                        position: _profileOffset,
                        child: FadeTransition(
                          opacity: _fadeProfile,
                          child: const CarProfileCard(),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                FadeTransition(
                  opacity: _fadeStatus,
                  child: const CarStatusWidget(),
                ),
                SizedBox(height: 120.h),
              ],
            ),
          ),

          // 🔽 알림 뱃지: 마지막에 오른쪽 → 왼쪽 등장
          Positioned(
            top: 12.h,
            right: 0,
            child: SlideTransition(
              position: _badgeOffset,
              child: FadeTransition(
                opacity: _fadeBadge,
                child: NotificationBadges(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
