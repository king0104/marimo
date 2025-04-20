// CarPaymentDetailView.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:marimo_client/providers/car_payment_provider.dart';
import 'package:marimo_client/providers/member/auth_provider.dart';
import 'package:marimo_client/providers/car_provider.dart';
import 'package:marimo_client/services/payment/car_payment_service.dart';
import 'package:marimo_client/models/payment/car_payment_entry.dart';
import 'package:marimo_client/commons/CustomAppHeader.dart';
import 'widgets/detail_form/CategoryAndAmount.dart';
import 'widgets/detail_form/CarDetailFormItemList.dart';
import 'package:marimo_client/screens/payment/CarPaymentDetailList.dart';
import 'package:marimo_client/screens/payment/CarPaymentDetailForm.dart';
import 'package:marimo_client/theme.dart';

class CarPaymentDetailView extends StatefulWidget {
  final CarPaymentEntry entry;
  final Map<String, dynamic> detailData;

  const CarPaymentDetailView({
    super.key,
    required this.entry,
    required this.detailData,
  });

  @override
  State<CarPaymentDetailView> createState() => _CarPaymentDetailViewState();
}

class _CarPaymentDetailViewState extends State<CarPaymentDetailView> {
  bool _isEditMode = false;

  void _toggleEditMode() {
    setState(() {
      _isEditMode = !_isEditMode;
    });
  }

