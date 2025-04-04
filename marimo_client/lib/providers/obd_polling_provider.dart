import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:marimo_client/providers/car_provider.dart';
import 'package:marimo_client/services/car/obd_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:marimo_client/providers/member/auth_provider.dart';
import 'package:marimo_client/constants/obd_pids.dart';

class ObdPollingProvider with ChangeNotifier {
  BluetoothConnection? _connection;
  StreamSubscription<Uint8List>? _inputSubscription;
  final Map<String, String> _pidResponses = {};
  final List<String> _pollingPids = pollingPids;

  bool isRunning = false;
  bool isConnected = false;

  Completer<String>? _commandCompleter;
  StringBuffer? _responseBuffer;

  Future<void> connectAndStartPolling(BuildContext context) async {
    final bondedDevices =
        await FlutterBluetoothSerial.instance.getBondedDevices();
    final obdDevices =
        bondedDevices.where((device) {
          final name = device.name?.toUpperCase() ?? '';
          return name.contains('OBD') ||
              name.contains('ELM') ||
              name.contains('VGATE');
        }).toList();

    if (obdDevices.isEmpty) {
      throw Exception('OBD 기기를 찾을 수 없습니다');
    }

    final target = obdDevices.first;
    await connect(target);
    await _initializeObd();
    startPolling(context);
  }

  Future<void> connect(BluetoothDevice device) async {
    try {
      _connection = await BluetoothConnection.toAddress(device.address);
      isConnected = _connection?.isConnected ?? false;

      if (!isConnected) {
        throw Exception('Bluetooth 연결 실패');
      }

      _inputSubscription?.cancel();
      _inputSubscription = _connection!.input!.listen(
        _handleResponse,
        onDone: () {
          isConnected = false;
          stopPolling();
        },
        onError: (error) {
          isConnected = false;
          stopPolling();
        },
      );
    } catch (e) {
      isConnected = false;
      rethrow;
    }
  }

  void disconnect() {
    isConnected = false;
    stopPolling();
    _inputSubscription?.cancel();
    _connection?.dispose();
    _connection = null;
  }

  void startPolling(BuildContext context) {
    if (!isConnected || isRunning) return;

    isRunning = true;
    notifyListeners();
    _pollPids(context); // ⬅️ context 넘김
  }

  void _pollPids(BuildContext context) async {
    while (isRunning && isConnected) {
      for (final pid in _pollingPids) {
        if (!isRunning || !isConnected) break;

        try {
          final response = await _sendCommand('01$pid');
          _pidResponses['01$pid'] = response;
          await _saveResponsesToLocal();
        } catch (_) {
          _pidResponses['01$pid'] = 'NO RESPONSE';
        }
        notifyListeners();
        await Future.delayed(const Duration(milliseconds: 120));
      }

      // ✅ 모든 PID 순회 후 서버 전송
      await sendObdDataToServer(context); // ⬅️ context 사용
    }
  }

  void stopPolling() {
    isRunning = false;
    notifyListeners();
  }

