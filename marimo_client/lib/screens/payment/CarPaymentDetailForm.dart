// CarPaymentDetailForm.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marimo_client/theme.dart';
import 'package:provider/provider.dart';
import 'package:marimo_client/providers/car_provider.dart';
import 'package:marimo_client/providers/car_payment_provider.dart';
import 'package:marimo_client/providers/member/auth_provider.dart';
import 'package:marimo_client/commons/CustomAppHeader.dart';
import 'widgets/detail_form/CategoryAndAmount.dart';
import 'widgets/detail_form/CarDetailFormItemList.dart';
import 'widgets/detail_form/CarDetailFormSaveButton.dart';
import 'package:marimo_client/screens/payment/CarPaymentDetailList.dart';
import 'package:marimo_client/services/payment/car_payment_service.dart';
import 'package:marimo_client/models/payment/car_payment_entry.dart';
import 'package:marimo_client/screens/payment/widgets/detail_form/CarDetailFormItemList.dart';
import 'package:marimo_client/screens/payment/CarPaymentDetailView.dart'; // ✅ View 화면 import

class CarPaymentDetailForm extends StatefulWidget {
  final String selectedCategory;
  final int amount;

  // ✅ 저장 로직은 외부에서 주입하도록 옵션화
  final Future<void> Function()? onSave;

  const CarPaymentDetailForm({
    super.key,
    required this.selectedCategory,
    required this.amount,
    this.onSave,
  });

  @override
  State<CarPaymentDetailForm> createState() => _CarPaymentDetailFormState();
}

class _CarPaymentDetailFormState extends State<CarPaymentDetailForm> {
  final GlobalKey<CarDetailFormItemListState> _formItemKey = GlobalKey();

  void _deleteEntry() {
    // TODO: 삭제 로직 필요 시 여기에 작성
  }

  void _saveAction() async {
    print('✅ 저장 버튼 눌림');

    // 외부에서 onSave 콜백이 주어진 경우 → 그것만 실행
    if (widget.onSave != null) {
      await widget.onSave!();
      return;
    }

    final carProvider = context.read<CarProvider>();
    final carPaymentProvider = context.read<CarPaymentProvider>();
    final authProvider = context.read<AuthProvider>();

    if (!carProvider.hasAnyCar) {
      print('🚨 등록된 차량이 없습니다.');
      return;
    }

    final accessToken = authProvider.accessToken;
    if (accessToken == null || accessToken.isEmpty) {
      print('🚫 유효한 토큰이 없습니다. 로그인 필요.');
      return;
    }

    final carId = carProvider.cars.first.id;

    _formItemKey.currentState?.saveInputsToProvider();

    if (carPaymentProvider.selectedDate == null) {
      carPaymentProvider.setSelectedDate(DateTime.now());
    }

    try {
      final paymentId = await CarPaymentService.savePayment(
        provider: carPaymentProvider,
        carId: carId,
        accessToken: accessToken,
        category: widget.selectedCategory,
      );

      // ✅ CarPaymentEntry 생성해서 Provider에 추가
      final entry = CarPaymentEntry(
        paymentId: paymentId,
        category: carPaymentProvider.selectedCategory ?? '주유',
        amount: carPaymentProvider.selectedAmount,
        date: carPaymentProvider.selectedDate,
        details: {
          "location": carPaymentProvider.location,
          "memo": carPaymentProvider.memo,
          "fuelType": carPaymentProvider.fuelType,
          "repairParts": carPaymentProvider.selectedRepairItems,
        },
      );
      carPaymentProvider.addEntry(entry);

      print('🎉 저장 및 Provider 반영 완료');
      carPaymentProvider.resetInput();

      // ✅ 저장 성공 후 View 페이지로 이동
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (_) =>
                  CarPaymentDetailView(entry: entry, detailData: entry.details),
        ),
      );
    } catch (e, stack) {
      print('❌ 저장 중 오류 발생: $e');
      print('🪜 스택 트레이스: $stack');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: CustomAppHeader(
        title: '',
        onBackPressed: () {
          Navigator.pop(context);
        },
        actions: [], // ✅ _isEditMode 제거로 비워둠
      ),
      body: Column(
        children: [
          // CategoryAndAmount 컴포넌트를 상단에 렌더링
          Padding(
            padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 16.h),
            child: CategoryAndAmount(
              category: widget.selectedCategory,
              amount: widget.amount,
              isEditMode: true, // ✅ 항상 true로 고정
            ),
          ),
          SizedBox(height: 60.h),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: CarDetailFormItemList(
                key: _formItemKey,
                category: widget.selectedCategory,
                amount: widget.amount,
                isEditMode: true, // ✅ 항상 true로 고정
                onSaveComplete: () {}, // ✅ 편집 모드 토글 제거
              ),
            ),
          ),

          // ✅ 저장 버튼 항상 렌더링
          Padding(
            padding: EdgeInsets.only(left: 20.w, right: 20.w),
            child: CarDetailFormSaveButton(onPressed: _saveAction),
          ),
        ],
      ),
    );
  }
}
