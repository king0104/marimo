import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyPageHeader extends StatelessWidget {
  const MyPageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '마이 페이지',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,  // 텍스트와 버튼을 양 끝으로 배치
          children: [
            Row(
              children: [
                Text(
                  '붕붕이',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 8.w),
                Container(
                  padding: EdgeInsets.only(left: 0.w, top: 8.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    '오너 김두철',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: const Color(0xFF4888FF),
                    ),
                  ),
                ),
              ],
            ),
            Padding( // Padding을 추가하여 위치를 아래로 조정
              padding: EdgeInsets.only(top: 4.h), // 버튼을 아래로 밀기
              child: TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 20.w),
                  minimumSize: Size(50.w, 20.h), // 최소 높이 설정
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  backgroundColor: Colors.white,
                  side: BorderSide(
                    color: Colors.black.withOpacity(0.2), // 아웃라인 설정
                    width: 1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r), // 모서리 둥글게
                  ),
                ),
                child: Text(
                  '정보 변경',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
