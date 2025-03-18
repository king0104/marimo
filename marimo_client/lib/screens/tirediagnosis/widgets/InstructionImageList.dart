import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InstructionImageList extends StatelessWidget {
  const InstructionImageList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Row를 Center로 감싸 행 전체가 중앙에 위치하도록 함
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center, // 행 내부 요소들을 가운데 정렬
          children: [
            _buildExampleSvg('assets/images/tires/tire_right.svg', true),
            SizedBox(width: 16.w),
            _buildExampleSvg('assets/images/tires/tire_wrong_1.svg', false),
            SizedBox(width: 16.w),
            _buildExampleSvg('assets/images/tires/tire_wrong_2.svg', false),
          ],
        ),
      ),
    );
  }

  /// ✅ **SVG 이미지를 표시하는 함수**
  Widget _buildExampleSvg(String imagePath, bool isGood) {
    return Column(
      mainAxisSize: MainAxisSize.min, // 컬럼이 필요한 최소 크기만 차지
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: Container(
            width: 64.w, // 너비 64로 고정
            height: 64.h, // 높이 64로 고정
            color: Colors.grey.withOpacity(0.1),
            child: SvgPicture.asset(
              imagePath,
              fit: BoxFit.contain, // 컨테이너에 맞게 적절히 조정
            ),
          ),
        ),
        SizedBox(height: 4.h),
        Container(
          width: 24.w,
          height: 24.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isGood ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
            border: Border.all(
              color: isGood ? Colors.green : Colors.red,
              width: 1.w,
            ),
          ),
          child: Icon(
            isGood ? Icons.check : Icons.close,
            color: isGood ? Colors.green : Colors.red,
            size: 20.sp,
          ),
        ),
      ],
    );
  }
}