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
    // ✅ 날짜 + 시간 기준으로 최신순 정렬
    final sortedEntries = [...entries]
      ..sort((a, b) => b.date.compareTo(a.date));
    return Column(
      children:
          sortedEntries.map((entry) {
            // print('🛠 paymentId: ${entry.paymentId}');
            // print('🛠 entry.category: ${entry.category}'); // 영문 (예: OIL)
            // print('🛠 entry.categoryKr: ${entry.categoryKr}'); // 한글 (예: 주유)
            // print('🛠 entry.details: ${entry.details}'); // 전체 JSON 확인

            return Padding(
              padding: EdgeInsets.only(left: 6.w, right: 6.w, bottom: 20.h),
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () async {
                  final accessToken = context.read<AuthProvider>().accessToken;
                  final actualCategory = entry.category;

                  print('📍 paymentId: ${entry.paymentId}');
                  print('📍 실제 category: $actualCategory');
                  print('📋 entry.category: ${entry.category}');
                  print('📋 entry.details["type"]: ${entry.details['type']}');

                  try {
                    final detail = await CarPaymentService.fetchPaymentDetail(
                      paymentId: entry.paymentId,
                      category: entry.categoryEng.toLowerCase(),
                      accessToken: accessToken!,
                    );
                    // ✅ 서버에서 받은 detail로 entry.details 덮어씌운 새 객체 만들기
                    final updatedEntry = CarPaymentEntry(
                      paymentId: entry.paymentId,
                      category: entry.category,
                      amount: entry.amount,
                      date: entry.date,
                      details: detail, // 🔥 최신 detail 반영
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => CarPaymentDetailView(
                              entry: updatedEntry,
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
                child: CarDayPaymentItem(
                  category: entry.categoryKr,
                  amount: entry.amount,
                  subText: _getSubText(entry),
                  paymentId: entry.paymentId,
                ),
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
