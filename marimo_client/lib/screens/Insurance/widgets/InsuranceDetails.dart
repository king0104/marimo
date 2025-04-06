import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class InsuranceDetails extends StatelessWidget {
  final Map<String, dynamic> insuranceInfo;

  const InsuranceDetails({
    super.key,
    required this.insuranceInfo,
  });

  String _formatDate(String? dateString) {
    if (dateString == null) return '-';
    final date = DateTime.parse(dateString);
    return DateFormat('yyyy.MM.dd').format(date);
  }

  String _formatNumber(num? number) {
    if (number == null) return '-';
    return NumberFormat('#,###').format(number);
  }

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
          _buildDetailRow(
            '최초 주행거리 등록일', 
            _formatDate(insuranceInfo['distanceRegistrationDate'])
          ),
          SizedBox(height: 16.h),
          _buildDetailRow(
            '보험 만기일', 
            _formatDate(insuranceInfo['endDate'])
          ),
          SizedBox(height: 16.h),
          _buildDetailRow(
            '최초 등록 주행거리', 
            '${_formatNumber(insuranceInfo['registeredDistance'])}km'
          ),
          SizedBox(height: 16.h),
          _buildDetailRow(
            '현재 총 주행거리', 
            '${_formatNumber(insuranceInfo['totalDistance'])}km'
          ),
          SizedBox(height: 16.h),
          _buildDetailRow(
            '계산 주행거리', 
            '${_formatNumber(insuranceInfo['calculatedDistance'])}km'
          ),
          SizedBox(height: 16.h),
          _buildDetailRow(
            '일 평균 주행거리', 
            '${_formatNumber(insuranceInfo['dailyAverageDistance'])}km/일'
          ),
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