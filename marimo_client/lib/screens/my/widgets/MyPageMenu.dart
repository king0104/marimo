import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marimo_client/screens/payment/CarTotalPayment.dart';

import 'package:marimo_client/providers/car_payment_provider.dart';
import 'package:marimo_client/providers/member/auth_provider.dart';
import 'package:marimo_client/providers/car_provider.dart';
import 'package:provider/provider.dart';
import 'package:marimo_client/screens/Insurance/InsuranceScreen.dart';

class MyPageMenu extends StatefulWidget {
  const MyPageMenu({super.key});

  @override
  State<MyPageMenu> createState() => _MyPageMenuState();
}

class _MyPageMenuState extends State<MyPageMenu> {
  void _handleInsuranceTap(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final carProvider = Provider.of<CarProvider>(context, listen: false);
    
    final carId = carProvider.firstCarId;
    final accessToken = authProvider.accessToken;

    if (carId == null || accessToken == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('차량 정보가 없습니다. 차량을 먼저 등록해주세요.')),
      );
      return;
    }

    final car = carProvider.getCarById(carId);
    if (car?.totalDistance == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('총 주행거리 정보가 없습니다. OBD2 연결 후 이용해주세요!')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const InsuranceScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '자동차 보험',
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12.h),
        _buildMenuItem(
          iconPath: 'assets/images/icons/icon_moneybag.png',
          title: '마일리지 특약 최적화',
          subtitle: '주행거리를 바탕으로 최적의 혜택 거리를 알려드립니다',
          gradient: LinearGradient(
                    colors: [Color(0x2587FF).withOpacity(0.3), Color(0x2587FF).withOpacity(0.95)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
          onTap: () => _handleInsuranceTap(context),
        ),
        SizedBox(height: 24.h),
        Text(
          '차계부',
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12.h),
        _buildMenuItem(
          iconPath: 'assets/images/icons/icon_receipt.png',
          title: '나의 지출 경비 장부',
          subtitle: '차량유지관리에 들어가는 비용을 손쉽게 파악해보세요!',
          gradient: LinearGradient(
            colors: [
              Color(0x2587FF).withOpacity(0.3),
              Color(0x2587FF).withOpacity(0.95),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder:
                    (context) => ChangeNotifierProvider(
                      create: (_) => CarPaymentProvider(),
                      child: CarTotalPayment(),
                    ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required String iconPath,
    required String title,
    required String subtitle,
    required Gradient gradient,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(5.w),
              decoration: BoxDecoration(
                gradient: gradient,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(13.r),
              ),
              child: Image.asset(
                iconPath,
                width: 24.w,
                height: 24.w,
                fit: BoxFit.cover
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey[400],
              size: 24.w,
            ),
          ],
        ),
      ),
    );
  }
}
