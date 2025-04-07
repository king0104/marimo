import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marimo_client/providers/obd_polling_provider.dart';
import 'package:marimo_client/theme.dart';
import 'package:marimo_client/utils/toast.dart';
import 'package:provider/provider.dart';

class CommonBottomNavigationBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CommonBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<CommonBottomNavigationBar> createState() =>
      _CommonBottomNavigationBarState();
}

class _CommonBottomNavigationBarState extends State<CommonBottomNavigationBar> {
  bool isConnecting = false;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ObdPollingProvider>(context);
    final isConnected = provider.isConnected;

    return Container(
      color: Colors.transparent,
      margin: EdgeInsets.only(bottom: 20, left: 20.w, right: 20.w),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 70,
            width: 325.w,
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(50.r),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50.r),
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.transparent,
                currentIndex: widget.currentIndex,
                onTap: widget.onTap,
                selectedItemColor: brandColor,
                unselectedItemColor: iconColor,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                items: [
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      'assets/images/icons/icon_home.svg',
                      width: 20.sp,
                      height: 20.sp,
                    ),
                    activeIcon: SvgPicture.asset(
                      'assets/images/icons/icon_home.svg',
                      width: 20.sp,
                      height: 20.sp,
                      color: brandColor,
                    ),
                    label: "",
                  ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      'assets/images/icons/icon_car.svg',
                      width: 20.sp,
                      height: 20.sp,
                    ),
                    activeIcon: SvgPicture.asset(
                      'assets/images/icons/icon_car.svg',
                      width: 20.sp,
                      height: 20.sp,
                      color: brandColor,
                    ),
                    label: "",
                  ),
                  BottomNavigationBarItem(
                    icon: SizedBox(height: 24.sp),
                    label: "",
                  ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      'assets/images/icons/icon_map.svg',
                      width: 20.sp,
                      height: 20.sp,
                    ),
                    activeIcon: SvgPicture.asset(
                      'assets/images/icons/icon_map.svg',
                      width: 20.sp,
                      height: 20.sp,
                      color: brandColor,
                    ),
                    label: "",
                  ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      'assets/images/icons/icon_my.svg',
                      width: 20.sp,
                      height: 20.sp,
                    ),
                    activeIcon: SvgPicture.asset(
                      'assets/images/icons/icon_my.svg',
                      width: 20.sp,
                      height: 20.sp,
                      color: brandColor,
                    ),
                    label: "",
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: -10.h,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: () async {
                  if (provider.isConnected || isConnecting) return;

                  setState(() => isConnecting = true);
                  showToast(context, 'OBD-II 연결 중...', icon: Icons.sync);

                  try {
                    await provider.connectAndStartPolling(context);

                    if (provider.isConnected) {
                      showToast(
                        context,
                        '차량 OBD-II 스캐너 연결 완료',
                        icon: Icons.check_circle,
                        type: 'success',
                      );
                    } else {
                      showToast(
                        context,
                        '응답 없음\n기기를 다시 확인해주세요.',
                        icon: Icons.warning_amber,
                        type: 'error',
                      );
                    }
                  } on TimeoutException {
                    showToast(
                      context,
                      '연결 시간 초과\n다시 시도해주세요.',
                      icon: Icons.timer_off,
                      type: 'error',
                    );
                  } on PlatformException catch (e) {
                    if (e.message?.contains("read failed") == true) {
                      showToast(
                        context,
                        '장치 응답 없음\nOBD가 차량에 꽂혀 있는지 확인해주세요.',
                        icon: Icons.usb_off,
                        type: 'error',
                      );
                    } else {
                      showToast(
                        context,
                        '시스템 오류 발생\n${e.message}',
                        icon: Icons.error_outline,
                        type: 'error',
                      );
                    }
                    print('PlatformException: $e');
                  } on Exception catch (e) {
                    if (e.toString().contains("OBD 기기를 찾을 수 없습니다")) {
                      showToast(
                        context,
                        'OBD 기기 없음\n기기를 페어링했는지 확인해주세요.',
                        icon: Icons.bluetooth_disabled,
                        type: 'error',
                      );
                    } else {
                      showToast(
                        context,
                        '연결 실패\n알 수 없는 오류가 발생했습니다.',
                        icon: Icons.error,
                        type: 'error',
                      );
                    }
                    print('에러: $e');
                  } finally {
                    setState(() => isConnecting = false);
                  }
                },

                child: Container(
                  width: 56.w,
                  height: 56.w,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF9DBFFF),
                        const Color(0xFF4888FF),
                      ],
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
                  child: Center(
                    child:
                        isConnecting
                            ? SizedBox(
                              width: 24.w,
                              height: 24.w,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                color: white,
                              ),
                            )
                            : Image.asset(
                              isConnected
                                  ? 'assets/images/icons/connected.png'
                                  : 'assets/images/icons/connect.png',
                              width: 28.sp,
                            ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
