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

  StreamController<String>? _responseController;

  Future<void> connectWithConnection(
    BluetoothConnection connection,
    StreamController<String> responseController,
  ) async {
    _connection = connection;
    _responseController = responseController;
    isConnected = true;
    notifyListeners();

    // ✅ 초기화 명령 순차 실행 (echo off, protocol 설정 등)
    try {
      await sendAndWait('ATZ'); // 리셋
      await sendAndWait('ATE0'); // echo off
      await sendAndWait('ATL0'); // 줄바꿈 off
      await sendAndWait('ATS0'); // 공백 제거
      await sendAndWait('ATH1'); // 헤더 표시 on
      await sendAndWait('ATSP0'); // 자동 프로토콜 설정
      print('[OBD] ✅ 초기화 명령 완료');
    } catch (e) {
      print('[OBD] ⚠️ 초기화 명령 중 오류: \$e');
    }
  }

  void disconnect() {
    print('[OBD] 🔌 연결 종료 요청');
    _connection?.dispose();
    _connection = null;
    isConnected = false;
    notifyListeners();
  }

  Future<String> sendAndWait(String cmd) async {
    if (_connection == null || !isConnected || _responseController == null) {
      throw Exception('[OBD] 연결 안 된');
    }

    print('[OBD] 📤 명령 전송: $cmd');
    final completer = Completer<String>();
    final buffer = StringBuffer();
    late StreamSubscription sub;

    sub = _responseController!.stream.listen((chunk) {
      buffer.write(chunk);
      if (chunk.contains('>')) {
        sub.cancel();
        final raw = buffer.toString();
        final response = raw.replaceAll('>', '').trim();
        print('[OBD] 🧾 원본 응답(raw): "$raw"');
        print('[OBD] 📥 응답 수신 완료: "$response"');
        completer.complete(response);
      }
    });

    _connection!.output.add(Uint8List.fromList('$cmd\r'.codeUnits));
    await _connection!.output.allSent;

    return completer.future.timeout(
      const Duration(seconds: 3),
      onTimeout: () {
        sub.cancel();
        throw TimeoutException('[OBD] 응답 타임아웃');
      },
    );
  }

  Future<void> startPollingWithDelay() async {
    print('[OBD] 🔁 Polling 시작 (안정형)');
    final commands = [
      "010C",
      "010D",
      "0104",
      "0105",
      "0111",
      "010F",
      "0110",
      "012F",
      "010E",
      "0133",
      "0146",
      "010A",
      "010B",
      "011F",
      "0121",
      "0131",
      "0151",
      "015C",
    ];

    while (isConnected) {
      for (final cmd in commands) {
        try {
          final res = await sendAndWait(cmd);
          _parseResponse(res);
        } catch (e) {
          print('[OBD] ⚠️ 명령 처리 중 오류 ($cmd): $e');
        }
        await Future.delayed(const Duration(milliseconds: 200));
      }
    }
  }

  void _parseResponse(String response) {
    // 헤더 포함된 응답에서 41로 시작하는 부분만 추출
    final match = RegExp(r'41[0-9A-Fa-f]{2}[0-9A-Fa-f]*').firstMatch(response);
    if (match == null) return;

    final cleaned = match.group(0)!.replaceAll(' ', '');

    try {
      final pid = cleaned.substring(2, 4);
      final bytes = cleaned.substring(4);
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
          _data = _data.copyWith(coolantTemp: (hex(0) - 40).toDouble());
          break;
        case '11':
          _data = _data.copyWith(throttlePosition: hex(0) * 100 / 255);
          break;
        case '0F':
          _data = _data.copyWith(intakeTemp: (hex(0) - 40).toDouble());
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
          _data = _data.copyWith(ambientAirTemp: (hex(0) - 40).toDouble());
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
          _data = _data.copyWith(engineOilTemp: (hex(0) - 40).toDouble());
          break;
      }
      print('[OBD] ✅ 최신 데이터 상태: ${_data.toString()}');

      notifyListeners();
    } catch (e) {
      debugPrint('❌ PID 파시마 실패: $e\n응답 원문: "$response"');
    }
  }

  @override
  void dispose() {
    _connection?.dispose();
    _responseController?.close();
    super.dispose();
  }
}
