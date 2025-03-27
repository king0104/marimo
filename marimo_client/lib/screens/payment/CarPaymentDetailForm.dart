// CarPaymentDetailForm.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:marimo_client/providers/car_payment_provider.dart';
import 'widgets/OilDetailForm.dart';
import 'widgets/RepairDetailForm.dart';
import 'widgets/WashDetailForm.dart';

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
      appBar: AppBar(
        title: const Text('지출 입력'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: detailForm,
      ),
    );
  }
}
