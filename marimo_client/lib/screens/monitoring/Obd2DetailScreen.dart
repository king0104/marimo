import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marimo_client/theme.dart';

class Obd2DetailScreen extends StatefulWidget {
  const Obd2DetailScreen({super.key});

  @override
  State<Obd2DetailScreen> createState() => _Obd2DetailScreenState();
}

class _Obd2DetailScreenState extends State<Obd2DetailScreen> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("OBD2 상세"),
        titleTextStyle: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.w500,
          color: black,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/images/icons/icon_back_grey_22.svg',
            width: 22.w,
            height: 22.h,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: Row(
              children: [
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () {},
                    child: Padding(
                      padding: EdgeInsets.all(8.w),
                      child: SvgPicture.asset(
                        'assets/images/icons/icon_chatbot_grey_22.svg',
                        width: 22.w,
                        height: 22.h,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () {},
                    child: Padding(
                      padding: EdgeInsets.all(8.w),
                      child: SvgPicture.asset(
                        'assets/images/icons/icon_alarm_grey_22.svg',
                        width: 22.w,
                        height: 22.h,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        elevation: 0,
        backgroundColor: white,
        foregroundColor: black,
        toolbarHeight: 60.h,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            // 🔍 검색창
            Container(
              margin: EdgeInsets.symmetric(vertical: 16.h),
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              height: 45.h,
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(49),
                border: Border.all(color: lightgrayColor, width: 0.5),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "코드 검색",
                        hintStyle: TextStyle(
                          color: lightgrayColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w300,
                        ),
                        border: InputBorder.none,
                        isCollapsed: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        // 🔍 검색 버튼 동작
                      },
                      child: Padding(
                        padding: EdgeInsets.all(4.w),
                        child: SvgPicture.asset(
                          'assets/images/icons/icon_search_24_grey.svg',
                          width: 24.w,
                          height: 24.h,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (_, index) {
                  final isSelected = selectedIndex == index;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = isSelected ? null : index;
                      });
                    },
                    child: Stack(
                      children: [
                        // 카드 본체
                        AnimatedContainer(
                          height: 60.h,
                          duration: Duration(milliseconds: 250),
                          margin: EdgeInsets.only(bottom: 12.h),
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 18.h,
                          ),
                          decoration: BoxDecoration(
                            color:
                                isSelected
                                    ? const Color(0xFFE8F0FF)
                                    : const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(8.sp),
                            border:
                                isSelected
                                    ? Border.all(
                                      color: brandColor,
                                      width: 0.5.sp,
                                    )
                                    : null,
                          ),
                          child:
                              isSelected
                                  ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          SvgPicture.asset(
                                            'assets/images/icons/icon_ai_bot.svg',
                                            width: 24.w,
                                            height: 24.h,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            "빠르게 AI 챗봇으로 알아보기",
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w300,
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
                                  : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "엔진 부하",
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w300,
                                          color: black,
                                        ),
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            "91.40",
                                            style: TextStyle(
                                              fontSize: 20.sp,
                                              color: brandColor,
                                              fontWeight: FontWeight.w700,
                                              height: 1,
                                            ),
                                          ),
                                          SizedBox(width: 16.w),
                                          Text(
                                            "%",
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              color: iconColor,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                        ),

                        // 오른쪽 위 코너 SVG
                        Positioned(
                          top: 0,
                          right: 0,
                          child: SvgPicture.asset(
                            isSelected
                                ? 'assets/images/icons/corner_brand.svg'
                                : 'assets/images/icons/corner_grey.svg',
                            width: 16.w,
                            height: 16.h,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
