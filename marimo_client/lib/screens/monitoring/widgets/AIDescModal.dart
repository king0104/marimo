import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marimo_client/providers/navigation_provider.dart';
import 'package:marimo_client/screens/monitoring/widgets/WebviewScreen.dart';
import 'package:marimo_client/theme.dart';
import 'package:marimo_client/utils/text_utils.dart';
import 'package:provider/provider.dart';

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
    final keywordList = extractKeywordsFromTitle(title);

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        'assets/images/icons/icon_ai_bot.svg',
                        width: 30.w,
                        height: 30.h,
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          "$code - $title".withHangeulWordBreak(),
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: brandColor,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
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
            ...actionList.map((text) {
              final shouldHighlight = keywordList.any((k) => text.contains(k));
              return Padding(
                padding: EdgeInsets.only(bottom: 6.h),
                child: Text(
                  "· $text",
                  style: TextStyle(
                    fontSize: 14.sp,
                    height: 1.3.h,
                    color: shouldHighlight ? backgroundBlackColor : iconColor,
                    fontWeight:
                        shouldHighlight ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              );
            }),
            SizedBox(height: 24.h),

            // 버튼
            Container(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        final query = Uri.encodeComponent('$title 자동차 부품 가격비교');
                        final url =
                            'https://msearch.shopping.naver.com/search/all?query=$query';

                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => WebViewScreen(url: url),
                          ),
                        );
                      },
                      icon: Icon(Icons.search, size: 18.w, color: iconColor),
                      label: Text(
                        "정비 부품 찾기",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: backgroundBlackColor,
                        ),
                      ),
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
                      Navigator.of(context).pop(); // 모달 닫기 먼저
                      // context는 pop 전에 미리 저장해놓기
                      final navProvider = Provider.of<NavigationProvider>(
                        context,
                        listen: false,
                      );
                      Future.delayed(const Duration(milliseconds: 300), () {
                        navProvider.triggerRepairFilter(); // 🔥 필터 적용 요청
                        navProvider.setIndex(3); // Map 탭
                      });
                    },
                    child: Row(
                      children: [
                        Text(
                          "정비소 찾기",
                          style: TextStyle(fontSize: 14.sp, color: brandColor),
                        ),
                        SizedBox(width: 2.w),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 14.w,
                          color: brandColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<String> extractKeywordsFromTitle(String title) {
    final keywords = <String>[];

    if (title.contains("점화") || title.contains("스파크")) {
      keywords.addAll(["점화", "스파크", "플러그"]);
    }
    if (title.contains("배터리") || title.contains("충전")) {
      keywords.addAll(["배터리", "충전", "전압"]);
    }
    if (title.contains("센서")) {
      keywords.add("센서");
    }
    if (title.contains("연료")) {
      keywords.addAll(["연료", "인젝터", "연료펌프"]);
    }
    if (title.contains("산소")) {
      keywords.add("산소 센서");
    }

    return keywords;
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
