import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CarImageWidget extends StatelessWidget {
  const CarImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300.h,
      width: double.infinity,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: -330.w,
              top: 0,
              bottom: 0,
              child: Image.asset(
                'assets/images/cars/LX06_A2B.png',
                width: 650.w,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
    );
  }
}
