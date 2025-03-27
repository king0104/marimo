import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationBadges extends StatefulWidget {
  const NotificationBadges({super.key});

  @override
  _NotificationBadgesState createState() => _NotificationBadgesState();
}

class _NotificationBadgesState extends State<NotificationBadges> with TickerProviderStateMixin {
  late AnimationController _warningAnimationController;
  late AnimationController _infoAnimationController;
  late Animation<Offset> _warningSlideAnimation;
  late Animation<Offset> _infoSlideAnimation;

  List<Map<String, dynamic>> notifications = [
    // 경고 알림 15개
    {
      'id': '1',
      'color': Colors.red,
      'icon': Icons.warning_rounded,
      'content1': '현재 연료량이 10% 남았습니다.',
      'content2': '충전이 필요합니다.',
    },
    {
      'id': '2',
      'color': Colors.red,
      'icon': Icons.warning_rounded,
      'content1': '배터리 사용량이 높습니다.',
      'content2': '배터리 절약 모드를 고려해보세요.',
    },
    {
      'id': '3',
      'color': Colors.red,
      'icon': Icons.warning_rounded,
      'content1': '타이어 공기압이 낮습니다.',
      'content2': '점검이 필요합니다.',
    },
    {
      'id': '4',
      'color': Colors.red,
      'icon': Icons.warning_rounded,
      'content1': '엔진 오일 교체 시기입니다.',
      'content2': '서비스 센터 방문을 추천드립니다.',
    },
    {
      'id': '5',
      'color': Colors.red,
      'icon': Icons.warning_rounded,
      'content1': '브레이크 패드 마모가 심합니다.',
      'content2': '교체가 필요합니다.',
    },
    {
      'id': '6',
      'color': Colors.red,
      'icon': Icons.warning_rounded,
      'content1': '냉각수 온도가 높습니다.',
      'content2': '점검이 필요합니다.',
    },
    {
      'id': '7',
      'color': Colors.red,
      'icon': Icons.warning_rounded,
      'content1': '와이퍼액이 부족합니다.',
      'content2': '보충이 필요합니다.',
    },
    {
      'id': '8',
      'color': Colors.red,
      'icon': Icons.warning_rounded,
      'content1': '에어컨 필터 교체 시기입니다.',
      'content2': '교체를 추천드립니다.',
    },
    {
      'id': '9',
      'color': Colors.red,
      'icon': Icons.warning_rounded,
      'content1': '변속기 오일 온도가 높습니다.',
      'content2': '점검이 필요합니다.',
    },
    {
      'id': '10',
      'color': Colors.red,
      'icon': Icons.warning_rounded,
      'content1': '배터리 전압이 낮습니다.',
      'content2': '충전이 필요합니다.',
    },
    {
      'id': '11',
      'color': Colors.red,
      'icon': Icons.warning_rounded,
      'content1': '연료 필터 교체 시기입니다.',
      'content2': '교체를 추천드립니다.',
    },
    {
      'id': '12',
      'color': Colors.red,
      'icon': Icons.warning_rounded,
      'content1': '브레이크 오일이 부족합니다.',
      'content2': '보충이 필요합니다.',
    },
    {
      'id': '13',
      'color': Colors.red,
      'icon': Icons.warning_rounded,
      'content1': '파워스티어링 오일이 부족합니다.',
      'content2': '점검이 필요합니다.',
    },
    {
      'id': '14',
      'color': Colors.red,
      'icon': Icons.warning_rounded,
      'content1': '서스펜션 상태가 좋지 않습니다.',
      'content2': '점검을 추천드립니다.',
    },
    {
      'id': '15',
      'color': Colors.red,
      'icon': Icons.warning_rounded,
      'content1': '타이밍 벨트 교체 시기입니다.',
      'content2': '서비스 센터 방문을 추천드립니다.',
    },
    // 정보 알림
    {
      'id': '16',
      'color': const Color(0xFF4888FF),
      'icon': Icons.info_rounded,
      'content1': '차량 점검 시간입니다.',
      'content2': '정기 점검을 예약하세요.',
    }
  ];

