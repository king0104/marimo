import 'package:flutter/material.dart';
import 'package:marimo_client/screens/monitoring/widgets/TireDiagnosisButton.dart';

class MonitoringScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Monitoring Screen")),
      body: Center(child: TireDiagnosisButton()),
    );
  }
}
