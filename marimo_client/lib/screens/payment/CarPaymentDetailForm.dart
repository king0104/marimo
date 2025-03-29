// CarPaymentDetailForm.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:marimo_client/providers/car_payment_provider.dart';
import 'widgets/detail_form/OilDetailForm.dart';
import 'widgets/detail_form/RepairDetailForm.dart';
import 'widgets/detail_form/WashDetailForm.dart';
import 'package:marimo_client/commons/CustomAppHeader.dart';
import 'widgets/detail_form/CategoryAndAmount.dart';

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
    Widget detailForm;
    switch (selectedCategory) {
      case '주유':
        detailForm = OilDetailForm(amount: amount);
        break;
      case '정비':
        detailForm = RepairDetailForm(amount: amount);
        break;
      case '세차':
        detailForm = WashDetailForm(amount: amount);
        break;
      default:
        detailForm = const SizedBox.shrink();
    }

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
          SizedBox(height: 16.h),
          // 구분선 추가
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Divider(height: 1.h, color: Color(0xFFEEEEEE)),
          ),
          // 나머지 DetailForm이 확장되도록 Expanded로 감싸기
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: detailForm,
            ),
          ),
        ],
      ),
    );
  }
}
