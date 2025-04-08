import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marimo_client/screens/monitoring/widgets/TireDiagnosisButton.dart';
import 'package:marimo_client/screens/monitoring/widgets/Obd2InfoList.dart';
import 'package:marimo_client/providers/car_provider.dart';

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
  Widget build(BuildContext context) {
    final carProvider = Provider.of<CarProvider>(context);
    final car = carProvider.cars.isNotEmpty ? carProvider.cars.first : null;

    final upperHeight = 200.h + 16.h + 48.h + 16.h;

    if (car != null) {
      print(car.brandId);
      print(car.modelName);
    }

    String getTopImageAsset(String model) {
      final Map<String, String> modelTopImageMap = {
        "모닝": "assets/images/cars/morning_top.png",
        "레이": "assets/images/cars/ray_top.png",
        "K3": "assets/images/cars/k3_top.png",
        "K5": "assets/images/cars/k5_top.png",
        "K7": "assets/images/cars/k7_top.png",
        "K9": "assets/images/cars/k9_top.png",
        "셀토스": "assets/images/cars/seltos_top.png",
        "니로": "assets/images/cars/niro_top.png",
        "스포티지": "assets/images/cars/sportage_top.png",
        "쏘렌토": "assets/images/cars/sorento_top.png",
        "모하비": "assets/images/cars/mohave_top.png",
        "아반떼": "assets/images/cars/avante_top.png",
        "쏘나타": "assets/images/cars/sonata_top.png",
        "그랜저": "assets/images/cars/grandeur_top.png",
        "에쿠스": "assets/images/cars/equus_top.png",
        "제네시스": "assets/images/cars/genesis_top.png",
        "베뉴": "assets/images/cars/venue_top.png",
        "코나": "assets/images/cars/kona_top.png",
        "투싼": "assets/images/cars/tucson_top.png",
        "산타페": "assets/images/cars/santafe_top.png",
        "팰리세이드": "assets/images/cars/palisade_top.png",
        "프리우스": "assets/images/cars/prius_top.png",
      };

      const fallback = "assets/images/cars/sonata_top.png";

      final normalizedModel = model.trim().toLowerCase();

      for (final entry in modelTopImageMap.entries) {
        if (normalizedModel.contains(entry.key.toLowerCase())) {
          print('✅ 매칭됨: ${entry.key} → ${entry.value}');
          return entry.value;
        }
      }

      print('⚠️ fallback 사용됨: $normalizedModel');
      return fallback;
    }

    final topImage =
        car != null
            ? getTopImageAsset(car.modelName ?? '')
            : 'assets/images/cars/sonata_top.png';

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
                    child: Image.asset(topImage, fit: BoxFit.cover),
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
