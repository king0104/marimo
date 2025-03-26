// OilIcon.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OilIcon extends StatelessWidget {
  final double size; // 👈 외부에서 전체 크기 조절

  const OilIcon({super.key, this.size = 44});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.w,
      height: size.h,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.black,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: SvgPicture.asset(
          'assets/images/icons/icon_oil_white.svg',
          width: (size * 0.45).w, // 예: 전체의 45%
          height: (size * 0.45).h,
          fit: BoxFit.scaleDown,
        ),
      ),
    );
  }
}
