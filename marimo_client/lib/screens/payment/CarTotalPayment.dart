// CarTotalPayment.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:marimo_client/providers/car_payment_provider.dart';
import 'package:marimo_client/providers/car_provider.dart';
import 'package:marimo_client/providers/member/auth_provider.dart';
import 'package:marimo_client/commons/AppBar.dart';
import 'package:marimo_client/screens/payment/widgets/total/CarMonthlyPayment.dart';
import 'package:marimo_client/screens/payment/widgets/total/CarPaymentItemList.dart';
import 'package:marimo_client/screens/payment/widgets/total/CarPlusButton.dart';
import 'package:marimo_client/screens/payment/widgets/total/CarPaymentHistoryButton.dart';
import 'CarPaymentDetailList.dart';

class CarTotalPayment extends StatefulWidget {
  const CarTotalPayment({super.key});

  @override
  State<CarTotalPayment> createState() => _CarTotalPaymentState();
}

class _CarTotalPaymentState extends State<CarTotalPayment>
    with WidgetsBindingObserver, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Future.microtask(() async {
      final provider = context.read<CarPaymentProvider>();
      final authProvider = context.read<AuthProvider>();
      final carProvider = context.read<CarProvider>();

      final accessToken = authProvider.accessToken;

      if (accessToken != null && accessToken.isNotEmpty) {
        await provider.fetchPaymentsForSelectedMonth(
          accessToken: accessToken,
          carId: carProvider.cars.first.id,
        );
      }
    });
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
            child: Consumer<CarPaymentProvider>(
              builder: (context, provider, _) {
                return CarMonthlyPayment();
              },
            ),
          ),
          Positioned(
            top: 90.h,
            right: 20.w,
            child: HistoryViewButton(
              onTap: () async {
                // 상태 반영을 기다릴 수 있도록 약간의 딜레이를 줌
                await Future.delayed(const Duration(milliseconds: 50));

                // 현재 Provider 인스턴스를 가져옴
                final provider = Provider.of<CarPaymentProvider>(
                  context,
                  listen: false,
                );

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder:
                        (context) => ChangeNotifierProvider.value(
                          // 기존 provider 인스턴스를 value로 전달
                          value: provider,
                          child: const CarPaymentDetailList(),
                        ),
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
