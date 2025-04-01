import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CarStatusWidget extends StatelessWidget {
  const CarStatusWidget({super.key});

  final List<Map<String, dynamic>> statusData = const [
    {'icon': 'icon_tacometer.png', 'label': '총 주행거리', 'value': '50,000', 'unit': 'km'},
    {'icon': 'icon_gas.png', 'label': '연비', 'value': '5.0', 'unit': 'km/L'},
    {'icon': 'icon_gas.png', 'label': '연료', 'value': '12.5', 'unit': 'L', 'isFuel': true, 'fuelPercentage': 0.1},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              '2025. 3. 4',
              style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
            ),
            SizedBox(width: 8.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 0.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: Colors.grey, width: 1.w),
              ),
              child: Text(
                '업데이트됨',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey[600],
                ),
              ),
            ),
            SizedBox(width: 10.w),
          ],
        ),
        SizedBox(height: 10.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: statusData.map((data) {
            return SizedBox(
              width: 100.w,
              child: _buildStatusCard(
                icon: data['isFuel'] == true
                    ? _buildFuelGauge(data['fuelPercentage'] ?? 0.0)
                    : Image.asset('assets/images/icons/${data['icon']}', width: 24.sp),
                label: data['label'],
                value: data['value'],
                unit: data['unit'],
                isFuel: data['isFuel'] ?? false,
                fuelPercentage: data['fuelPercentage'] ?? 0.0,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildFuelGauge(double fuelPercentage) {
    return SizedBox(
      width: 52.w,
      height: 25.h,
      child: Stack(
        children: [
          // 배터리 모양 외곽
          Container(
            width: 50.w,
            height: 30.w,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
          // 연료 상태 게이지
          Positioned(
            left: 3,
            top: 3,
            bottom: 3,
            child: Container(
              width: (fuelPercentage) * 44.w, // fuelPercentage에 맞게 길이 조정
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: fuelPercentage < 0.33
                      ? [
                          Colors.red.withOpacity(0.7),
                          Colors.red,
                        ]
                      : fuelPercentage < 0.66
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
          // 배터리 모양 오른쪽 끝
          Positioned(
            right: 0.w,
            top: 8.h,
            child: Container(
              width: 3.w,
              height: 10.h,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(1.r),
                  bottomRight: Radius.circular(1.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard({
    required Widget icon,
    required String label,
    required String value,
    required String unit,
    bool isFuel = false,
    double fuelPercentage = 0.0,
  }) {
    return Container(
      padding: EdgeInsets.all(10.w),
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
          SizedBox(
            height: 30.h,
            child: Align(
              alignment: Alignment.centerLeft,
              child: icon,
            ),
          ),
          SizedBox(height: 30.h),
          Text(
            label,
            style: TextStyle(fontSize: 11.sp, color: Colors.black)
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Text(
                value,
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)
              ),
              SizedBox(width: 2.w),
              Text(
                unit,
                style: TextStyle(fontSize: 11.sp, color: Colors.black)
              ),
            ],
          ),
        ],
      ),
    );
  }
}
