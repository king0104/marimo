// CarPaymentDetailList.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:marimo_client/providers/car_payment_provider.dart';
import 'package:marimo_client/screens/payment/widgets/detail_list/CarMonthlyPaymentReadOnly.dart';
import 'package:marimo_client/screens/payment/widgets/detail_list/CarDayPaymentDetail.dart';
import 'package:marimo_client/commons/CustomAppHeader.dart';
import 'CarTotalPayment.dart';

class CarPaymentDetailList extends StatefulWidget {
  const CarPaymentDetailList({super.key});

  @override
  State<CarPaymentDetailList> createState() => _CarDetailPaymentState();
}

class _CarDetailPaymentState extends State<CarPaymentDetailList>
    with WidgetsBindingObserver, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

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

  @override
  Widget build(BuildContext context) {
    super.build(context); // AutomaticKeepAlive 필수 호출

    // final selectedMonth = provider.selectedMonth;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppHeader(
        title: '내역 보기',
        onBackPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const CarTotalPayment()),
          );
        },
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h),
            CarMonthlyPaymentReadOnly(),
            SizedBox(height: 18.h),
            // Consumer로 감싸서 Provider 변경 시 이 부분만 다시 그리도록 최적화
            Expanded(
              child: Consumer<CarPaymentProvider>(
                builder: (context, provider, _) {
                  return CarDayPaymentDetail(
                    // selectedMonth: provider.selectedMonth,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
