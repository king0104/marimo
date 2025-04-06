import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marimo_client/theme.dart';

class AIDescModal extends StatelessWidget {
  final String code;
  final String title;
  final List<String> meaningList;
  final List<String> actionList;

  const AIDescModal({
    super.key,
    required this.code,
    required this.title,
    required this.meaningList,
    required this.actionList,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상단 제목 바
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/images/icons/icon_ai_bot.svg',
                      width: 30.w,
                      height: 30.h,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      "$code - $title",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: pointRedColor,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Icon(Icons.close, size: 20.w),
                ),
              ],
            ),
            SizedBox(height: 20.h),

            // 🔴 의미 설명
            _SectionTitle(icon: "🚨", title: "이 상태는 무엇을 의미하나요?"),
            ...meaningList.map(
              (text) => Padding(
                padding: EdgeInsets.only(bottom: 6.h),
                child: Text(
                  "· $text",
                  style: TextStyle(
                    fontSize: 14.sp,
                    height: 1.3.h,
                    color: iconColor,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),

            // 🛠 조치 설명
            _SectionTitle(icon: "🛠", title: "그럼 어떻게 해야 하나요?"),
            ...actionList.map(
              (text) => Padding(
                padding: EdgeInsets.only(bottom: 6.h),
                child: Text(
                  "· $text",
                  style: TextStyle(
                    fontSize: 14.sp,
                    height: 1.3.h,
                    color:
                        text.contains("점화") ? backgroundBlackColor : iconColor,
                    fontWeight:
                        text.contains("점화") ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ),
            SizedBox(height: 24.h),

            // 버튼
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // 공식 부품 찾기
                    },
                    icon: Icon(Icons.search),
                    label: Text("공식 부품 찾기"),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: const Color(0xFFF2F2F2),
                      elevation: 0,
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                TextButton(
                  onPressed: () {
                    // 정비소 찾기
                  },
                  child: Row(
                    children: [
                      Text("정비소 찾기", style: TextStyle(fontSize: 14.sp)),
                      Icon(Icons.arrow_forward_ios, size: 14.w),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String icon;
  final String title;

  const _SectionTitle({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          Text(icon, style: TextStyle(fontSize: 16.sp)),
          SizedBox(width: 6.w),
          Text(
            title,
            style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
