// CarPaymentDetailForm.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:marimo_client/providers/car_payment_provider.dart';
import 'package:marimo_client/commons/CustomAppHeader.dart';
import 'widgets/detail_form/CategoryAndAmount.dart';
import 'widgets/detail_form/CarDetailFormItemList.dart';

class CarPaymentDetailForm extends StatelessWidget {
  final String selectedCategory;
  final int amount;

  const CarPaymentDetailForm({
    super.key,
    required this.selectedCategory,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppHeader(
        title: '',
        onBackPressed: () => Navigator.pop(context),
      ),
      body: Column(
        children: [
          // CategoryAndAmount 컴포넌트를 상단에 렌더링
          Padding(
            padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 16.h),
            child: CategoryAndAmount(
              category: selectedCategory,
              amount: amount,
            ),
          ),
          SizedBox(height: 60.h),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: CarDetailFormItemList(
                category: selectedCategory,
                amount: amount,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
