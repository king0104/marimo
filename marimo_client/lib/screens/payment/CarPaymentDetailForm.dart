// CarPaymentDetailForm.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:marimo_client/providers/car_payment_provider.dart';
import 'package:marimo_client/commons/CustomAppHeader.dart';
import 'widgets/detail_form/CategoryAndAmount.dart';
import 'widgets/detail_form/CarDetailFormItemList.dart';
import 'widgets/detail_form/CarDetailFormSaveButton.dart';
import 'package:marimo_client/screens/payment/CarPaymentDetailList.dart';

class CarPaymentDetailForm extends StatefulWidget {
  final String selectedCategory;
  final int amount;

  const CarPaymentDetailForm({
    super.key,
    required this.selectedCategory,
    required this.amount,
  });

  @override
  State<CarPaymentDetailForm> createState() => _CarPaymentDetailFormState();
}

class _CarPaymentDetailFormState extends State<CarPaymentDetailForm> {
  bool _isEditMode = true;

  void _toggleEditMode() {
    setState(() {
      _isEditMode = !_isEditMode;
    });
  }

  void _deleteEntry() {
    // TODO: 삭제 로직 필요 시 여기에 작성
  }

  void _saveAction() {
    print('저장 버튼 눌림');
    _toggleEditMode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppHeader(
        title: '',
        onBackPressed: () {
          if (_isEditMode) {
            Navigator.pop(context); // 일반 뒤로가기
          } else {
            final provider = Provider.of<CarPaymentProvider>(
              context,
              listen: false,
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder:
                    (_) => CarPaymentDetailList(
                      initialMonth: provider.selectedMonth,
                    ),
              ),
            );
          }
        },
        actions:
            _isEditMode
                ? []
                : [
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
                  // SizedBox(width: 30.w),
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
          // CategoryAndAmount 컴포넌트를 상단에 렌더링
          Padding(
            padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 16.h),
            child: CategoryAndAmount(
              category: widget.selectedCategory,
              amount: widget.amount,
              isEditMode: _isEditMode,
            ),
          ),
          SizedBox(height: 60.h),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: CarDetailFormItemList(
                category: widget.selectedCategory,
                amount: widget.amount,
                isEditMode: _isEditMode,
                onSaveComplete: _toggleEditMode,
              ),
            ),
          ),

          // ✅ 저장 버튼 추가 위치
          if (_isEditMode)
            Padding(
              padding: EdgeInsets.only(left: 20.w, right: 20.w),
              child: CarDetailFormSaveButton(onPressed: _saveAction),
            ),
        ],
      ),
    );
  }
}
