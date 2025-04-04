import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marimo_client/providers/home_animation_provider.dart';
import 'package:marimo_client/providers/obd_polling_provider.dart';
import 'package:provider/provider.dart';
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

  late Animation<double> _fadeStatus;
  late Animation<double> _fadeProfile;
  late Animation<double> _badgeScale;

  @override
  void initState() {
    super.initState();

    final shouldAnimate =
        Provider.of<HomeAnimationProvider>(
          context,
          listen: false,
        ).shouldAnimate;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    );

    if (shouldAnimate) {
      _controller.forward();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<HomeAnimationProvider>(
          context,
          listen: false,
        ).disableAnimation();
      });
    } else {
      _controller.value = 1.0;
    }

    _weatherOffset = Tween<Offset>(
      begin: const Offset(-1.2, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.25, curve: Curves.easeOutCubic),
      ),
    );

    _imageOffset = Tween<Offset>(
      begin: const Offset(-1.0, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.45, curve: Curves.easeOut),
      ),
    );

    _profileOffset = Tween<Offset>(
      begin: const Offset(0.8, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.55, curve: Curves.fastOutSlowIn),
      ),
    );

    _fadeProfile = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.3, 0.55),
    );

    _fadeStatus = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.45, 0.7, curve: Curves.easeIn),
    );

    _badgeOffset = Tween<Offset>(
      begin: const Offset(1.2, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.75, 1.0, curve: Curves.easeOutBack),
      ),
    );

    _badgeScale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 1.0, curve: Curves.easeOutBack),
      ),
    );
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
                  child: Row(children: const [WeatherWidget(), Spacer()]),
                ),
                SizedBox(height: 40.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: SlideTransition(
                        position: _imageOffset,
                        child: SizedBox(
                          height: 280.h,
                          child: const CarImageWidget(),
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
          Positioned(
            top: 12.h,
            right: 0,
            child: SlideTransition(
              position: _badgeOffset,
              child: ScaleTransition(
                scale: _badgeScale,
                child: const NotificationBadges(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
