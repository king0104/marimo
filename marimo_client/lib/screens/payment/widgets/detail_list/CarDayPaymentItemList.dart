// CarDayPaymentItemList.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marimo_client/models/payment/car_payment_entry.dart';
import 'package:provider/provider.dart';
import 'package:marimo_client/services/payment/car_payment_service.dart';
import 'package:marimo_client/providers/member/auth_provider.dart';
import 'package:marimo_client/screens/payment/CarPaymentDetailView.dart';
import 'CarDayPaymentItem.dart';

class CarDayPaymentItemList extends StatelessWidget {
  final DateTime date;
  final List<CarPaymentEntry> entries;

  const CarDayPaymentItemList({
    super.key,
    required this.date,
    required this.entries,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children:
          entries.map((entry) {
            // print('🛠 paymentId: ${entry.paymentId}');
            // print('🛠 entry.category: ${entry.category}'); // 영문 (예: OIL)
            // print('🛠 entry.categoryKr: ${entry.categoryKr}'); // 한글 (예: 주유)
            // print('🛠 entry.details: ${entry.details}'); // 전체 JSON 확인

            return Padding(
              padding: EdgeInsets.only(left: 6.w, right: 6.w, bottom: 20.h),
              child: CarDayPaymentItem(
                category: entry.categoryKr,
                amount: entry.amount,
                subText: _getSubText(entry),
                paymentId: entry.paymentId,
                onTap: () async {
                  final accessToken = context.read<AuthProvider>().accessToken;
                  final actualCategory =
                      entry.category; // 'OIL', 'REPAIR', 'WASH'
                  print('📍 paymentId: ${entry.paymentId}');
                  print('📍 실제 category: $actualCategory');

                  try {
                    final detail = await CarPaymentService.fetchPaymentDetail(
                      paymentId: entry.paymentId,
                      category: entry.category,
                      accessToken: accessToken!,
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => CarPaymentDetailView(
                              entry: entry,
                              detailData: detail,
                            ),
                      ),
                    );
                  } catch (e) {
                    print('❌ 상세 조회 실패: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('상세 내역을 불러오지 못했습니다.')),
                    );
                  }
                },
              ),
            );
          }).toList(),
    );
  }

  String? _getSubText(CarPaymentEntry entry) {
    if (entry.category == '주유' && entry.details['fuelVolume'] != null) {
      return '${entry.details['fuelVolume']}L';
    }
    return null;
  }
}
