import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationBadges extends StatelessWidget {
  const NotificationBadges({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildBadge(
          count: 4,
          color: Colors.red,
          icon: Icons.warning_rounded,
        ),
        SizedBox(width: 8.w),
        _buildBadge(
          count: 15,
          color: Colors.blue,
          icon: Icons.info_rounded,
        ),
      ],
    );
  }

  Widget _buildBadge({
    required int count,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20.w),
          SizedBox(width: 4.w),
          Text(
            count.toString(),
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }
}