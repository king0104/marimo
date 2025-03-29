// CarDetailPayment.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marimo_client/screens/payment/widgets/total/CarMonthlyPayment.dart';
import 'package:marimo_client/screens/payment/widgets/detail_list/CarDayDetailPayment.dart';
import 'package:marimo_client/commons/CustomAppHeader.dart';

class CarDetailPayment extends StatefulWidget {
  final int initialMonth;

  const CarDetailPayment({super.key, required this.initialMonth});

  @override
  State<CarDetailPayment> createState() => _CarDetailPaymentState();
}

class _CarDetailPaymentState extends State<CarDetailPayment>
    with WidgetsBindingObserver, AutomaticKeepAliveClientMixin {
  late int selectedMonth;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    selectedMonth = widget.initialMonth;
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
    super.build(context); // AutomaticKeepAlive 필수 호출

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppHeader(
        title: '내역 보기',
        onBackPressed: () => Navigator.of(context).pop(),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h),
            CarMonthlyPayment(),
            SizedBox(height: 18.h),
            Expanded(child: CarDayDetailPayment(selectedMonth: selectedMonth)),
          ],
        ),
      ),
    );
  }
}
