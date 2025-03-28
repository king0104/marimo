// CarPaymentInput.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:marimo_client/screens/payment/widgets/CarPaymentCategorySelector.dart';
import 'package:marimo_client/screens/payment/widgets/CarPaymentAmountInput.dart';
import 'package:marimo_client/screens/payment/widgets/CarPaymentDateInput.dart';
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

  // @override
  // void initState() {
  //   super.initState();
  //   // 화면이 처음 로드될 때 Provider의 selectedCategory 확인
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     if (mounted) {
  //       final provider = Provider.of<CarPaymentProvider>(
  //         context,
  //         listen: false,
  //       );
  //       // 카테고리가 null이면 기본값으로 설정할 수도 있음
  //       // if (provider.selectedCategory == null) {
  //       //   provider.setSelectedCategory('주유');
  //       // }
  //       print('[CarPaymentInput] provider hash: ${provider.hashCode}');
  //       print('선택된 카테고리: ${provider.selectedCategory}');
  //     }
  //   });
  // }

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
