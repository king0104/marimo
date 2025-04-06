import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import 'package:marimo_client/constants/obd_pids.dart';

class ObdPollingProvider with ChangeNotifier {
  BluetoothConnection? _connection; // Bluetooth 연결 객체 (bluetooth_serial)
  StreamSubscription<Uint8List>? _inputSubscription; // Bluetooth 데이터 수신 구독
  final Map<String, String> _pidResponses = {}; // 각 PID에 대한 응답 결과를 저장하는 Map
  final List<String> _pollingPids = pollingPids; // 주기적으로 폴링할 PID 목록 (모드 01 기준)

  bool isRunning = false; // 폴링 루프 실행 상태
  bool isConnected = false; // 연결 상태

  Completer<String>? _commandCompleter; // 명령에 대한 응답을 기다리는 Completer
  StringBuffer? _responseBuffer; // 명령 응답 버퍼

  /// connectAndStartPolling() - OBD 기기와 연결하고, 초기화 후 PID 폴링을 시작하는 함수
  Future<void> connectAndStartPolling() async {
    final bondedDevices =
        await FlutterBluetoothSerial.instance
            .getBondedDevices(); // 이미 페어링된 Bluetooth 기기 목록 가져오기

    // 이름에 'OBD', 'ELM', 'VGATE' 등을 포함하는 기기 필터링
    final obdDevices =
        bondedDevices.where((device) {
          final name = device.name?.toUpperCase() ?? '';
          return name.contains('OBD') ||
              name.contains('ELM') ||
              name.contains('VGATE');
        }).toList();

    // 만약 해당 기기가 없으면 예외 발생
    if (obdDevices.isEmpty) {
      throw Exception('OBD 기기를 찾을 수 없습니다');
    }

    // 첫 번째 OBD 기기를 선택
    final target = obdDevices.first;
    // 선택된 기기로 연결 시도
    await connect(target);
    // 연결 후 OBD 초기화 명령 전송
    await _initializeObd();
    // 초기화 완료되면 PID 폴링 시작
    startPolling();
  }

  /// 지정된 Bluetooth 기기에 연결하는 함수
  Future<void> connect(BluetoothDevice device) async {
    try {
      // Bluetooth 기기 주소로 연결 시도
      _connection = await BluetoothConnection.toAddress(device.address);
      isConnected = _connection?.isConnected ?? false;

      // 연결 실패 시 예외 발생
      if (!isConnected) {
        throw Exception('Bluetooth 연결 실패');
      }

      // 기존 수신 구독 취소 (만약 있다면)
      _inputSubscription?.cancel();
      // 새로운 데이터 수신 구독 시작, 수신 시 _handleResponse 호출
      _inputSubscription = _connection!.input!.listen(
        _handleResponse,
        onDone: () {
          // 연결 종료 시 상태 업데이트
          isConnected = false;
          stopPolling();
        },
        onError: (error) {
          // 오류 발생 시 상태 업데이트
          isConnected = false;
          stopPolling();
        },
      );
    } catch (e) {
      isConnected = false;
      // 연결 실패시 예외를 다시 던져 호출자에게 전달
      rethrow;
    }
  }

  /// 현재 Bluetooth 연결 해제 및 폴링 중지
  void disconnect() {
    isConnected = false;
    stopPolling();
    _inputSubscription?.cancel();
    _connection?.dispose();
    _connection = null;
  }

  /// OBD PID 폴링을 시작하는 함수
  void startPolling() {
    // 연결되어 있지 않거나 이미 실행 중이면 리턴
    if (!isConnected || isRunning) return;

    isRunning = true;
    notifyListeners();

    // 내부 폴링 루프 시작
    _pollPids();
  }

  /// pollPids() - 내부적으로 PID들을 순차적으로 요청하는 폴링 루프
  void _pollPids() async {
    while (isRunning && isConnected) {
      // 모든 PID에 대해 순차적으로 명령 전송
      for (final pid in _pollingPids) {
        if (!isRunning || !isConnected) break;

        try {
          // '01' 모드에 해당 PID 전송 및 응답 대기
          final response = await _sendCommand('01$pid');
          _pidResponses['01$pid'] = response;
          await _saveResponsesToLocal();
        } catch (_) {
          // 예외 발생 시 응답 없음 처리
          _pidResponses['01$pid'] = 'NO RESPONSE';
        }
        // 상태 업데이트 알림
        notifyListeners();
        // 각 PID 요청 간 약간의 딜레이 (120ms)
        await Future.delayed(const Duration(milliseconds: 120));
      }
    }
  }

