// CarPaymentInput.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:marimo_client/screens/payment/widgets/CarPaymentCategorySelector.dart';
import 'package:marimo_client/screens/payment/widgets/CarPaymentAmountInput.dart';
import 'package:marimo_client/screens/payment/widgets/CarPaymentDateInput.dart';
import 'package:marimo_client/commons/CustomAppHeader.dart';
import 'package:marimo_client/theme.dart';

class CarPaymentInput extends StatefulWidget {
  const CarPaymentInput({super.key});

  @override
  State<CarPaymentInput> createState() => _CarPaymentInputState();
}

class _CarPaymentInputState extends State<CarPaymentInput> {
  DateTime selectedDate = DateTime.now();

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
                CarPaymentDateInput(
                  selectedDate: selectedDate,
                  onDateSelected: (picked) {
                    setState(() {
                      selectedDate = picked;
                    });
                  },
                ),
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
