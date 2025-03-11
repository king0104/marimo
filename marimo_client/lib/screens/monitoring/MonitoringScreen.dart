import 'package:flutter/material.dart';
import 'package:marimo_client/screens/monitoring/widgets/TireDiagnosisButton.dart';

class MonitoringScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Monitoring Screen")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20), // ✅ 좌우 패딩 20px 적용
        child: Center(child: TireDiagnosisButton()),
      ),
    );
  }
}
