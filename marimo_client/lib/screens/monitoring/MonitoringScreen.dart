import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marimo_client/screens/monitoring/widgets/TireDiagnosisButton.dart';
import 'package:marimo_client/screens/monitoring/widgets/Obd2InfoList.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    final upperHeight = 200.h + 16.h + 48.h + 16.h;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              height: showUpperWidgets ? upperHeight : 0,
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 200.h,
                    child: Image.asset(
                      'assets/images/cars/prius_top.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  SizedBox(
                    height: 48.h,
                    width: double.infinity,
                    child: const TireDiagnosisButton(),
                  ),
                  SizedBox(height: 16.h),
                ],
              ),
            ),
            Expanded(child: Obd2InfoList(onToggleWidgets: toggleUpperWidgets)),
          ],
        ),
      ),
    );
  }
}