  void _editEntry() async {
    final paymentId = widget.entry.paymentId;
    final category = widget.entry.categoryEng; // 'OIL', 'REPAIR', 'WASH'
    final accessToken = context.read<AuthProvider>().accessToken;
    final provider = context.read<CarPaymentProvider>();

    try {
      final updateData = provider.toJsonForDB(
        carId: widget.entry.details['carId'], // 💡 삭제처럼 entry 안에서 carId 가져옴
        category: widget.entry.categoryKr,
        location: provider.location,
        memo: provider.memo,
        fuelType: provider.fuelType,
        repairParts: provider.selectedRepairItems,
      );

      await CarPaymentService.updatePayment(
        paymentId: paymentId,
        category: category,
        accessToken: accessToken!,
        updateData: updateData,
      );

      // ✅ 수정 후 전체 목록 다시 불러오기
      await context.read<CarPaymentProvider>().fetchPaymentsForSelectedMonth(
        accessToken: accessToken,
        carId: context.read<CarProvider>().firstCarId ?? '',
      );

      if (!mounted) return;
      setState(() => _isEditMode = false);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('수정이 완료되었습니다.')));
    } catch (e) {
      print('❌ 수정 오류: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('수정에 실패했습니다. 다시 시도해주세요.')));
    }
  }

  void _deleteEntry() async {
    final paymentId = widget.entry.paymentId;
    final category = widget.entry.categoryEng; // 'OIL', 'REPAIR', 'WASH'

    final accessToken = context.read<AuthProvider>().accessToken;

    try {
      await CarPaymentService.deletePayment(
        paymentId: paymentId,
        category: category,
        accessToken: accessToken!,
      );

      // ✅ 삭제 후 최신 데이터 다시 불러오기
      final carProvider = context.read<CarProvider>();
      final carId =
          widget.entry.details['carId'] is String
              ? widget.entry.details['carId']
              : carProvider.firstCarId;

      await context.read<CarPaymentProvider>().fetchPaymentsForSelectedMonth(
        accessToken: accessToken,
        carId: carId,
      );

      // 삭제 성공 후 이전 페이지로 이동 (리스트 리프레시 고려)
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const CarPaymentDetailList()),
        );
      }
    } catch (e) {
      print('❌ 삭제 오류: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('삭제에 실패했습니다. 다시 시도해주세요.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: CustomAppHeader(
        title: '',
        onBackPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const CarPaymentDetailList()),
          );
        },

        actions: [
          TextButton(
            onPressed: () {
              final provider = context.read<CarPaymentProvider>();

              // ✅ 기존 데이터 provider에 세팅
              provider.setSelectedCategory(widget.entry.categoryKr);
              provider.setSelectedAmount(widget.entry.amount);
              provider.setSelectedDate(widget.entry.date);
              provider.setLocation(widget.detailData['location'] ?? '');
              provider.setMemo(widget.detailData['memo'] ?? '');
              if (widget.entry.categoryKr == '주유') {
                final fuelTypeEng =
                    widget.detailData['fuelType']?.toString() ?? '';
                provider.setFuelType(provider.getFuelTypeDisplay(fuelTypeEng));
              }
              ;
              provider.setSelectedRepairItems(
                widget.detailData['repairParts'] is List
                    ? List<String>.from(widget.detailData['repairParts'])
                    : (widget.detailData['repairParts'] != null
                        ? widget.detailData['repairParts']
                            .toString()
                            .split(',')
                            .map((e) => e.trim())
                            .where((e) => e.isNotEmpty)
                            .toList()
                        : []),
              );

              // ✅ 수정 화면으로 이동
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder:
                      (_) => CarPaymentDetailForm(
                        selectedCategory: widget.entry.categoryKr,
                        amount: widget.entry.amount,
                        onSave: (newContext) async {
                          final accessToken =
                              newContext.read<AuthProvider>().accessToken!;
                          final provider =
                              newContext.read<CarPaymentProvider>();
                          final carProvider = newContext.read<CarProvider>();

                          print('🚨 DEBUG');
                          print(
                            'memo: ${provider.memo} (${provider.memo.runtimeType})',
                          );
                          print(
                            'location: ${provider.location} (${provider.location.runtimeType})',
                          );
                          print(
                            'fuelType: ${provider.fuelType} (${provider.fuelType.runtimeType})',
                          );

                          final updateData = provider.toJsonForDB(
                            carId:
                                newContext.read<CarProvider>().firstCarId ?? '',
                            category: widget.entry.categoryKr,
                            location: provider.location ?? '', // 🛠️ null 방지
                            memo: provider.memo ?? '', // 🛠️ null 방지
                            fuelType:
                                widget.entry.categoryKr == '주유' &&
                                        provider.fuelType.trim().isNotEmpty
                                    ? provider.fuelType
                                    : null,
                            repairParts:
                                widget.entry.categoryKr == '정비'
                                    ? provider.selectedRepairItems
                                    : null,
                          );

                          // ✅ 디버깅용 출력
                          print('🛠️ [UPDATE DATA]');
                          updateData.forEach((key, value) {
                            print('🔑 $key: $value');
                          });

                          await CarPaymentService.updatePayment(
                            paymentId: widget.entry.paymentId,
                            category: widget.entry.categoryEng,
                            accessToken: accessToken,
                            updateData: updateData,
                          );

                          // ✅ 전체 내역 다시 불러오기
                          await provider.fetchPaymentsForSelectedMonth(
                            accessToken: accessToken,
                            carId: carProvider.firstCarId ?? '',
                          );

                          // final updatedEntry = CarPaymentEntry(
                          //   paymentId: widget.entry.paymentId,
                          //   category: widget.entry.category,
                          //   amount: provider.selectedAmount,
                          //   date: provider.selectedDate, // ✅ 수정된 날짜
                          //   details: updateData,
                          // );

                          // ✅ paymentId로 최신 entry 다시 가져오기
                          final latestEntry = provider.entries.firstWhere(
                            (e) => e.paymentId == widget.entry.paymentId,
                          );

                          // ✅ 최신 detailData를 서버에서 다시 조회
                          final detailData =
                              await CarPaymentService.fetchPaymentDetail(
                                paymentId: widget.entry.paymentId,
                                category: widget.entry.categoryEng,
                                accessToken: accessToken,
                              );

                          Navigator.pushReplacement(
                            newContext,
                            MaterialPageRoute(
                              builder:
                                  (_) => CarPaymentDetailView(
                                    entry: latestEntry,
                                    detailData: detailData,
                                  ),
                            ),
                          );
                        },
                      ),
                ),
              );
            },
            child: Text(
              '수정',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.sp,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          TextButton(
            onPressed: _deleteEntry,
            child: Text(
              '삭제',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.sp,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 16.h),
            child: CategoryAndAmount(
              category: widget.entry.categoryKr,
              amount: widget.entry.amount,
              isEditMode: _isEditMode, // ✅ 수정된 부분
            ),
          ),
          SizedBox(height: 60.h),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: CarDetailFormItemList(
                category: widget.entry.categoryKr,
                amount: widget.entry.amount,
                isEditMode: _isEditMode, // ✅ 수정된 부분
                detailData: widget.detailData,
                initialDate: widget.entry.date,
                onSaveComplete: _toggleEditMode,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
