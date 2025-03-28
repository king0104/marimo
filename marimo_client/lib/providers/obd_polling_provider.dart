import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:marimo_client/utils/toast.dart';
import 'package:marimo_client/utils/loading_overlay.dart';

class ObdPollingProvider with ChangeNotifier {
  BluetoothConnection? _connection;
  StreamSubscription<Uint8List>? _inputSubscription;
  final Map<String, String> _pidResponses = {};
  final List<String> _pollingPids = [
    '03',
    '04',
    '05',
    '06',
    '07',
    '0B',
    '0C',
    '0D',
    '0E',
    '0F',
    '10',
    '11',
    '13',
    '15',
    '1C',
    '1F',
    '20',
    '21',
    '23',
    '2C',
    '2D',
    '2E',
    '2F',
    '30',
    '31',
    '32',
    '33',
    '34',
    '3C',
    '40',
    '41',
    '42',
    '43',
    '44',
    '45',
    '46',
    '47',
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

  Completer<String>? _commandCompleter;
  StringBuffer? _responseBuffer;

  Future<void> connectAndStartPolling() async {
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
    startPolling();
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

  void startPolling() {
    if (!isConnected || isRunning) return;

    isRunning = true;
    notifyListeners();

    _pollPids();
  }

  void _pollPids() async {
    while (isRunning && isConnected) {
      for (final pid in _pollingPids) {
        if (!isRunning || !isConnected) break;

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
    if (!isConnected || _connection == null) {
      throw Exception('Not connected');
    }

    _commandCompleter = Completer<String>();
    _responseBuffer = StringBuffer();

    _connection!.output.add(Uint8List.fromList('$command\r'.codeUnits));
    await _connection!.output.allSent;

    return _commandCompleter!.future.timeout(
      const Duration(seconds: 2),
      onTimeout: () => throw TimeoutException('응답 시간 초과'),
    );
  }

  void _handleResponse(Uint8List data) {
    final response = String.fromCharCodes(data);
    if (_responseBuffer != null && _commandCompleter != null) {
      _responseBuffer!.write(response);
      if (response.contains('>')) {
        final result = _responseBuffer!.toString().replaceAll('>', '').trim();
        _commandCompleter!.complete(result);
        _commandCompleter = null;
        _responseBuffer = null;
      }
    }
  }

  Map<String, String> get responses => _pidResponses;

  @override
  void dispose() {
    disconnect();
    super.dispose();
  }
}
