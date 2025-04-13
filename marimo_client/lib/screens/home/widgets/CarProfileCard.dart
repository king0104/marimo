import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:marimo_client/providers/car_provider.dart';

class CarProfileCard extends StatelessWidget {
  const CarProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    final carProvider = Provider.of<CarProvider>(context);
    final car = carProvider.cars.isNotEmpty ? carProvider.cars.first : null;
    debugPrint(car?.lastCheckedDate?.toString() ?? '마지막 점검일 없음');

    String _formatFuelType(String? fuelType) {
      switch (fuelType) {
        case 'NORMAL_GASOLINE':
          return '휘발유';
        case 'DIESEL':
          return '경유';
        case 'LPG':
          return 'LPG';
        case 'PREMIUM_GASOLINE':
          return '고급 휘발유';
        default:
          return '정보 없음';
      }
    }

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
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildProfileItem('모델명', car?.modelName ?? '정보 없음'),
          SizedBox(height: 12.h),
          _buildProfileItem(
            '차대번호',
            car?.vehicleIdentificationNumber ?? '정보 없음',
          ),
          SizedBox(height: 12.h),
          _buildProfileItem('연료 타입', _formatFuelType(car?.fuelType)),
          SizedBox(height: 12.h),
          _buildProfileItem(
            '마지막 점검',
            car?.lastCheckedDate != null
                ? _formatDate(car!.lastCheckedDate!)
                : '2025년 04월 10일',
          ),
        ],
      ),
    );
  }

  Widget _buildProfileItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12.sp, color: Colors.grey[600])),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return "${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}";
  }
}
