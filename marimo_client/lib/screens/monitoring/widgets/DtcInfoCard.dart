import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marimo_client/screens/monitoring/widgets/AIDescModal.dart';
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
            padding: EdgeInsets.only(
              left: 16.w,
              right: 8.w,
              top: 12.h,
              bottom: 12.h,
            ),
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
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder:
                                  (_) => AIDescModal(
                                    code: code,
                                    title: "엔진 실화 발생", // 실제 코드에 따라 다르게 처리 가능
                                    meaningList: [
                                      "불규칙한 실화(Misfire)가 여러 실린더에서 발생했어요.",
                                      "차량이 떨리거나 주행 성능이 저하될 수 있습니다.",
                                      "점화, 연료, 공기 공급 문제 또는 엔진 압축 저하가 원인일 수 있습니다.",
                                    ],
                                    actionList: [
                                      "운전 중이면, 즉시 가속 페달을 서서히 조절하며 안전한 장소로 이동하세요.",
                                      "차량이 심하게 떨리면, 엔진을 꺼주세요.",
                                      "점화 플러그, 점화 코일, 연료 시스템을 점검하세요.",
                                    ],
                                  ),
                            );
                          },
                          behavior: HitTestBehavior.translucent, // 터치 감지 확실히
                          child: Container(
                            padding: EdgeInsets.all(
                              12.w,
                            ), // 터치 범위 넓힘 (16~20도 가능)
                            alignment: Alignment.center, // 아이콘이 가운데 오게
                            child: SvgPicture.asset(
                              'assets/images/icons/icon_next_brand_16.svg',
                              width: 16.w,
                              height: 16.h,
                            ),
                          ),
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
