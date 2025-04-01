// CarPaymentInput.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:marimo_client/screens/payment/widgets/payment_input/CarPaymentCategorySelector.dart';
import 'package:marimo_client/screens/payment/widgets/payment_input/CarPaymentAmountInput.dart';
import 'package:marimo_client/screens/payment/widgets/payment_input/CarPaymentDateInput.dart';
import 'package:marimo_client/commons/CustomAppHeader.dart';
import 'package:marimo_client/theme.dart';
import 'package:marimo_client/providers/car_payment_provider.dart';

class CarPaymentInput extends StatefulWidget {
  final String? initialCategory;

  const CarPaymentInput({super.key, this.initialCategory});
  // const CarPaymentInput({super.key});

  @override
  State<CarPaymentInput> createState() => _CarPaymentInputState();
}

class _CarPaymentInputState extends State<CarPaymentInput> {
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && widget.initialCategory != null) {
        final provider = Provider.of<CarPaymentProvider>(
          context,
          listen: false,
        );
        provider.setSelectedCategory(widget.initialCategory);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: CustomAppHeader(
        title: '',
        onBackPressed: () => Navigator.pop(context),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.5.h), // 헤더와 날짜 사이 여백
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 📅 날짜 선택 위젯
                CarPaymentDateInput(),
                SizedBox(height: 20.5.h),
                const CarPaymentCategorySelector(),
              ],
            ),
          ),
          SizedBox(height: 100.h),
          const Expanded(child: CarPaymentAmountInput()),
        ],
      ),
    );
  }
}
