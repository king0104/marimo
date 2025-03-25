import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marimo_client/theme.dart';

class DtcInfoCard extends StatelessWidget {
  final String code;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  const DtcInfoCard({
    super.key,
    required this.code,
    required this.description,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 250),
            width: double.infinity,
            height: 80.h, // ✅ 고정 높이
            margin: EdgeInsets.only(bottom: 12.h),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color:
                  isSelected
                      ? const Color(0xFFE8F0FF)
                      : const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(8.r),
              border:
                  isSelected
                      ? Border.all(color: brandColor, width: 0.5.w)
                      : null,
            ),
            child:
                isSelected
                    ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                              'assets/images/icons/icon_ai_bot.svg',
                              width: 24.w,
                              height: 24.h,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              "빠르게 AI 챗봇으로 알아보기",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400,
                                color: brandColor,
                              ),
                            ),
                          ],
                        ),
                        SvgPicture.asset(
                          'assets/images/icons/icon_next_brand_16.svg',
                          width: 16.w,
                          height: 16.h,
                        ),
                      ],
                    )
                    : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center, // ✅ 중앙 정렬
                      children: [
                        Text(
                          code,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w300,
                            color: iconColor,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          description,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: black,
                          ),
                        ),
                      ],
                    ),
          ),

          Positioned(
            top: 0,
            right: 0,
            child: SvgPicture.asset(
              isSelected
                  ? 'assets/images/icons/corner_brand_white.svg'
                  : 'assets/images/icons/corner_grey_white.svg',
              width: 16.w,
              height: 16.h,
            ),
          ),
        ],
      ),
    );
  }
}
