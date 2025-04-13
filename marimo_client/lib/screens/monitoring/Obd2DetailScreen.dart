import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marimo_client/commons/AppBar.dart';
import 'package:marimo_client/commons/CustomAppHeader.dart';
import 'package:marimo_client/screens/monitoring/widgets/ObdSearchBar.dart';
import 'package:marimo_client/utils/obd_response_parser.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:marimo_client/theme.dart';
import 'package:marimo_client/providers/obd_polling_provider.dart';

class Obd2DetailScreen extends StatefulWidget {
  const Obd2DetailScreen({super.key});

  @override
  State<Obd2DetailScreen> createState() => _Obd2DetailScreenState();
}

class _Obd2DetailScreenState extends State<Obd2DetailScreen> {
  int? selectedIndex;
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ObdPollingProvider>();
    final responses = provider.responses;
    final parsed = parseObdResponses(responses);

    final List<Map<String, dynamic>> obdItems = [
      {"title": "RPM", "value": parsed.rpm, "unit": "rpm"},
      {"title": "속도", "value": parsed.speed, "unit": "km/h"},
      {"title": "엔진 부하", "value": parsed.engineLoad, "unit": "%"},
      {"title": "냉각수 온도", "value": parsed.coolantTemp, "unit": "°C"},
      {"title": "단기 연료 트림", "value": parsed.shortTermFuelTrim, "unit": "%"},
      {"title": "장기 연료 트림", "value": parsed.longTermFuelTrim, "unit": "%"},
      {"title": "흡기 매니폴드 압력", "value": parsed.intakePressure, "unit": "kPa"},
      {"title": "점화 시기", "value": parsed.timingAdvance, "unit": "°"},
      {"title": "흡기 온도", "value": parsed.intakeTemp, "unit": "°C"},
      {"title": "MAF 유량", "value": parsed.maf, "unit": "g/s"},
      {"title": "스로틀 위치", "value": parsed.throttlePosition, "unit": "%"},
      {"title": "연료 잔량", "value": parsed.fuelLevel, "unit": "%"},
      {"title": "연료 레일 압력", "value": parsed.fuelRailPressure, "unit": "kPa"},
      {"title": "연료 온도", "value": parsed.fuelTemp, "unit": "°C"},
      {"title": "증기 압력", "value": parsed.vaporPressure, "unit": "kPa"},
      {"title": "대기압", "value": parsed.barometricPressure, "unit": "kPa"},
      {"title": "ECM 온도", "value": parsed.ecmTemp, "unit": "°C"},
      {
        "title": "DTC 삭제 후 주행거리",
        "value": parsed.distanceSinceCodesCleared,
        "unit": "km",
      },
      {"title": "O2 센서 전압", "value": parsed.o2SensorVoltage, "unit": "V"},
      {"title": "NOx 센서", "value": parsed.noxSensor, "unit": "ppm"},
      {"title": "배터리 전압", "value": parsed.batteryVoltage, "unit": "V"},
      {"title": "엔진 실행 시간", "value": parsed.runTime, "unit": "초"},
      {"title": "제어 모듈 전압", "value": parsed.controlModuleVoltage, "unit": "V"},
      {"title": "부하 비율", "value": parsed.loadValue, "unit": "%"},
      {"title": "연료 주입 타이밍", "value": parsed.fuelInjectionTiming, "unit": "ms"},
      {"title": "점화 시기 조정", "value": parsed.ignitionTimingAdjust, "unit": "°"},
      {"title": "외기 온도", "value": parsed.ambientAirTemp, "unit": "°C"},
      {
        "title": "연료 주입량",
        "value": parsed.fuelInjectionQuantity,
        "unit": "mg/str",
      },
      {
        "title": "연료 인젝터 압력",
        "value": parsed.fuelInjectorPressure,
        "unit": "kPa",
      },
      {"title": "연료 타입", "value": parsed.fuelType, "unit": ""},
      {"title": "엔진 오일 온도", "value": parsed.engineOilTemp, "unit": "°C"},
      {"title": "연료 필터 압력", "value": parsed.fuelFilterPressure, "unit": "kPa"},
      {"title": "터보 압력", "value": parsed.turboPressure, "unit": "kPa"},
      {"title": "브레이크 압력", "value": parsed.brakePressure, "unit": "kPa"},
      {"title": "주행 가능 거리", "value": parsed.distanceToEmpty, "unit": "km"},
      {
        "title": "하이브리드 배터리 전압",
        "value": parsed.hybridBatteryVoltage,
        "unit": "V",
      },
      {"title": "DPF 온도", "value": parsed.dpfTemp, "unit": "°C"},
      {"title": "DPF 압력", "value": parsed.dpfPressure, "unit": "kPa"},
      {"title": "SCR 상태", "value": parsed.scrStatus, "unit": ""},
      {"title": "SCR 온도", "value": parsed.scrTemp, "unit": "°C"},
    ];

    final filteredItems =
        obdItems.where((item) {
          final title = item["title"]?.toLowerCase() ?? '';
          final value = item["value"]?.toString().toLowerCase() ?? '';
          return title.contains(_searchQuery) || value.contains(_searchQuery);
        }).toList();

    return Scaffold(
      appBar: CustomAppHeader(
        title: 'OBD2 상세 데이터',
        onBackPressed: () => Navigator.of(context).pop(),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            ObdSearchBar(
              hintText: "코드 검색",
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredItems.length,
                itemBuilder: (_, index) {
                  final isSelected = selectedIndex == index;
                  final item = filteredItems[index];
                  final rawValue = item["value"];
                  final displayValue =
                      rawValue == null
                          ? "--"
                          : rawValue is double
                          ? rawValue.toStringAsFixed(1)
                          : rawValue is int
                          ? NumberFormat.decimalPattern().format(rawValue)
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
                          duration: const Duration(milliseconds: 250),
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
