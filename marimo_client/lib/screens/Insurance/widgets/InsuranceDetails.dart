import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InsuranceDetails extends StatelessWidget {
  const InsuranceDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildDetailRow('최초 주행거리 등록일', '2024.01.01'),
          SizedBox(height: 16.h),
          _buildDetailRow('보험 만기일', '2024.12.31'),
          SizedBox(height: 16.h),
          _buildDetailRow('최초 등록 주행거리', '21,000km'),
          SizedBox(height: 16.h),
          _buildDetailRow('현재 총 주행거리', '24,600km'),
          SizedBox(height: 16.h),
          _buildDetailRow('계산 주행거리', '3,600km'),
          SizedBox(height: 16.h),
          _buildDetailRow('월 평균 환산 주행거리', '30km/월'),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,

            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
} 