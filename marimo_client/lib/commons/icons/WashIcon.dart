// WashIcon.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WashIcon extends StatelessWidget {
  final double size;

  const WashIcon({super.key, this.size = 44});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.w,
      height: size.h,
      decoration: const BoxDecoration(
        color: Colors.black,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: SvgPicture.asset(
        'assets/images/icons/icon_wash_white.svg',
        width: 20.w,
        height: 20.w,
      ),
    );
  }
}
