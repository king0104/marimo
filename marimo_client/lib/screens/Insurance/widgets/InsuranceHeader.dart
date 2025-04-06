import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InsuranceHeader extends StatelessWidget {
  final bool isRegistered;
  
  const InsuranceHeader({
    super.key,
    this.isRegistered = true,  // 보험 등록 여부
  });

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/images/insurance/image_kb.png',
                    width: 32.w,
                    height: 32.w,
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    'KB 손해보험',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {},
                child: Row(
                  children: [
                    Text(
                      '규정 보기',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14.sp,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      size: 20.w,
                      color: Colors.grey[600],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          Column(
            children: [
              Text(
                '현재 할인율',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(height: 0.h),
              Text(
                '35%',
                style: TextStyle(
                  fontSize: 36.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '다음 구간: 30%',
                style: TextStyle(
                  fontSize: 14.sp,
                ),
              ),
              Text(
                '(~4,000km 이하)',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          LinearProgressIndicator(
            value: 0.35,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4888FF)),
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '0km',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12.sp,
                ),
              ),
              Text(
                '2,000km',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
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

  Widget _buildTipSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '💡 관리 팁',
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
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFFF4E4E).withOpacity(0.05),
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: const Color(0xFFFF4E4E)),
          ),
          child: Text(
            '400km 이상 운행하면 할인율이 낮아져요!',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
