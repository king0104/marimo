import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:marimo_client/providers/car_provider.dart';

class WeatherWidget extends StatelessWidget {
  const WeatherWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final carProvider = Provider.of<CarProvider>(context);
    final car = carProvider.cars.isNotEmpty ? carProvider.cars.first : null;
    final nickname = car?.nickname ?? '마이 리틀 모빌리티';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          nickname,
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4.h),
        Text(
          '오늘은 드라이빙하기 좋은 날씨네요!',
          style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
        ),
        SizedBox(height: 4.h),
        Row(
          children: [
            Icon(Icons.wb_sunny, size: 16.sp, color: Colors.grey[600]),
            SizedBox(width: 4.w),
            Text(
              '19°C', // TODO: 날씨 데이터 연동 시 변경
              style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
            ),
            SizedBox(width: 8.w),
            Text(
              '역삼로', // TODO: 위치 정보 연동 시 변경
              style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
            ),
          ],
        ),
      ],
    );
  }
}
