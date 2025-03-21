import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CarStatusWidget extends StatelessWidget {
  const CarStatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 업데이트 정보
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            margin: EdgeInsets.only(bottom: 16.h),
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '2025.3.4',
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                ),
                SizedBox(width: 8.w),
                Text(
                  '업데이트됨',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFF4888FF),
                  ),
                ),
              ],
            ),
          ),
        ),
        // 상태 카드들
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatusCard(
              icon: Icons.speed,
              label: '총 주행거리',
              value: '50,000',
              unit: 'km',
            ),
            _buildStatusCard(
              icon: Icons.local_gas_station,
              label: '연비',
              value: '5.0',
              unit: 'km/L',
            ),
            _buildStatusCard(
              icon: Icons.battery_charging_full,
              label: '연료',
              value: '12.5',
              unit: 'L',
              isFuel: true,
              fuelPercentage: 0.3, 
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusCard({
    required IconData icon,
    required String label,
    required String value,
    required String unit,
    bool isFuel = false,
    double? fuelPercentage,
  }) {
    return Container(
      width: 100.w,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isFuel) 
            Icon(icon, size: 24.w, color: Colors.grey[600])
          else
            Container(
              width: 52.w,  // 배터리 전체 너비 증가
              height: 25.w,
              child: Stack(
                children: [
                  // 배터리 외곽선
                  Container(
                    width: 50.w,
                    height: 30.w,  // +극을 제외한 너비
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey[600]!,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                  // 배터리 게이지
                  Positioned(
                    left: 3,
                    top: 3,
                    bottom: 3,
                    child: Container(
                      width: (fuelPercentage ?? 0.0) * 44.w,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: (fuelPercentage ?? 0.0) < 0.33 
                            ? [
                                Colors.red.withOpacity(0.7),
                                Colors.red,
                              ] 
                            : (fuelPercentage ?? 0.0) < 0.66
                              ? [
                                  Colors.orange.withOpacity(0.7),
                                  Colors.orange,
                                ]
                              : [
                                  const Color(0xFF9DBFFF),
                                  const Color(0xFF4888FF),
                                ],
                        ),
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                  ),
                  // 배터리 +극
                  Positioned(
                    right: 0.w,
                    top: 10.h,
                    child: Container(
                      width: 3.w,
                      height: 10.h,
                      decoration: BoxDecoration(
                        color: Colors.grey[600],
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(1.r),
                          bottomRight: Radius.circular(1.r),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Text(
                value,
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 4.w),
              Text(
                unit,
                style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
