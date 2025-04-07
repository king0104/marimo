import 'package:flutter/material.dart';
import 'package:marimo_client/models/obd_data_model.dart';
import 'package:marimo_client/utils/warning_storage.dart';

class ObdAnalysisItem {
  final IconData icon;
  final String title;
  final String description;
  final String status;

  ObdAnalysisItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.status,
  });
}

class ObdAnalysisProvider with ChangeNotifier {
  List<ObdAnalysisItem> _statusItems = [];
  List<ObdAnalysisItem> get statusItems => _statusItems;

  Future<void> analyze(ObdDataModel d) async {
    final items = <ObdAnalysisItem>[];

    // 1. 공기 유량
    if (d.speed != null && d.rpm != null && d.maf != null) {
      String status = "정상";
      String description = "공기 유량: ${d.maf!.toStringAsFixed(1)} g/s";
      String title = "공기 유량이 정상이에요";

      if (d.speed! < 5 && d.rpm! < 1000) {
        if (d.maf! < 2 || d.maf! > 7) {
          status = "주의";
          title = "공기 유량이 비정상이에요";
          description =
              "공회전 상태에서 MAF(${d.maf!.toStringAsFixed(1)} g/s)가 기준(2~7) 벗어남";
        }
      } else if (d.speed! >= 20 && d.speed! <= 40) {
        if (d.maf! < 10 || d.maf! > 20) {
          status = "주의";
          title = "공기 유량이 기준 범위에서 벗어났어요";
          description =
              "시속 ${d.speed}km 주행 중 MAF ${d.maf!.toStringAsFixed(1)}g/s는 10~20 범위 이탈";
        }
      }

      if (status == "주의") {
        await WarningStorage.saveWarning({
          "title": title,
          "description": description,
          "status": status,
        });
      }

      items.add(
        ObdAnalysisItem(
          icon: Icons.air,
          title: title,
          description: description,
          status: status,
        ),
      );

      (
        icon: Icons.cloud,
        title: title,
        description: description,
        status: status,
      );
    }

    // 2. 연료 트림
    if (d.coolantTemp != null &&
        d.shortTermFuelTrim != null &&
        d.longTermFuelTrim != null) {
      String status = "정상";
      String title = "연료 분사 상태가 정상이에요";
      String description =
          "STFT: ${d.shortTermFuelTrim!.toStringAsFixed(1)}%, LTFT: ${d.longTermFuelTrim!.toStringAsFixed(1)}%";

      if (d.shortTermFuelTrim!.abs() > 20 || d.longTermFuelTrim!.abs() > 20) {
        status = "주의";
        title = "연료 분사량이 비정상적이에요";
        description = "STFT/LTFT 값이 ±20%를 초과하고 있습니다.";
      }

      if (status == "주의") {
        await WarningStorage.saveWarning({
          "title": title,
          "description": description,
          "status": status,
        });
      }

      items.add(
        ObdAnalysisItem(
          icon: Icons.local_gas_station,
          title: title,
          description: description,
          status: status,
        ),
      );
    }

    // 3. 스로틀 반응
    if (d.throttlePosition != null && d.rpm != null && d.speed != null) {
      String status = "정상";
      String title = "스로틀과 엔진 반응이 정상이에요";
      String description =
          "스로틀: ${d.throttlePosition!.toStringAsFixed(1)}%, RPM: ${d.rpm!.toStringAsFixed(0)}";

      if (d.throttlePosition! > 30 && d.rpm! < 1000) {
        status = "주의";
        title = "스로틀을 밟았는데 반응이 느려요";
        description =
            "스로틀 ${d.throttlePosition!.toStringAsFixed(1)}%인데 RPM ${d.rpm!.toStringAsFixed(0)}";
      }

      if (status == "주의") {
        await WarningStorage.saveWarning({
          "title": title,
          "description": description,
          "status": status,
        });
      }

      items.add(
        ObdAnalysisItem(
          icon: Icons.speed,
          title: title,
          description: description,
          status: status,
        ),
      );
    }

    // 4. 산소 센서
    if (d.o2SensorVoltage != null &&
        d.shortTermFuelTrim != null &&
        d.longTermFuelTrim != null) {
      String status = "정상";
      String title = "산소 센서 반응이 정상이에요";
      String description =
          "O2 센서 전압: ${d.o2SensorVoltage!.toStringAsFixed(2)}V";

      if (d.o2SensorVoltage! < 0.1 || d.o2SensorVoltage! > 0.9) {
        status = "주의";
        title = "산소 센서 전압이 비정상이에요";
        description =
            "전압 ${d.o2SensorVoltage!.toStringAsFixed(2)}V로 정상 범위 이탈 (0.1~0.9V)";
      }

      if (status == "주의") {
        await WarningStorage.saveWarning({
          "title": title,
          "description": description,
          "status": status,
        });
      }

      items.add(
        ObdAnalysisItem(
          icon: Icons.sensors,
          title: title,
          description: description,
          status: status,
        ),
      );
    }

    // 5. 배출가스 시스템
    if (d.noxSensor != null) {
      String status = "정상";
      String title = "배출가스 제어 시스템이 정상이에요";
      String description = "NOx 센서: ${d.noxSensor!.toStringAsFixed(0)} ppm";

      if (d.noxSensor! > 200) {
        status = "주의";
        title = "NOx 배출이 높아요";
        description =
            "NOx 센서 ${d.noxSensor!.toStringAsFixed(0)} ppm (기준 200ppm 초과)";
      }

      if (status == "주의") {
        await WarningStorage.saveWarning({
          "title": title,
          "description": description,
          "status": status,
        });
      }

      items.add(
        ObdAnalysisItem(
          icon: Icons.cloud,
          title: title,
          description: description,
          status: status,
        ),
      );
    }

    // 6. 연비 성능
    if (d.speed != null &&
        d.fuelLevel != null &&
        d.distanceSinceCodesCleared != null) {
      String status = "정상";
      String title = "현재 연비 성능은 양호해요";
      String description = "";

      double? fuelUsed =
          d.fuelLevel != null && d.fuelLevel! > 0 ? (100 - d.fuelLevel!) : null;

      if (fuelUsed != null &&
          fuelUsed > 0 &&
          d.distanceSinceCodesCleared! > 0) {
        double avgFuelEff = d.distanceSinceCodesCleared! / fuelUsed;
        description = "최근 주행에서 연료 효율이 안정적이었어요.";

        if (avgFuelEff < 10) {
          status = "주의";
          title = "연비가 낮은 편이에요";
        }
      } else {
        description = "정확한 연비를 계산할 수 없어요. 추정값 기준으로 분석됩니다.";
      }

      if (status == "주의") {
        await WarningStorage.saveWarning({
          "title": title,
          "description": description,
          "status": status,
        });
      }

      items.add(
        ObdAnalysisItem(
          icon: Icons.local_offer,
          title: title,
          description: description,
          status: status,
        ),
      );
    }

    // 7. 연료 상태
    if (d.fuelLevel != null && d.distanceSinceCodesCleared != null) {
      String status = "정상";
      String title = "연료 상태가 정상이에요";
      String description =
          "연료 잔량: ${d.fuelLevel!.toStringAsFixed(1)}%, 주행거리: ${d.distanceSinceCodesCleared}km";

      if (d.fuelLevel! < 10) {
        status = "주의";
        title = "연료 잔량이 낮아요";
        description += "\n연료가 거의 없습니다. 가까운 주유소를 찾아주세요.";
      }

      if (status == "주의") {
        await WarningStorage.saveWarning({
          "title": title,
          "description": description,
          "status": status,
        });
      }

      items.add(
        ObdAnalysisItem(
          icon: Icons.ev_station,
          title: title,
          description: description,
          status: status,
        ),
      );
    }
    // 8. 흡기/배기 흐름
    if (d.intakePressure != null && d.barometricPressure != null) {
      String status = "정상";
      String title = "흡기와 배기 흐름이 정상이에요";
      String description =
          "흡기 압력: ${d.intakePressure!.toStringAsFixed(1)}kPa, 대기압: ${d.barometricPressure!.toStringAsFixed(1)}kPa";

      final diff = (d.intakePressure! - d.barometricPressure!).abs();

      if (diff < 5) {
        status = "주의";
        title = "흡기 흐름에 문제가 있을 수 있어요";
        description += "\n흡기 압력과 대기압이 거의 같아, 공기 유입 경로에 문제가 있는지 점검이 필요해요.";
      }

      if (status == "주의") {
        await WarningStorage.saveWarning({
          "title": title,
          "description": description,
          "status": status,
        });
      }

      items.add(
        ObdAnalysisItem(
          icon: Icons.waves,
          title: title,
          description: description,
          status: status,
        ),
      );
    }
    // 9. ECU 전압
    if (d.controlModuleVoltage != null) {
      String status = "정상";
      String title = "ECU 전압이 정상이에요";
      String description = "전압: ${d.controlModuleVoltage!.toStringAsFixed(2)}V";

      final voltage = d.controlModuleVoltage!;

      if (voltage < 12.6) {
        status = "주의";
        title = "ECU 전압이 낮아요";
        description += "\n전압이 12.6V보다 낮아, 배터리 성능 저하 또는 방전 가능성이 있어요.";
      } else if (voltage > 14.7) {
        status = "주의";
        title = "충전 시스템 전압이 높아요";
        description += "\n전압이 14.7V를 초과하여, 알터네이터 과출력 또는 레귤레이터 이상 가능성이 있어요.";
      }

      if (status == "주의") {
        await WarningStorage.saveWarning({
          "title": title,
          "description": description,
          "status": status,
        });
      }

      items.add(
        ObdAnalysisItem(
          icon: Icons.battery_full,
          title: title,
          description: description,
          status: status,
        ),
      );
    }
    // 11. 예열 후 가속
    if (d.coolantTemp != null && d.throttlePosition != null) {
      String status = "정상";
      String title = "예열 후 안정적으로 가속하고 있어요";
      String description =
          "냉각수 온도: ${d.coolantTemp!.toStringAsFixed(1)}°C, 스로틀: ${d.throttlePosition!.toStringAsFixed(1)}%";

      if (d.coolantTemp! < 30 && d.throttlePosition! > 40) {
        status = "주의";
        title = "예열 없이 급가속 중이에요";
        description += "\n엔진이 충분히 데워지지 않은 상태에서 가속 중입니다. 엔진 마모 위험이 있어요.";
      }

      if (status == "주의") {
        await WarningStorage.saveWarning({
          "title": title,
          "description": description,
          "status": status,
        });
      }

      items.add(
        ObdAnalysisItem(
          icon: Icons.thermostat,
          title: title,
          description: description,
          status: status,
        ),
      );
    }
    // 12. DPF 상태
    if (d.dpfTemp != null && d.dpfPressure != null) {
      String status = "정상";
      String title = "DPF 상태가 정상이에요";
      String description =
          "DPF 온도: ${d.dpfTemp!.toStringAsFixed(0)}°C, 압력: ${d.dpfPressure!.toStringAsFixed(1)}kPa";

      if (d.dpfTemp! < 250 && d.dpfPressure! > 10) {
        status = "주의";
        title = "DPF 재생이 원활하지 않아요";
        description += "\n온도가 낮고 압력이 높아 재생이 제대로 이루어지지 않고 있을 수 있어요.";
      } else if (d.dpfPressure! > 20) {
        status = "주의";
        title = "DPF 막힘이 의심돼요";
        description += "\nDPF 내부 압력이 높습니다. 재생 실패나 막힘 가능성이 있어요.";
      }

      if (status == "주의") {
        await WarningStorage.saveWarning({
          "title": title,
          "description": description,
          "status": status,
        });
      }

      items.add(
        ObdAnalysisItem(
          icon: Icons.fireplace,
          title: title,
          description: description,
          status: status,
        ),
      );
    }

    _statusItems = items;
    notifyListeners();
  }
}
