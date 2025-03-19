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
            child: _buildImage(item.imagePath),
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
  
  // 이미지 확장자에 따라 적절한 위젯 반환
  Widget _buildImage(String path) {
  if (path.toLowerCase().endsWith('.svg')) {
    return SvgPicture.asset(
      path,
      width: 64.w,
      height: 64.h,
      fit: BoxFit.fill, 
    );
  } else {
    return Image.asset(
      path,
      width: 64.w,
      height: 64.h,
      fit: BoxFit.fill, 
    );
  }
}