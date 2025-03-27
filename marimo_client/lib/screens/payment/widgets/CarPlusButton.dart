// CarPlusButton.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marimo_client/screens/payment/CarPaymentInput.dart';

class PlusButton extends StatelessWidget {
  const PlusButton({super.key});

  void _navigateToInputPage(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const CarPaymentInput()));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToInputPage(context),
      child: SizedBox(
        width: 57.w,
        height: 57.h,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 64.w,
              height: 64.h,
              decoration: BoxDecoration(
                color: const Color(0xFF4888FF),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x4D007DFC),
                    offset: Offset(2.w, 4.h),
                    blurRadius: 4.r,
                    spreadRadius: -1.r,
                  ),
                ],
              ),
            ),
            SvgPicture.asset(
              'assets/images/icons/icon_plus_white.svg',
              width: 16.84.w,
              height: 16.84.h,
            ),
          ],
        ),
      ),
    );
  }
}
