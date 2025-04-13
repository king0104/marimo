import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marimo_client/utils/warning_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationBadges extends StatefulWidget {
  const NotificationBadges({super.key});

  @override
  _NotificationBadgesState createState() => _NotificationBadgesState();
}

class _NotificationBadgesState extends State<NotificationBadges>
    with TickerProviderStateMixin {
  late AnimationController _warningAnimationController;
  late AnimationController _infoAnimationController;
  late Animation<Offset> _warningSlideAnimation;
  late Animation<Offset> _infoSlideAnimation;

  List<Map<String, dynamic>> notifications = [];

  @override
  void initState() {
    super.initState();
    _loadWarnings();

    _warningAnimationController = AnimationController(
      duration: const Duration(milliseconds: 8000),
      vsync: this,
    );
    _warningSlideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1.5, 0.0),
    ).animate(
      CurvedAnimation(
        parent: _warningAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _infoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 8000),
      vsync: this,
    );
    _infoSlideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1.5, 0.0),
    ).animate(
      CurvedAnimation(
        parent: _infoAnimationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _warningAnimationController.dispose();
    _infoAnimationController.dispose();
    super.dispose();
  }

  Future<void> _loadWarnings() async {
    final infoWarnings = await WarningStorage.loadWarnings();
    final prefs = await SharedPreferences.getInstance();
    final dtcCodes = prefs.getStringList('stored_dtc_codes') ?? [];

    final infoList = infoWarnings.map((e) {
      return {
        'id': e['title'],
        'color': const Color(0xFF4888FF),
        'icon': Icons.info_rounded,
        'content1': e['title'],
        'content2': e['description'],
        'source': 'info',
      };
    });

    final dtcList = dtcCodes.map((code) {
      return {
        'id': code,
        'color': Colors.red,
        'icon': Icons.warning_rounded,
        'content1': 'DTC 코드 감지: $code',
        'content2': '차량 진단 코드 $code가 감지되었습니다. 정비가 필요할 수 있어요.',
        'source': 'dtc',
      };
    });

    setState(() {
      notifications = [...infoList, ...dtcList];
    });
  }

  void _removeNotification(String id, Color notificationType) async {
    setState(() {
      notifications.removeWhere((item) => item['id'] == id);
    });

    final prefs = await SharedPreferences.getInstance();
    final isInfo = notificationType == const Color(0xFF4888FF);

    if (isInfo) {
      await WarningStorage.deleteWarningByTitle(id);
    } else {
      final dtcCodes = prefs.getStringList('stored_dtc_codes') ?? [];
      dtcCodes.removeWhere((code) => code == id);
      await prefs.setStringList('stored_dtc_codes', dtcCodes);
    }

    if (notifications.where((n) => n['color'] == notificationType).isEmpty) {
      if (context.mounted) Navigator.of(context).pop();
      if (notificationType == Colors.red) {
        _warningAnimationController.forward();
      } else {
        _infoAnimationController.forward();
      }
    }
  }

  void _showNotifications(BuildContext context, Color filterColor) {
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
                            children:
                                notifications
                                    .where((n) => n['color'] == filterColor)
                                    .map(
                                      (notification) => Padding(
                                        padding: EdgeInsets.only(bottom: 8.h),
                                        child: Dismissible(
                                          key: Key(notification['id']),
                                          direction:
                                              DismissDirection.horizontal,
                                          onDismissed:
                                              (direction) =>
                                                  _removeNotification(
                                                    notification['id'],
                                                    filterColor,
                                                  ),
                                          background: _buildDismissBackground(
                                            Alignment.centerLeft,
                                          ),
                                          secondaryBackground:
                                              _buildDismissBackground(
                                                Alignment.centerRight,
                                              ),
                                          child: _buildNotificationCard(
                                            notification,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
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

  Widget _buildDismissBackground(Alignment alignment) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12.r),
      ),
      alignment: alignment,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Icon(Icons.delete, color: Colors.white, size: 24.w),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> n) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              color: n['color'],
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(n['icon'], color: Colors.white, size: 20.w),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  n['content1'],
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  n['content2'],
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, size: 24.w, color: Colors.white),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final warningCount =
        notifications.where((n) => n['color'] == Colors.red).length;
    final infoCount =
        notifications
            .where((n) => n['color'] == const Color(0xFF4888FF))
            .length;

    return Transform.translate(
      offset: Offset(15.w, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (warningCount > 0)
            AnimatedSlide(
              duration: const Duration(milliseconds: 1000),
              curve: Curves.easeInOut,
              offset: Offset.zero,
              child: GestureDetector(
                onTap: () => _showNotifications(context, Colors.red),
                child: _buildBadge(
                  warningCount,
                  Colors.red,
                  Icons.warning_rounded,
                ),
              ),
            ),
          if (infoCount > 0)
            Padding(
              padding: EdgeInsets.only(top: 8.h),
              child: AnimatedSlide(
                duration: const Duration(milliseconds: 1000),
                curve: Curves.easeInOut,
                offset: Offset.zero,
                child: GestureDetector(
                  onTap:
                      () =>
                          _showNotifications(context, const Color(0xFF4888FF)),
                  child: _buildBadge(
                    infoCount,
                    const Color(0xFF4888FF),
                    Icons.info_rounded,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBadge(int count, Color color, IconData icon) {
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