  Future<void> _initializeObd() async {
    final cmds = ['ATZ', 'ATE0', 'ATL0', 'ATS0', 'ATH1', 'ATSP0'];
    for (final cmd in cmds) {
      await _sendCommand(cmd);
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  Future<String> _sendCommand(String command) async {
    if (!isConnected || _connection?.isConnected != true) {
      throw Exception('Not connected to OBD');
    }

    _commandCompleter = Completer<String>();
    _responseBuffer = StringBuffer();

    final output = _connection?.output;
    if (output == null) {
      throw Exception('❌ Bluetooth output stream is null');
    }

    output.add(Uint8List.fromList('$command\r'.codeUnits));
    await output.allSent;

    return _commandCompleter!.future.timeout(
      const Duration(seconds: 5),
      onTimeout: () => throw TimeoutException('응답 시간 초과'),
    );
  }

  void _handleResponse(Uint8List data) {
    final response = String.fromCharCodes(data);
    if (_responseBuffer != null && _commandCompleter != null) {
      _responseBuffer!.write(response);

      if (response.contains('>')) {
        final result = _responseBuffer!.toString().replaceAll('>', '').trim();

        try {
          _commandCompleter?.complete(result);
        } catch (e) {
          debugPrint('❌ 응답 처리 중 오류: $e');
        }

        _commandCompleter = null;
        _responseBuffer = null;
      }
    } else {
      debugPrint(
        '⚠️ 응답 처리할 준비가 안 됨: _commandCompleter or _responseBuffer가 null',
      );
    }
  }

  Map<String, String> get responses => _pidResponses;

  @override
  void dispose() {
    disconnect();
    super.dispose();
  }

  Future<void> _saveResponsesToLocal() async {
    final prefs = await SharedPreferences.getInstance();

    final cleanedMap = <String, String>{};
    for (final entry in _pidResponses.entries) {
      final key = entry.key;
      final newKey = key.startsWith('01') ? key.substring(2) : key;
      cleanedMap[newKey] = entry.value;
    }

    final jsonString = jsonEncode(cleanedMap);
    await prefs.setString('last_obd_data', jsonString);
  }

  Future<void> loadResponsesFromLocal(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('last_obd_data');
    print('✅ 로컬에 저장된 OBD 데이터: $jsonString');

    if (jsonString != null) {
      final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      _pidResponses.clear();
      jsonMap.forEach((key, value) {
        _pidResponses[key] = value.toString();
      });
      notifyListeners();
    }

    // await sendObdDataToServer(context);
  }

  Future<List<String>> fetchStoredDtcCodes() async {
    if (!isConnected || _connection == null) {
      debugPrint('❌ DTC 조회 실패: OBD 기기 연결 안 됨');
      throw Exception('OBD 기기에 연결되어 있지 않습니다');
    }

    final modes = ['03', '07', '02'];
    final dtcCodes = <String>{};

    for (final mode in modes) {
      try {
        debugPrint('📤 [$mode] DTC 명령 전송 중...');
        final response = await _sendCommand(mode);
        debugPrint('📥 [$mode] DTC 응답 수신 완료: $response');

        final lines =
            response
                .split(RegExp(r'[\r\n]+'))
                .where((l) => l.trim().isNotEmpty)
                .toList();
        final hexString = lines.join('').replaceAll(' ', '');
        debugPrint('📦 [$mode] 클린된 응답: $hexString');

        final section = extractDtcHexSection(hexString);
        if (section == null) {
          debugPrint('⚠️ [$mode] 유효한 DTC 코드 섹션 없음');
          continue;
        }

        for (int i = 0; i + 4 <= section.length; i += 4) {
          final chunk = section.substring(i, i + 4);
          try {
            final code = _convertToDtcCode(chunk);
            dtcCodes.add(code);
          } catch (e) {
            debugPrint('❌ DTC 변환 실패 (chunk=$chunk): $e');
          }
        }
      } catch (e, stack) {
        debugPrint('❌ [$mode] DTC 조회 중 예외 발생: $e');
        debugPrint('🪵 Stack: $stack');
      }
    }

    final result = dtcCodes.toList();
    debugPrint('✅ 최종 DTC 코드 목록 (중복 제거): $result');
    return result;
  }

  String _convertToDtcCode(String raw) {
    final firstByte = int.parse(raw.substring(0, 2), radix: 16);
    final secondByte = raw.substring(2);

    final type = ['P', 'C', 'B', 'U'][(firstByte & 0xC0) >> 6];
    final firstDigit = ((firstByte & 0x30) >> 4).toString();
    final lastTwo =
        (firstByte & 0x0F).toRadixString(16).toUpperCase() + secondByte;

    return '$type$firstDigit$lastTwo';
  }

  String? extractDtcHexSection(String raw) {
    final cleaned = raw.replaceAll(RegExp(r'\s+'), '');
    debugPrint("📦 클린된 응답: $cleaned");

    final index = cleaned.indexOf('43');
    if (index == -1) {
      debugPrint("❌ 43(MODE 03) 헤더가 없음");
      return null;
    }

    final codeSection = cleaned.substring(index + 2);
    debugPrint("✅ DTC 코드 섹션 추출됨: $codeSection");

    return codeSection;
  }

  Future<void> sendObdDataToServer(BuildContext context) async {
    try {
      final carProvider = Provider.of<CarProvider>(context, listen: false);
      final authProvider = Provider.of<AuthProvider>(
        context,
        listen: false,
      ); // ✅ 추가
      final carId = carProvider.firstCarId;
      final accessToken = authProvider.accessToken; // ✅ 토큰 가져오기

      if (carId == null || accessToken == null) {
        debugPrint('🚫 전송 실패: 차량 ID 또는 토큰이 없습니다');
        return;
      }

      await ObdService.sendObdData(
        carId: carId,
        accessToken: accessToken,
        provider: this, // ObdPollingProvider 자체 전달
      );

      debugPrint('✅ OBD 데이터 서버 전송 완료');
    } catch (e) {
      debugPrint('❌ OBD 데이터 전송 실패: $e');
    }
  }
}