  /// stopPolling() - 폴링 중지를 위한 함수
  void stopPolling() {
    isRunning = false;
    notifyListeners();
  }

  /// initializeObd() - OBD 초기화 명령들을 순차적으로 전송하는 함수
  Future<void> _initializeObd() async {
    final cmds = [
      'ATZ',
      'ATE0',
      'ATL0',
      'ATS0',
      'ATH1',
      'ATSP0',
    ]; // OBD 초기화를 위한 AT 명령 리스트
    for (final cmd in cmds) {
      // 각 명령 전송 및 응답 대기
      await _sendCommand(cmd);
      // 명령 간 100ms 딜레이
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  /// 지정된 명령(command)을 전송하고, 응답을 기다려 반환하는 함수
  Future<String> _sendCommand(String command) async {
    if (!isConnected || _connection == null) {
      throw Exception('Not connected');
    }

    // 새 명령에 대해 Completer와 응답 버퍼 초기화
    _commandCompleter = Completer<String>();
    _responseBuffer = StringBuffer();

    // 명령 전송 (명령 끝에 '\r' 추가)
    _connection!.output.add(Uint8List.fromList('$command\r'.codeUnits));
    await _connection!.output.allSent;

    // 2초 내에 응답이 오지 않으면 TimeoutException 발생
    return _commandCompleter!.future.timeout(
      const Duration(seconds: 2),
      onTimeout: () => throw TimeoutException('응답 시간 초과'),
    );
  }

  /// Bluetooth를 통해 들어오는 데이터를 처리하는 함수
  void _handleResponse(Uint8List data) {
    final response = String.fromCharCodes(data);
    // 응답 버퍼와 Completer가 준비되어 있으면 데이터를 버퍼에 추가
    if (_responseBuffer != null && _commandCompleter != null) {
      _responseBuffer!.write(response);
      // '>' 문자가 응답에 포함되면 응답 완료로 간주
      if (response.contains('>')) {
        final result = _responseBuffer!.toString().replaceAll('>', '').trim();
        // Completer에 결과 전달
        _commandCompleter!.complete(result);
        // 사용 완료 후 변수 초기화
        _commandCompleter = null;
        _responseBuffer = null;
      }
    }
  }

  /// PID 응답 결과 Map에 접근할 수 있도록 Getter 제공
  Map<String, String> get responses => _pidResponses;

  @override
  void dispose() {
    // Provider 종료 시 연결 해제
    disconnect();
    super.dispose();
  }

  // saveResponsesToLocal() - 로컬에 응답 데이터 저장
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

  // loadResponsesFromLocal() - 로컬에서 응답 데이터 불러오기
  Future<void> loadResponsesFromLocal() async {
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
  }

  // ✅ ObdPollingProvider에 DTC 코드 조회 함수 추가
  Future<List<String>> fetchStoredDtcCodes() async {
    if (!isConnected || _connection == null) {
      throw Exception('OBD 기기에 연결되어 있지 않습니다');
    }

    try {
      final response = await _sendCommand('03'); // Mode 03: Stored DTCs
      // 응답 파싱 로직 (단순화된 예시)
      final lines =
          response
              .split(RegExp(r'[\r\n]+'))
              .where((l) => l.trim().isNotEmpty)
              .toList();
      if (lines.isEmpty) return [];

      final hexString = lines.join('').replaceAll(' ', '');
      if (!hexString.startsWith('43')) return [];

      final codeSection = hexString.substring(2); // "43" 이후의 DTC 섹션
      final dtcCodes = <String>[];

      for (int i = 0; i + 4 <= codeSection.length; i += 4) {
        final chunk = codeSection.substring(i, i + 4);
        final code = _convertToDtcCode(chunk);
        dtcCodes.add(code);
      }

      return dtcCodes;
    } catch (e) {
      debugPrint('DTC 조회 실패: \$e');
      return [];
    }
  }

  String _convertToDtcCode(String raw) {
    final firstByte = int.parse(raw.substring(0, 2), radix: 16);
    final secondByte = raw.substring(2);

    final type = ['P', 'C', 'B', 'U'][(firstByte & 0xC0) >> 6];
    final firstDigit = ((firstByte & 0x30) >> 4).toString();
    final lastTwo =
        (firstByte & 0x0F).toRadixString(16).toUpperCase() + secondByte;

    return '$type\$firstDigit\$lastTwo';
  }
}
