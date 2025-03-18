import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CarProfileCard extends StatelessWidget {
  const CarProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileItem('모델명', '현대 팰리세이드'),
          SizedBox(height: 8.h),
          _buildProfileItem('차대번호', 'KNAGM4AD3CS034567'),
          SizedBox(height: 8.h),
          _buildProfileItem('연료 타입', '가솔린'),
          SizedBox(height: 8.h),
          _buildProfileItem('마지막 점검', '차계부 내역 없음'),
        ],
      ),
    );
  }

  Widget _buildProfileItem(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(width: 12.w),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}