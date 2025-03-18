// Instruction.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart'; // SVG 파일을 사용하기 위한 패키지 추가
import 'instructionimagelist.dart';

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
            // SVG 이미지
            SvgPicture.asset('assets/images/icons/icon_instruction.svg'),
            
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

        SizedBox(height: 15.h), // 🔹 타이어 이미지 리스트와의 여백을 18로 설정

        // 🔹 타이어 이미지 리스트 3번 반복 렌더링
        const InstructionImageList(),
      ],
    );
  }

  Widget _buildInstructionItem(
    String text,
    String? goodImagePath,
    String? badImagePath1,
    String? badImagePath2, {
    bool hasImages = true,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 2.h),
          child: SvgPicture.asset(
            'assets/images/icons/icon_instruction.svg',
            width: 18.sp,
            height: 18.sp,
            color: Colors.blue,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Colors.black87,
                ),
              ),
              if (hasImages) ...[
                SizedBox(height: 8.h),
                Row(
                  children: [
                    if (goodImagePath != null)
                      _buildExampleImage(goodImagePath, true),
                    if (badImagePath1 != null)
                      _buildExampleImage(badImagePath1, false),
                    if (badImagePath2 != null)
                      _buildExampleImage(badImagePath2, false),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExampleImage(String imagePath, bool isGood) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.w),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.asset(
                imagePath,
                height: 80.h,
                fit: BoxFit.cover,
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
                size: 14.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}