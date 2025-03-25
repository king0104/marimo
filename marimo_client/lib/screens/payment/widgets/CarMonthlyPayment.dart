// CarMonthlyPayment.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:marimo_client/providers/car_payment_provider.dart';

class CarMonthlyPayment extends StatelessWidget {
  const CarMonthlyPayment({super.key});

  @override
  Widget build(BuildContext context) {
    final total = context.watch<CarPaymentProvider>().totalAmount;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('이번 달 총 지출', style: TextStyle(fontSize: 16)),
        Text(
          '$total 원',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
