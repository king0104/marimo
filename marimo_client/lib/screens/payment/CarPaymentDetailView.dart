import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

  void _deleteEntry() {
    // TODO: 삭제 로직 구현 필요
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppHeader(
        title: '',
        onBackPressed: () {
          Navigator.pop(context);
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
