import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatusInfoCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon; // ✅ 아이콘 추가

  const StatusInfoCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon, // ✅ 아이콘 필수값으로 추가
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.transparent, // ✅ 배경을 투명하게 설정
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 18.sp, color: const Color(0xFF4888FF)),
              SizedBox(width: 8.w),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF7E7E7E),
                ),
              ),
            ],
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF000000),
            ),
          ),
        ],
      ),
    );
  }
}
