import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marimo_client/screens/monitoring/widgets/TireDiagnosisButton.dart';
import 'package:marimo_client/screens/monitoring/widgets/Obd2InfoList.dart'; // ✅ OBD2 리스트 추가
import 'package:marimo_client/screens/monitoring/widgets/Car3DModel.dart'; // ✅ 3D 자동차 모델 추가

class MonitoringScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w), // ✅ 좌우 패딩 20.w 적용
        child: Column(
          children: [
            // SizedBox(
            //   width: double.infinity, // ✅ 3D 모델 전체 너비 확장
            //   height: 200.h, // ✅ 적절한 높이 설정
            //   child: Car3DModel(), // ✅ 새로 추가된 위젯 (예: 3D 자동차 모델)
            // ),
            SizedBox(height: 16.sp), // ✅ 요소 간의 간격 조정
            SizedBox(
              width: double.infinity, // ✅ 버튼 가로 크기 확장
              child: TireDiagnosisButton(),
            ),
            SizedBox(height: 16.sp), // ✅ 두 요소 사이의 gap (16.sp)
            Expanded(
              flex: 3, // ✅ OBD2 리스트가 더 많은 공간을 차지하도록 설정
              child: Obd2InfoList(),
            ),
          ],
        ),
      ),
    );
  }
}
