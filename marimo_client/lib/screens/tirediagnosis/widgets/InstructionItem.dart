// InstructionItem.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InstructionItem {
  final String imagePath;
  final bool isGood;

  InstructionItem({
    required this.imagePath,
    required this.isGood,
  });
}

class InstructionItemWidget extends StatelessWidget {
  final InstructionItem item;
  
  const InstructionItemWidget({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: Container(
            width: 64.w,
            height: 64.h,
            color: Colors.grey.withOpacity(0.1),
            child: SvgPicture.asset(
              item.imagePath,
              fit: BoxFit.contain,
              placeholderBuilder: (context) => const CircularProgressIndicator(), // 로딩 상태 표시
            ),
          ),
        ),
        SizedBox(height: 5.h),
        Container(
          width: 24.w,
          height: 24.h,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: SvgPicture.asset(
            item.isGood
                ? 'assets/images/icons/icon_circle.svg'
                : 'assets/images/icons/icon_cross.svg',
            width: 24.w,
            height: 24.h,
          ),
        ),
      ],
    );
  }
}