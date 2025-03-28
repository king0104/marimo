import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:marimo_client/providers/obd_data_provider.dart';
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
    final obd = context.watch<ObdDataProvider>();
    final data = obd.data;

    final List<Map<String, dynamic>> obdItems = [
      {"title": "RPM", "value": data.rpm, "unit": "rpm"},
      {"title": "속도", "value": data.speed, "unit": "km/h"},
      {"title": "엔진 부하", "value": data.engineLoad, "unit": "%"},
      {"title": "냉각수 온도", "value": data.coolantTemp, "unit": "°C"},
      {"title": "스로틀 포지션", "value": data.throttlePosition, "unit": "%"},
      {"title": "흡기 온도", "value": data.intakeTemp, "unit": "°C"},
      {"title": "MAF 유량", "value": data.maf, "unit": "g/s"},
      {"title": "연료 잔량", "value": data.fuelLevel, "unit": "%"},
      {"title": "점화 타이밍", "value": data.timingAdvance, "unit": "°"},
      {"title": "기압", "value": data.barometricPressure, "unit": "kPa"},
      {"title": "외기 온도", "value": data.ambientAirTemp, "unit": "°C"},
      {"title": "연료 압력", "value": data.fuelPressure, "unit": "kPa"},
      {"title": "흡기 압력", "value": data.intakePressure, "unit": "kPa"},
      {"title": "엔진 작동 시간", "value": data.runTime, "unit": "초"},
      {
        "title": "DTC 클리어 후 거리",
        "value": data.distanceSinceCodesCleared,
        "unit": "km",
      },
      {"title": "MIL 이후 거리", "value": data.distanceWithMIL, "unit": "km"},
      {"title": "연료 종류", "value": data.fuelType, "unit": ""},
      {"title": "엔진 오일 온도", "value": data.engineOilTemp, "unit": "°C"},
    ];

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
                _iconButton(
                  'assets/images/icons/icon_chatbot_grey_22.svg',
                  () {},
                ),
                SizedBox(width: 8.w),
                _iconButton(
                  'assets/images/icons/icon_alarm_grey_22.svg',
                  () {},
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
                  _iconButton(
                    'assets/images/icons/icon_search_24_grey.svg',
                    () {
                      // 검색 버튼 동작
                    },
                  ),
                ],
              ),
            ),

            // 📋 데이터 카드 리스트
            Expanded(
              child: ListView.builder(
                itemCount: obdItems.length,
                itemBuilder: (_, index) {
                  final isSelected = selectedIndex == index;
                  final item = obdItems[index];
                  final rawValue = item["value"];
                  final displayValue =
                      rawValue == null
                          ? "--"
                          : rawValue is double
                          ? rawValue.toStringAsFixed(1)
                          : rawValue.toString();

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = isSelected ? null : index;
                      });
                    },
                    child: Stack(
                      children: [
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
                                    children: [
                                      Text(
                                        item["title"],
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w300,
                                          color: black,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            displayValue,
                                            style: TextStyle(
                                              fontSize: 20.sp,
                                              color: brandColor,
                                              fontWeight: FontWeight.w700,
                                              height: 1,
                                            ),
                                          ),
                                          SizedBox(width: 16.w),
                                          Text(
                                            item["unit"],
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

  Widget _iconButton(String assetPath, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(8.w),
          child: SvgPicture.asset(assetPath, width: 22.w, height: 22.h),
        ),
      ),
    );
  }
}
