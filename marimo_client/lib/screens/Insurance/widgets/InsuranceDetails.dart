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
          _buildDetailRow('등록 최초 주행거리', '21,000km'),
          SizedBox(height: 16.h),
          _buildDetailRow('현재 총 주행거리', '24,600km'),
          SizedBox(height: 16.h),
          _buildDetailRow('계산 주행거리', '3,600km'),
          SizedBox(height: 16.h),
          _buildDetailRow('월 평균 환산 주행거리', '30km/월'),
          SizedBox(height: 24.h),
          _buildTipSection(),
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
            color: Colors.grey[600],
          ),
        ),
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

  Widget _buildTipSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.lightbulb_outline, size: 20.w, color: Colors.amber),
            SizedBox(width: 8.w),
            Text(
              '관리 팁',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: const Color(0xFFFFEFEF),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Text(
            '400km 이상 운행하면 할인율이 낮아져요!',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.red[400],
            ),
          ),
        ),
      ],
    );
  }
} 