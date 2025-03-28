import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CarStatusWidget extends StatefulWidget {
  const CarStatusWidget({super.key});

  @override
  _CarStatusWidgetState createState() => _CarStatusWidgetState();
}

class _CarStatusWidgetState extends State<CarStatusWidget> {
  final PageController _pageController = PageController();

  final List<Map<String, dynamic>> statusData = [
    {'icon': 'icon_tacometer.png', 'label': '총 주행거리', 'value': '50,000', 'unit': 'km'},
    {'icon': 'icon_gas.png', 'label': '연비', 'value': '5.0', 'unit': 'km/L'},
    {'icon': 'icon_gas.png', 'label': '연료', 'value': '12.5', 'unit': 'L', 'isFuel': true, 'fuelPercentage': 0.1}, // 연료 항목
    {'icon': 'icon_gas.png', 'label': '엔진 상태', 'value': '정상', 'unit': ''},
    {'icon': 'icon_gas.png', 'label': '배터리', 'value': '80%', 'unit': '', 'isFuel': false}, // 배터리 항목
    {'icon': 'icon_gas.png', 'label': '타이어 압력', 'value': '32', 'unit': 'psi'},
    {'icon': 'icon_gas.png', 'label': '브레이크 패드', 'value': '70%', 'unit': ''},
    {'icon': 'icon_gas.png', 'label': '오일 상태', 'value': '정상', 'unit': ''},
    {'icon': 'icon_gas.png', 'label': '냉각수', 'value': '적정', 'unit': ''},
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
        SizedBox(
          height: 120.h,
          child: PageView.builder(
            controller: _pageController,
            itemCount: (statusData.length / 3).ceil(),
            onPageChanged: (index) {
              setState(() {});
            },
            itemBuilder: (context, index) {
              int startIndex = index * 3;
              int endIndex = (index + 1) * 3;
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: statusData.sublist(startIndex, endIndex.clamp(0, statusData.length)).map((data) {
                  return _buildStatusCard(
                    icon: data['isFuel'] == true
                        ? _buildFuelGauge(data['fuelPercentage'] ?? 0.0) // 연료에 배터리 모양의 게이지 추가
                        : Image.asset('assets/images/icons/${data['icon']}', width: 26.sp),
                    label: data['label'],
                    value: data['value'],
                    unit: data['unit'],
                    isFuel: data['isFuel'] ?? false,
                    fuelPercentage: data['fuelPercentage'] ?? 0.0,
                  );
                }).toList(),
              );
            },
          ),
        ),
        SizedBox(height: 10.h),
        SmoothPageIndicator(
          controller: _pageController,
          count: (statusData.length / 3).ceil(),
          effect: WormEffect(
            dotHeight: 4.h,
            dotWidth: 4.w,
            activeDotColor: Colors.blue,
            dotColor: Colors.grey,
            spacing: 10.w,
          ),
        ),
      ],
    );
  }

  Widget _buildFuelGauge(double fuelPercentage) {
    return Container(
      width: 52.w,
      height: 25.w,
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
          icon,
          SizedBox(height: 4.h),
          Text(label, style: TextStyle(fontSize: 12.sp, color: Colors.black)),
          SizedBox(height: 2.h),
          Row(
            children: [
              Text(value, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
              SizedBox(width: 4.w),
              Text(unit, style: TextStyle(fontSize: 12.sp, color: Colors.black)),
            ],
          ),
        ],
      ),
    );
  }
}
