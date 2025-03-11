import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DtcInfoCard extends StatelessWidget {
  final String code;
  final String description;

  const DtcInfoCard({super.key, required this.code, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5), // ✅ 배경색 (Figma 스타일)
        borderRadius: BorderRadius.circular(8.r), // ✅ 둥근 모서리
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ 고장 코드 (작은 글씨)
          Text(
            code,
            style: TextStyle(
              fontSize: 8.sp,
              fontWeight: FontWeight.w300,
              color: const Color(0xFF7E7E7E),
            ),
          ),
          SizedBox(height: 6.h), // 간격
          // ✅ 고장 코드 설명 (큰 글씨)
          Text(
            description,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF000000),
            ),
          ),
        ],
      ),
    );
  }
}
