import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marimo_client/commons/chatbot.dart';
import 'package:marimo_client/screens/Insurance/InsuranceScreen.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CommonAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CommonAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<CommonAppBar> createState() => _CommonAppBarState();
}

class _CommonAppBarState extends State<CommonAppBar> {
  final List<Map<String, dynamic>> notifications = [
    {
      'id': '1',
      'type': 'battery',
      'icon': Icons.battery_alert,
      'color': Colors.red,
      'content1': '배터리 방전이 우려됩니다.',
      'content2': '차량 상태를 확인해주세요.',
      'actionText': '모니터링 확인하기',
      'action': (BuildContext context) {
        Navigator.pop(context);
        // TODO: 네비게이션 두 번째 탭으로 이동
      },
    },
    {
      'id': '2',
      'type': 'insurance',
      'icon': Icons.car_crash,
      'color': const Color(0xFF4888FF),
      'content1': '마일리지 보험 갱신 시기입니다.',
      'content2': '현재 주행거리를 확인해주세요.',
      'actionText': '마일리지 구간 확인하기',
      'action': (BuildContext context) {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const InsuranceScreen()),
        );
      },
    },
    {
      'id': '3',
      'type': 'fuel',
      'icon': Icons.local_gas_station,
      'color': Colors.orange,
      'content1': '연료가 부족합니다.',
      'content2': '가까운 주유소를 확인해주세요.',
      'actionText': '주유소 찾기',
      'action': (BuildContext context) {
        Navigator.pop(context);
        // TODO: 네비게이션 네 번째 탭으로 이동
      },
    },
  ];

  void _removeNotification(String id) {
    setState(() {
      notifications.removeWhere((item) => item['id'] == id);
    });
  }

  void _showNotifications(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            insetPadding: EdgeInsets.zero,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.transparent,
                child: Column(
                  children: [
                    SizedBox(height: 100.h),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Column(
                            children: [
                              ...notifications.map((notification) {
                                return GestureDetector(
                                  onTap: () {},
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: 8.h),
                                    child: Dismissible(
                                      key: Key(notification['id']),
                                      direction: DismissDirection.horizontal,
                                      onDismissed:
                                          (direction) => _removeNotification(
                                            notification['id'],
                                          ),
                                      background: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.red.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(
                                            12.r,
                                          ),
                                        ),
                                        alignment: Alignment.centerLeft,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 20.w,
                                        ),
                                        child: const Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                        ),
                                      ),
                                      secondaryBackground: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.red.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(
                                            12.r,
                                          ),
                                        ),
                                        alignment: Alignment.centerRight,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 20.w,
                                        ),
                                        child: const Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                        ),
                                      ),
                                      child: Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.all(16.w),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF1C1C1E),
                                          borderRadius: BorderRadius.circular(
                                            12.r,
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.all(6.w),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        notification['color'],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8.r,
                                                        ),
                                                  ),
                                                  child: Icon(
                                                    notification['icon'],
                                                    color: Colors.white,
                                                    size: 20.w,
                                                  ),
                                                ),
                                                SizedBox(width: 12.w),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        notification['content1'],
                                                        style: TextStyle(
                                                          fontSize: 14.sp,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      SizedBox(height: 4.h),
                                                      Text(
                                                        notification['content2'],
                                                        style: TextStyle(
                                                          fontSize: 14.sp,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 12.h),
                                            GestureDetector(
                                              onTap:
                                                  () => notification['action'](
                                                    context,
                                                  ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    notification['actionText'],
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14.sp,
                                                    ),
                                                  ),
                                                  Icon(
                                                    Icons.chevron_right,
                                                    size: 20.w,
                                                    color: Colors.white,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                              SizedBox(height: 100.h),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
      ),
      elevation: 0,
      leadingWidth: 70.w,
      leading: Padding(
        padding: EdgeInsets.only(left: 0.w),
        child: Image.asset('assets/images/logo/marimo_logo.png', width: 30.w),
      ),
      actions: [
        // 마이크 아이콘 클릭 시 Chatbot UI를 모달로 띄움
        IconButton(
          icon: Icon(Icons.mic, size: 24.w),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              builder: (context) => const Chatbot(),
            );
          },
        ),
        Stack(
          children: [
            IconButton(
              icon: Icon(Icons.notifications, size: 24.w),
              onPressed: () => _showNotifications(context),
            ),
            if (notifications.isNotEmpty)
              Positioned(
                top: 10.h,
                right: 10.w,
                child: Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
        SizedBox(width: 8.w),
      ],
    );
  }
}
