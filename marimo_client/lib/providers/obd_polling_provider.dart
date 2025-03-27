import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:marimo_client/utils/toast.dart';

class ObdPollingProvider with ChangeNotifier {
  BluetoothConnection? _connection;
  StreamSubscription<Uint8List>? _inputSubscription;
  final Map<String, String> _pidResponses = {};
  final List<String> _pollingPids = [
    '03',
    '04',
    '04',
    '05',
    '06',
    '07',
    '0B',
    '0C',
    '0C',
    '0C',
    '0D',
    '0D',
    '0E',
    '0F',
    '10',
    '11',
    '11',
    '13',
    '15',
    '1C',
    '1C',
    '1F',
    '1F',
    '20',
    '20',
    '20',
    '21',
    '21',
    '23',
    '2C',
    '2D',
    '2E',
    '2F',
    '30',
    '30',
    '30',
    '31',
    '31',
    '31',
    '32',
    '33',
    '34',
    '3C',
    '40',
    '40',
    '40',
    '41',
    '41',
    '41',
    '42',
    '42',
    '43',
    '44',
    '45',
    '46',
    '47',
    '49',
    '49',
    '4A',
    '4C',
    '51',
    '55',
    '56',
    '60',
    '62',
    '63',
    '67',
    '6B',
    '80',
    '8E',
    '9D',
    '9E',
    'A0',
    'A6',
  ];

  bool isRunning = false;
  bool isConnected = false;

  /// ✅ 자동 연결 및 polling 시작
  Future<void> connectAndStartPolling(BuildContext context) async {
    try {
      final bondedDevices =
          await FlutterBluetoothSerial.instance.getBondedDevices();

      final obdDevices =
          bondedDevices.where((device) {
            final name = device.name?.toUpperCase() ?? '';
            return name.contains('OBD') ||
                name.contains('ELM') ||
                name.contains('VGATE');
          }).toList();

      if (obdDevices.isNotEmpty) {
        final target = obdDevices.first;
        debugPrint('🔌 연결 시도 대상: ${target.name} (${target.address})');
        await connect(target);
      } else {
        showToast(context, '❌ OBD 기기를 찾을 수 없습니다', icon: Icons.warning);
      }
    } catch (e) {
      showToast(context, '❌ OBD 연결에 실패했습니다', icon: Icons.warning);
      debugPrint('❌ 연결 에러: $e');
    }
  }

  /// ✅ 특정 디바이스에 연결
  Future<void> connect(BluetoothDevice device) async {
    _connection = await BluetoothConnection.toAddress(device.address);
    isConnected = true;
    _inputSubscription = _connection!.input!.listen(_handleResponse);
    await _initializeObd();
    startPolling();
  }

  /// ✅ OBD 초기화
  Future<void> _initializeObd() async {
    await _sendCommand('ATZ');
    await _sendCommand('ATE0');
    await _sendCommand('ATL0');
    await _sendCommand('ATS0');
    await _sendCommand('ATH1');
    await _sendCommand('ATSP0');
  }

  /// ✅ 주기적 PID 요청
  void startPolling() async {
    isRunning = true;
    notifyListeners();

    while (isRunning && isConnected) {
      for (final pid in _pollingPids) {
        try {
          final response = await _sendCommand('01$pid');
          _pidResponses['01$pid'] = response;
        } catch (_) {
          _pidResponses['01$pid'] = 'NO RESPONSE';
        }
        notifyListeners();
        await Future.delayed(const Duration(milliseconds: 120));
      }
    }
  }

  /// ✅ polling 중단
  void stopPolling() {
    isRunning = false;
    notifyListeners();
  }

  /// ✅ PID 명령 전송 및 응답 수신
  Future<String> _sendCommand(String command) async {
    if (_connection == null || !_connection!.isConnected) {
      throw Exception('Not connected');
    }

    final completer = Completer<String>();
    final buffer = StringBuffer();

    late StreamSubscription sub;
    sub = _connection!.input!.listen((data) {
      final response = String.fromCharCodes(data);
      buffer.write(response);
      if (response.contains('>')) {
        sub.cancel();
        final cleaned = buffer.toString().replaceAll('>', '').trim();
        completer.complete(cleaned);
      }
    });

    _connection!.output.add(Uint8List.fromList('$command\r'.codeUnits));
    await _connection!.output.allSent;

    return completer.future.timeout(
      const Duration(seconds: 2),
      onTimeout: () {
        sub.cancel();
        throw TimeoutException('응답 시간 초과');
      },
    );
  }

  /// ✅ 응답 로그 출력 (옵션)
  void _handleResponse(Uint8List data) {
    final response = String.fromCharCodes(data);
    debugPrint('[OBD RESPONSE] $response');
  }

  Map<String, String> get responses => _pidResponses;

  @override
  void dispose() {
    stopPolling();
    _inputSubscription?.cancel();
    _connection?.dispose();
    super.dispose();
  }
}
