// PaymentHistoryButton.dart
// PaymentHistoryButton.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marimo_client/theme.dart';

class HistoryViewButton extends StatelessWidget {
  final VoidCallback onTap;

  const HistoryViewButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 84.w,
        height: 28.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: Colors.grey.withOpacity(0.2), width: 1.w),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 11.8,
              spreadRadius: 4,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Text(
          '내역 보기',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w300,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
