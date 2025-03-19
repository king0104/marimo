// Instruction.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart'; // SVG 파일을 사용하기 위한 패키지 추가
import 'InstructionItemList.dart';

class Instruction extends StatelessWidget {
  const Instruction({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '유의사항',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 13.h),
        // SVG 이미지와 텍스트를 Row로 배치하여 수평 정렬
        Row(
          crossAxisAlignment: CrossAxisAlignment.center, // 세로 중앙 정렬
          children: [
            // SVG 아이콘 (왼쪽에서 24만큼 떨어지도록 패딩 적용)
            Padding(
              padding: EdgeInsets.only(left: 4.w),
              child: SvgPicture.asset('assets/images/icons/icon_instruction.svg'),
            ),
            
            SizedBox(width: 8.w),  // SVG와 설명 문구 사이의 가로 간격을 8로 설정
            
            // 설명 문구 (Expanded로 감싸 남은 공간 모두 차지하도록)
            Expanded(
              child: Text(
                '타이어를 정확하게 볼 수 있도록 바닥면이 중앙에 오도록 하세요.',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 9.h), // 타이어 이미지 리스트와의 여백을 9로 설정

        // 타이어 이미지 리스트 렌더링
        const InstructionItemList(),
      ],
    );
  }
}