  @override
  void initState() {
    super.initState();
    // 경고 알림용 애니메이션 (속도 조절)
    _warningAnimationController = AnimationController(
      duration: const Duration(milliseconds: 8000),  // 속도 늦춤
      vsync: this,
    );
    _warningSlideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1.5, 0.0),
    ).animate(CurvedAnimation(
      parent: _warningAnimationController,
      curve: Curves.easeInOut,  // 부드러운 효과로 변경
    ));

    // 정보 알림용 애니메이션 (속도 조절)
    _infoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 8000),  // 속도 늦춤
      vsync: this,
    );
    _infoSlideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1.5, 0.0),
    ).animate(CurvedAnimation(
      parent: _infoAnimationController,
      curve: Curves.easeInOut,  // 부드러운 효과로 변경
    ));
  }

  @override
  void dispose() {
    _warningAnimationController.dispose();
    _infoAnimationController.dispose();
    super.dispose();
  }

  void _removeNotification(String id, Color notificationType) {
    setState(() {
      notifications.removeWhere((item) => item['id'] == id);
      
      // 현재 타입의 알림 개수 확인
      int currentTypeCount = notifications.where((n) => n['color'] == notificationType).length;
      
      if (currentTypeCount == 0) {
        // 해당 타입의 알림이 모두 삭제되면 다이얼로그 닫기
        Navigator.of(context).pop();
        
        // 해당 타입에 맞는 애니메이션 컨트롤러 실행
        if (notificationType == Colors.red) {
          _warningAnimationController.forward();
        } else {
          _infoAnimationController.forward();
        }
      }
    });
  }

  void _showNotifications(BuildContext context, Color filterColor) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: EdgeInsets.zero,
        child: GestureDetector(  // 빈 공간 터치 시 닫기 위한 래퍼
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.transparent,
            child: Column(
              children: [
                SizedBox(height: 100.h),  // 상단 여백
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        children: [
                          ...notifications
                              .where((n) => n['color'] == filterColor)
                              .map((notification) {
                            return GestureDetector(  // 알림 카드 터치 이벤트 방지
                              onTap: () {},  // 이벤트 가로채기
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 8.h),
                                child: Dismissible(
                                  key: Key(notification['id']),
                                  direction: DismissDirection.horizontal,
                                  onDismissed: (direction) => 
                                      _removeNotification(notification['id'], filterColor),  // filterColor 추가
                                  background: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                                    child: Icon(Icons.delete, color: Colors.white, size: 24.w),
                                  ),
                                  secondaryBackground: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    alignment: Alignment.centerRight,
                                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                                    child: Icon(Icons.delete, color: Colors.white, size: 24.w),
                                  ),
                                  child: Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.all(16.w),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1C1C1E),
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,  // 가운데 정렬 추가
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(6.w),
                                              decoration: BoxDecoration(
                                                color: notification['color'],
                                                borderRadius: BorderRadius.circular(8.r),
                                              ),
                                              child: Icon(
                                                notification['icon'],
                                                color: Colors.white,
                                                size: 20.w
                                              ),
                                            ),
                                            SizedBox(width: 12.w),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.center,  // 내부 Column도 세로 중앙 정렬
                                                children: [
                                                  Text(
                                                    notification['content1'],
                                                    style: TextStyle(
                                                      fontSize: 14.sp,
                                                      fontWeight: FontWeight.w500,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  SizedBox(height: 4.h),
                                                  Text(
                                                    notification['content2'],
                                                    style: TextStyle(
                                                      fontSize: 14.sp,
                                                      fontWeight: FontWeight.w500,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                                                                    GestureDetector(
                                          onTap: () {
                                            // TODO: 주유소 찾기 화면으로 이동
                                          },
                                          child: Icon(
                                            Icons.chevron_right,
                                            size: 24.w,
                                            color: Colors.white,
                                          ),
                                        ),
                                          ],
                                        ),
                                        
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                          SizedBox(height: 100.h),  // 하단 여백
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
    int warningCount = notifications.where((n) => n['color'] == Colors.red).length;
    int infoCount = notifications.where((n) => n['color'] == const Color(0xFF4888FF)).length;

    return Transform.translate(
      offset: Offset(15.w, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          AnimatedSlide(
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeInOut,
            offset: warningCount > 0 ? Offset.zero : const Offset(1.5, 0),
            child: GestureDetector(
              onTap: () => _showNotifications(context, Colors.red),
              child: _buildBadge(
                count: warningCount,
                color: Colors.red,
                icon: Icons.warning_rounded,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          AnimatedSlide(
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeInOut,
            offset: infoCount > 0 ? Offset.zero : const Offset(1.5, 0),
            child: GestureDetector(
              onTap: () => _showNotifications(context, const Color(0xFF4888FF)),
              child: _buildBadge(
                count: infoCount,
                color: const Color(0xFF4888FF),
                icon: Icons.info_rounded,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge({
    required int count,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      width: 85.w,
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color, width: 1),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 30.w,
            height: 30.w,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, color: Colors.white, size: 20.w),
          ),
          Positioned(
            top: -4.h,
            right: 20.w,
            child: Container(
              width: 22.w,
              height: 22.w,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: color, width: 1),
              ),
              child: Center(
                child: Text(
                  count.toString(),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
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