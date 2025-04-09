// CarPaymentDetailView.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:marimo_client/providers/car_payment_provider.dart';
import 'package:marimo_client/providers/member/auth_provider.dart';
import 'package:marimo_client/services/payment/car_payment_service.dart';
import 'package:marimo_client/models/payment/car_payment_entry.dart';
import 'package:marimo_client/commons/CustomAppHeader.dart';
import 'widgets/detail_form/CategoryAndAmount.dart';
import 'widgets/detail_form/CarDetailFormItemList.dart';
import 'package:marimo_client/screens/payment/CarPaymentDetailList.dart';

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
      backgroundColor: Colors.white,
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
            onPressed: _toggleEditMode,
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
                onSaveComplete: _toggleEditMode,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
