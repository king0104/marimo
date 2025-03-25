// CarTotalPayment.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marimo_client/commons/AppBar.dart';
import 'package:marimo_client/commons/BottomNavigationBar.dart';
import 'package:marimo_client/screens/payment/widgets/CarMonthlyPayment.dart';
import 'package:marimo_client/screens/payment/widgets/CarPaymentItemList.dart';
import 'package:marimo_client/screens/payment/widgets/PlusButton.dart';

class CarTotalPayment extends StatelessWidget {
  const CarTotalPayment({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                CarMonthlyPayment(),
                SizedBox(height: 20.h),
                CarPaymentItemList(),
                SizedBox(height: 200.h), // 하단 버튼 여백
              ],
            ),
          ),
          const Positioned(bottom: 100, right: 20, child: PlusButton()),
        ],
      ),
      bottomNavigationBar: CommonBottomNavigationBar(
        currentIndex: 4,
        onTap: (index) {
          // 탭 변경 처리
        },
      ),
    );
  }
}
