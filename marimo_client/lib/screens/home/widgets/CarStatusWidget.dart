import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CarStatusWidget extends StatelessWidget {
  const CarStatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatusItem(
          icon: Icons.speed,
          label: '총 주행거리',
          value: '50,000',
          unit: 'km',
        ),
        _buildStatusItem(
          icon: Icons.local_gas_station,
          label: '연비',
          value: '5.0',
          unit: 'km/L',
        ),
        _buildStatusItem(
          icon: Icons.battery_charging_full,
          label: '연료',
          value: '12.5',
          unit: 'L',
        ),
      ],
    );
  }

  Widget _buildStatusItem({
    required IconData icon,
    required String label,
    required String value,
    required String unit,
  }) {
    return Column(
      children: [
        Icon(icon, size: 24.w, color: Colors.grey[600]),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          unit,
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}