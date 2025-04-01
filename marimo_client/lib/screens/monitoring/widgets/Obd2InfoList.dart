import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marimo_client/screens/monitoring/Obd2DetailScreen.dart';
import 'package:marimo_client/screens/monitoring/widgets/DtcInfoCard.dart';
import 'package:marimo_client/screens/monitoring/widgets/StatusInfoCard.dart';
import 'package:marimo_client/screens/monitoring/widgets/ListToggle.dart';
import 'package:provider/provider.dart';
import 'package:marimo_client/providers/obd_polling_provider.dart';
import 'package:marimo_client/utils/obd_response_parser.dart';

class Obd2InfoList extends StatefulWidget {
  const Obd2InfoList({super.key});

  @override
  _Obd2InfoListState createState() => _Obd2InfoListState();
}

class _Obd2InfoListState extends State<Obd2InfoList> {
  bool showDtcInfo = true;
  int? selectedIndex;

  final List<Map<String, String>> dtcData = [
    {"code": "P13E7FD", "description": "엔진열이 너무 높아요"},
    {"code": "P0420", "description": "촉매 변환 장치 문제"},
    {"code": "P0301", "description": "실린더 1번 점화 이상"},
  ];

  @override
  Widget build(BuildContext context) {
    final responses = context.watch<ObdPollingProvider>().responses;
    final data = parseObdResponses(responses);

    final statusData = [
      {
        "icon": Icons.speed,
        "title": "속도",
        "value": data.speed != null ? "${data.speed} km/h" : "--",
      },
      {
        "icon": Icons.settings_input_composite,
        "title": "RPM",
        "value":
            data.rpm != null ? "${data.rpm!.toStringAsFixed(0)} rpm" : "--",
      },
      {
        "icon": Icons.thermostat,
        "title": "엔진 온도",
        "value":
            data.coolantTemp != null
                ? "${data.coolantTemp!.toStringAsFixed(1)}°C"
                : "--",
      },
      {
        "icon": Icons.local_gas_station,
        "title": "연료 잔량",
        "value":
            data.fuelLevel != null
                ? "${data.fuelLevel!.toStringAsFixed(1)}%"
                : "--",
      },
      {
        "icon": Icons.battery_charging_full,
        "title": "스로틀 포지션",
        "value":
            data.throttlePosition != null
                ? "${data.throttlePosition!.toStringAsFixed(1)}%"
                : "--",
      },
      {
        "icon": Icons.cloud,
        "title": "외기 온도",
        "value":
            data.ambientAirTemp != null
                ? "${data.ambientAirTemp!.toStringAsFixed(1)}°C"
                : "--",
      },
    ];

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFFD7D7D7), width: 0.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0x1A000000),
            blurRadius: 3.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 180.w,
                child: ListToggle(
                  isLeftSelected: showDtcInfo,
                  onLeftTap: () => setState(() => showDtcInfo = true),
                  onRightTap: () => setState(() => showDtcInfo = false),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Obd2DetailScreen(),
                    ),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
                  child: Text(
                    "OBD2 상세",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF747474),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Expanded(
            child: ListView.builder(
              itemCount: showDtcInfo ? dtcData.length : statusData.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child:
                      showDtcInfo
                          ? (() {
                            final item = dtcData[index];
                            return DtcInfoCard(
                              code: item["code"]!,
                              description: item["description"]!,
                              isSelected: selectedIndex == index,
                              onTap: () {
                                setState(() {
                                  selectedIndex =
                                      selectedIndex == index ? null : index;
                                });
                              },
                            );
                          })()
                          : StatusInfoCard(
                            icon: statusData[index]["icon"] as IconData,
                            title: statusData[index]["title"] as String,
                            value: statusData[index]["value"] as String,
                          ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
