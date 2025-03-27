// CarTotalPayment.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marimo_client/commons/AppBar.dart';
import 'package:marimo_client/commons/BottomNavigationBar.dart';
import 'package:marimo_client/screens/payment/widgets/CarMonthlyPayment.dart';
import 'package:marimo_client/screens/payment/widgets/CarPaymentItemList.dart';
import 'package:marimo_client/screens/payment/widgets/CarPlusButton.dart';
import 'package:marimo_client/screens/payment/widgets/CarPaymentHistoryButton.dart';
import 'CarDetailPayment.dart';

class CarTotalPayment extends StatefulWidget {
  const CarTotalPayment({super.key});

  @override
  State<CarTotalPayment> createState() => _CarTotalPaymentState();
}

class _CarTotalPaymentState extends State<CarTotalPayment>
    with WidgetsBindingObserver, AutomaticKeepAliveClientMixin {
  int selectedMonth = DateTime.now().month;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() {});
      });
    }
  }

  void _updateMonth(int month) {
    setState(() {
      selectedMonth = month;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // AutomaticKeepAliveClientMixin 필수 호출

    return Scaffold(
      appBar: const CommonAppBar(),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
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
          Positioned(
            top: 45.h,
            left: 20.w,
            child: CarMonthlyPayment(
              // selectedMonth: selectedMonth,
              // onMonthChanged: _updateMonth,
            ),
          ),
          Positioned(
            top: 90.h,
            right: 20.w,
            child: HistoryViewButton(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            CarDetailPayment(initialMonth: selectedMonth),
                  ),
                );
              },
            ),
          ),
          Positioned(
            top: 167.h,
            left: 20.w,
            right: 20.w,
            child: const CarPaymentItemList(),
          ),
          Positioned(bottom: 35.h, right: 30.w, child: const PlusButton()),
        ],
      ),
    );
  }
}
