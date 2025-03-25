// CarPaymentItemList.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:marimo_client/providers/car_payment_provider.dart';
import 'package:marimo_client/screens/payment/widgets/CarPaymentItem.dart';

class CarPaymentItemList extends StatelessWidget {
  const CarPaymentItemList({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CarPaymentProvider>();
    final totals = provider.categoryTotals;
    final percentages = provider.percentages;

    return Column(
      children: [
        CarPaymentItem(
          iconPath: 'assets/images/icons/icon_oil_black.svg',
          label: '주유',
          amount: '${totals['주유'] ?? 0}원',
          percentage: percentages['주유'] ?? '0.0%',
        ),
        SizedBox(height: 16),
        CarPaymentItem(
          iconPath: 'assets/images/icons/icon_repair_black.svg',
          label: '정비',
          amount: '${totals['정비'] ?? 0}원',
          percentage: percentages['정비'] ?? '0.0%',
        ),
        SizedBox(height: 16),
        CarPaymentItem(
          iconPath: 'assets/images/icons/icon_wash_black.svg',
          label: '세차',
          amount: '${totals['세차'] ?? 0}원',
          percentage: percentages['세차'] ?? '0.0%',
        ),
      ],
    );
  }
}
