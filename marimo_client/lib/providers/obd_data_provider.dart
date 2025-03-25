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

  Timer? _pollingTimer;

  Future<void> connect(BluetoothDevice device) async {
    try {
      _connection = await BluetoothConnection.toAddress(device.address);
      isConnected = true;

      _connection!.input!.listen(
        (data) {
          final message = String.fromCharCodes(data).trim();
          _parseResponse(message);
        },
        onDone: () {
          isConnected = false;
          stopPolling();
          notifyListeners();
        },
      );

      notifyListeners();
    } catch (e) {
      isConnected = false;
      notifyListeners();
      rethrow;
    }
  }

  void disconnect() {
    _connection?.dispose();
    _connection = null;
    isConnected = false;
    stopPolling();
    notifyListeners();
  }

  void send(String cmd) {
    if (_connection != null && isConnected) {
      _connection!.output.add(Uint8List.fromList('$cmd\r'.codeUnits));
    }
  }

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

  void startPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      requestAll();
    });
  }

  void stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  void _parseResponse(String response) {
    if (!response.startsWith("41")) return;

    try {
      final pid = response.substring(2, 4);
      final bytes = response.substring(4).replaceAll(' ', '');
      final hex = (int i) => int.parse(bytes.substring(i, i + 2), radix: 16);

      switch (pid) {
        case '0C':
          if (bytes.length >= 4) {
            final value = (hex(0) * 256 + hex(2)) / 4;
            _data = _data.copyWith(rpm: value);
          }
          break;
        case '0D':
          _data = _data.copyWith(speed: hex(0));
          break;
        case '04':
          _data = _data.copyWith(engineLoad: hex(0) * 100 / 255);
          break;
        case '05':
          _data = _data.copyWith(coolantTemp: hex(0) - 40);
          break;
        case '11':
          _data = _data.copyWith(throttlePosition: hex(0) * 100 / 255);
          break;
        case '0F':
          _data = _data.copyWith(intakeTemp: hex(0) - 40);
          break;
        case '10':
          if (bytes.length >= 4) {
            final value = (hex(0) * 256 + hex(2)) / 100.0;
            _data = _data.copyWith(maf: value);
          }
          break;
        case '2F':
          _data = _data.copyWith(fuelLevel: hex(0) * 100 / 255);
          break;
        case '0E':
          _data = _data.copyWith(timingAdvance: hex(0) / 2.0 - 64);
          break;
        case '33':
          _data = _data.copyWith(barometricPressure: hex(0).toDouble());
          break;
        case '46':
          _data = _data.copyWith(ambientAirTemp: hex(0) - 40);
          break;
        case '0A':
          _data = _data.copyWith(fuelPressure: hex(0) * 3.0);
          break;
        case '0B':
          _data = _data.copyWith(intakePressure: hex(0).toDouble());
          break;
        case '1F':
          if (bytes.length >= 4) {
            final value = hex(0) * 256 + hex(2);
            _data = _data.copyWith(runTime: value);
          }
          break;
        case '21':
          if (bytes.length >= 4) {
            final value = hex(0) * 256 + hex(2);
            _data = _data.copyWith(distanceWithMIL: value);
          }
          break;
        case '31':
          if (bytes.length >= 4) {
            final value = hex(0) * 256 + hex(2);
            _data = _data.copyWith(distanceSinceCodesCleared: value);
          }
          break;
        case '51':
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
        case '5C':
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
    _pollingTimer?.cancel();
    _connection?.dispose();
    super.dispose();
  }
}
