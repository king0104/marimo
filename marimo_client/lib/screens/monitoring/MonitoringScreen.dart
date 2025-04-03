import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marimo_client/screens/monitoring/widgets/TireDiagnosisButton.dart';
import 'package:marimo_client/screens/monitoring/widgets/Obd2InfoList.dart';
import 'package:marimo_client/screens/monitoring/widgets/Car3DModel.dart';
import 'package:marimo_client/providers/obd_polling_provider.dart';

class MonitoringScreen extends StatefulWidget {
  const MonitoringScreen({super.key});

  @override
  State<MonitoringScreen> createState() => _MonitoringScreenState();
}

class _MonitoringScreenState extends State<MonitoringScreen>
    with TickerProviderStateMixin {
  bool showUpperWidgets = true;

  void toggleUpperWidgets() {
    setState(() {
      showUpperWidgets = !showUpperWidgets;
    });
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final provider = context.read<ObdPollingProvider>();
      await provider.loadResponsesFromLocal(); // 이전 값 먼저 불러오고
      if (provider.isConnected) {
        provider.startPolling(); // 연결돼 있으면 실시간 시작
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final upperHeight = 200.h + 16.h + 48.h + 16.h; // 위 요소 총 높이
    final safeTop = 60.h; // 상단 여백

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            /// ✅ 위쪽 전체를 AnimatedContainer로 감싸서 height 조절
            AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              height: showUpperWidgets ? upperHeight : 0,
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 200.h,
                    child: Car3DModel(),
                  ),
                  SizedBox(height: 16.h),
                  SizedBox(
                    height: 48.h,
                    width: double.infinity,
                    child: TireDiagnosisButton(),
                  ),
                  SizedBox(height: 16.h),
                ],
              ),
            ),

            /// ✅ Obd2InfoList는 남은 높이로 늘어남
            Expanded(child: Obd2InfoList(onToggleWidgets: toggleUpperWidgets)),
          ],
        ),
      ),
    );
  }
}
