// CarTotalPayment.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marimo_client/commons/AppBar.dart';
import 'package:marimo_client/commons/BottomNavigationBar.dart';
import 'package:marimo_client/screens/payment/widgets/CarMonthlyPayment.dart';
import 'package:marimo_client/screens/payment/widgets/CarPaymentItemList.dart';
import 'package:marimo_client/screens/payment/widgets/PlusButton.dart';
import 'package:marimo_client/screens/payment/widgets/PaymentHistoryButton.dart';

class CarTotalPayment extends StatefulWidget {
  const CarTotalPayment({super.key});

  @override
  State<CarTotalPayment> createState() => _CarTotalPaymentState();
}

class _CarTotalPaymentState extends State<CarTotalPayment> {
  int selectedMonth = DateTime.now().month;

  void _updateMonth(int month) {
    setState(() {
      selectedMonth = month;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 차계부 타이틀
          Positioned(
            top: 16.h,
            left: 20.w,
            child: Text(
              '차계부',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),

          // 월 총 지출 컴포넌트 (selectedMonth 전달)
          Positioned(
            top: 45.h,
            left: 20.w,
            child: CarMonthlyPayment(
              selectedMonth: selectedMonth,
              onMonthChanged: _updateMonth,
            ),
          ),

          // 내역 보기 버튼
          Positioned(
            top: 90.h,
            right: 20.w,
            child: HistoryViewButton(onTap: () {}),
          ),

          // 항목 리스트
          Positioned(
            top: 175.h,
            left: 20.w,
            right: 20.w,
            child: const CarPaymentItemList(),
          ),

          // + 버튼
          Positioned(bottom: 35.h, right: 30.w, child: const PlusButton()),
        ],
      ),
      bottomNavigationBar: CommonBottomNavigationBar(
        currentIndex: 4,
        onTap: (index) {},
      ),
    );
  }
}
