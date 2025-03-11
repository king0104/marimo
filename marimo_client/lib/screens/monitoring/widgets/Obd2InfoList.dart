import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marimo_client/screens/monitoring/widgets/DtcInfoCard.dart';
import 'package:marimo_client/screens/monitoring/widgets/StatusInfoCard.dart';
import 'package:marimo_client/screens/monitoring/widgets/ListToggle.dart'; // ✅ ListToggle 추가

class Obd2InfoList extends StatefulWidget {
  const Obd2InfoList({super.key});

  @override
  _Obd2InfoListState createState() => _Obd2InfoListState();
}

class _Obd2InfoListState extends State<Obd2InfoList> {
  bool showDtcInfo = true; // ✅ 현재 선택된 탭 (true = DTC, false = 상태 정보)

  // ✅ 더미 데이터 (샘플)
  final List<Map<String, String>> dtcData = [
    {"code": "P13E7FD", "description": "엔진열이 너무 높아요"},
    {"code": "P0420", "description": "촉매 변환 장치 문제"},
    {"code": "P0301", "description": "실린더 1번 점화 이상"},
  ];

  final List<Map<String, dynamic>> statusData = [
    {"icon": Icons.speed, "title": "속도", "value": "80 km/h"},
    {"icon": Icons.thermostat, "title": "엔진 온도", "value": "90°C"},
    {"icon": Icons.local_gas_station, "title": "연료 잔량", "value": "45%"},
    {"icon": Icons.battery_full, "title": "배터리 상태", "value": "12.6V"},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0x1A4888FF),
            blurRadius: 4.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        children: [
          // ✅ 토글과 OBD2 상세 버튼을 Row로 배치 (좌우 정렬)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // ✅ `ListToggle`의 크기를 고정
              SizedBox(
                width: 180.w, // ✅ 고정된 너비
                child: ListToggle(
                  isLeftSelected: showDtcInfo,
                  onLeftTap: () => setState(() => showDtcInfo = true),
                  onRightTap: () => setState(() => showDtcInfo = false),
                ),
              ),

              // ✅ OBD2 상세 버튼 (우측에 배치)
              GestureDetector(
                onTap: () {
                  debugPrint("🚀 OBD2 상세 버튼 클릭됨!");
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
                  child: Text(
                    "OBD2 상세",
                    style: TextStyle(
                      fontSize: 10.sp, // ✅ ListToggle 내부와 동일한 폰트 크기
                      fontWeight: FontWeight.w500, // ✅ 동일한 Weight 설정
                      fontFamily: 'YourFontFamily', // ✅ 동일한 폰트 패밀리 설정 (필요시 추가)
                      color: const Color(0xFF747474),
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          // ✅ 리스트 (고장 정보 / 상태 정보)
          Expanded(
            child: ListView.builder(
              itemCount: showDtcInfo ? dtcData.length : statusData.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child:
                      showDtcInfo
                          ? DtcInfoCard(
                            code: dtcData[index]["code"]!,
                            description: dtcData[index]["description"]!,
                          )
                          : StatusInfoCard(
                            icon: statusData[index]["icon"], // ✅ 아이콘 추가
                            title: statusData[index]["title"]!,
                            value: statusData[index]["value"]!,
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
