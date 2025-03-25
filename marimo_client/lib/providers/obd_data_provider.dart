import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import '../models/obd_data_model.dart';

class ObdDataProvider extends ChangeNotifier {
  BluetoothConnection? _connection;
  bool isConnected = false;
  ObdDataModel _data = ObdDataModel();
  ObdDataModel get data => _data;

  Future<void> connect(BluetoothDevice device) async {
    try {
      _connection = await BluetoothConnection.toAddress(device.address);
      isConnected = true;

      _connection!.input!
          .listen((data) {
            final message = String.fromCharCodes(data).trim();
            _parseResponse(message);
          })
          .onDone(() {
            isConnected = false;
            notifyListeners();
          });

      notifyListeners();
    } catch (e) {
      isConnected = false;
      notifyListeners();
      rethrow;
    }
  }

  void disconnect() {
    _connection?.dispose();
    isConnected = false;
    notifyListeners();
  }

  void send(String cmd) {
    if (_connection != null && isConnected) {
      _connection!.output.add(Uint8List.fromList('$cmd\r'.codeUnits));
    }
  }

  /// 요청 가능한 PID 전체를 순회 요청
  void requestAll() {
    send("010C"); // RPM
    send("010D"); // Speed
    send("0104"); // Engine Load
    send("0105"); // Coolant Temp
    send("0111"); // Throttle Position
    send("010F"); // Intake Temp
    send("0110"); // MAF
    send("012F"); // Fuel Level
    send("010E"); // Timing Advance
    send("0133"); // Barometric Pressure
    send("0146"); // Ambient Air Temp
    send("010A"); // Fuel Pressure
    send("010B"); // Intake Pressure
    send("011F"); // Engine Run Time
    send("0121"); // Distance with MIL
    send("0131"); // Distance since DTC clear
    send("0151"); // Fuel Type
    send("015C"); // Engine Oil Temp
  }

  void _parseResponse(String response) {
    if (!response.startsWith("41")) return;

    try {
      final pid = response.substring(2, 4);
      final bytes = response.substring(4).replaceAll(' ', '');
      final hex = (int i) => int.parse(bytes.substring(i, i + 2), radix: 16);

      switch (pid) {
        case '0C': // RPM
          if (bytes.length >= 4) {
            final value = (hex(0) * 256 + hex(2)) / 4;
            _data = _data.copyWith(rpm: value);
          }
          break;
        case '0D': // Speed
          _data = _data.copyWith(speed: hex(0));
          break;
        case '04': // Engine Load
          _data = _data.copyWith(engineLoad: hex(0) * 100 / 255);
          break;
        case '05': // Coolant Temp
          _data = _data.copyWith(coolantTemp: hex(0) - 40);
          break;
        case '11': // Throttle
          _data = _data.copyWith(throttlePosition: hex(0) * 100 / 255);
          break;
        case '0F': // Intake Temp
          _data = _data.copyWith(intakeTemp: hex(0) - 40);
          break;
        case '10': // MAF
          if (bytes.length >= 4) {
            final value = (hex(0) * 256 + hex(2)) / 100.0;
            _data = _data.copyWith(maf: value);
          }
          break;
        case '2F': // Fuel Level
          _data = _data.copyWith(fuelLevel: hex(0) * 100 / 255);
          break;
        case '0E': // Timing Advance
          _data = _data.copyWith(timingAdvance: hex(0) / 2.0 - 64);
          break;
        case '33': // Barometric Pressure
          _data = _data.copyWith(barometricPressure: hex(0).toDouble());
          break;
        case '46': // Ambient Air Temp
          _data = _data.copyWith(ambientAirTemp: hex(0) - 40);
          break;
        case '0A': // Fuel Pressure
          _data = _data.copyWith(fuelPressure: hex(0) * 3.0);
          break;
        case '0B': // Intake Pressure
          _data = _data.copyWith(intakePressure: hex(0).toDouble());
          break;
        case '1F': // Run Time
          if (bytes.length >= 4) {
            final value = hex(0) * 256 + hex(2);
            _data = _data.copyWith(runTime: value);
          }
          break;
        case '21': // Distance with MIL
          if (bytes.length >= 4) {
            final value = hex(0) * 256 + hex(2);
            _data = _data.copyWith(distanceWithMIL: value);
          }
          break;
        case '31': // Distance since DTC clear
          if (bytes.length >= 4) {
            final value = hex(0) * 256 + hex(2);
            _data = _data.copyWith(distanceSinceCodesCleared: value);
          }
          break;
        case '51': // Fuel Type
          final types = [
            "Not available",
            "Gasoline",
            "Methanol",
            "Ethanol",
            "Diesel",
            "LPG",
            "CNG",
            "Propane",
            "Electric",
            "Bifuel running Gasoline",
            "Bifuel running Methanol",
            "Bifuel running Ethanol",
          ];
          final index = hex(0);
          final type = index < types.length ? types[index] : "Unknown";
          _data = _data.copyWith(fuelType: type);
          break;
        case '5C': // Engine Oil Temp
          _data = _data.copyWith(engineOilTemp: hex(0) - 40);
          break;
      }

      notifyListeners();
    } catch (e) {
      debugPrint('❌ PID 파싱 실패: $e');
    }
  }

  @override
  void dispose() {
    _connection?.dispose();
    super.dispose();
  }
}
