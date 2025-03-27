import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ObdFullScanScreen extends StatefulWidget {
  const ObdFullScanScreen({super.key});

  @override
  State<ObdFullScanScreen> createState() => _ObdFullScanScreenState();
}

class _ObdFullScanScreenState extends State<ObdFullScanScreen> {
  List<BluetoothDevice> devices = [];
  BluetoothDevice? selectedDevice;
  BluetoothConnection? connection;
  StreamSubscription<Uint8List>? _inputSubscription;
  final StreamController<String> _responseController =
      StreamController.broadcast();
  final Map<String, String> pidResults = {};
  bool isConnected = false;
  bool isScanning = false;

  @override
  void initState() {
    super.initState();
    FlutterBluetoothSerial.instance.getBondedDevices().then((bondedDevices) {
      setState(() {
        devices = bondedDevices.toList();
        if (devices.isNotEmpty) selectedDevice = devices.first;
      });
    });
  }

  Future<void> connect() async {
    if (selectedDevice == null) return;
    try {
      connection = await BluetoothConnection.toAddress(selectedDevice!.address);
      isConnected = true;
      _inputSubscription = connection!.input!.listen((data) {
        final response = String.fromCharCodes(data);
        _responseController.add(response);
      });
      await initializeOBD();
      await startFullPidScan();
    } catch (e) {
      isConnected = false;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('연결 실패: $e')));
    }
  }

  Future<void> initializeOBD() async {
    await sendAndWait('ATZ');
    await sendAndWait('ATE0');
    await sendAndWait('ATL0');
    await sendAndWait('ATS0');
    await sendAndWait('ATH1');
    await sendAndWait('ATSP0');
    print('[OBD] ✅ 초기화 완료');
  }

  Future<String> sendAndWait(String cmd) async {
    if (connection == null || !isConnected) {
      throw Exception('[OBD] 연결되지 않음');
    }
    print('[OBD] 📤 $cmd');
    final completer = Completer<String>();
    final buffer = StringBuffer();
    late StreamSubscription sub;
    sub = _responseController.stream.listen((chunk) {
      buffer.write(chunk);
      if (chunk.contains('>')) {
        sub.cancel();
        final raw = buffer.toString();
        final response = raw.replaceAll('>', '').trim();
        print('[OBD] 📥 응답: $response');
        completer.complete(response);
      }
    });
    connection!.output.add(Uint8List.fromList('$cmd\r'.codeUnits));
    await connection!.output.allSent;
    return completer.future.timeout(
      const Duration(seconds: 3),
      onTimeout: () {
        sub.cancel();
        throw TimeoutException('[OBD] 응답 시간 초과');
      },
    );
  }

  Future<void> startFullPidScan() async {
    setState(() => isScanning = true);
    pidResults.clear();

    // ✅ Mode 01 PIDs (0x00 ~ 0xFF)
    for (int i = 0; i <= 0xFF; i++) {
      final pid = i.toRadixString(16).padLeft(2, '0').toUpperCase();
      try {
        final res = await sendAndWait('01$pid');
        pidResults['01$pid'] = res;
      } catch (e) {
        pidResults['01$pid'] = 'NO RESPONSE';
      }
      await Future.delayed(const Duration(milliseconds: 150));
    }

    // ✅ Mode 09 (차량 정보 조회)
    final mode09PIDs = ['00', '02', '04', '0A'];
    for (final pid in mode09PIDs) {
      try {
        final res = await sendAndWait('09$pid');
        pidResults['09$pid'] = res;
      } catch (e) {
        pidResults['09$pid'] = 'NO RESPONSE';
      }
      await Future.delayed(const Duration(milliseconds: 150));
    }

    await savePidResultsToFile();
    setState(() => isScanning = false);
  }

  Future<void> savePidResultsToFile() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/obd_pid_results.txt');
      final content = pidResults.entries
          .map((e) => 'PID ${e.key}: ${e.value}')
          .join('\n');
      await file.writeAsString(content);
      print('✅ 저장 완료: ${file.path}');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('파일 저장 완료: ${file.path}')));
    } catch (e) {
      print('❌ 파일 저장 실패: $e');
    }
  }

  Future<void> openSavedFile() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/obd_pid_results.txt');
      if (await file.exists()) {
        final content = await file.readAsString();
        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text('📄 저장된 PID 결과'),
                content: SingleChildScrollView(child: SelectableText(content)),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('닫기'),
                  ),
                ],
              ),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('파일이 존재하지 않습니다')));
      }
    } catch (e) {
      print('❌ 파일 열기 실패: $e');
    }
  }

  Future<void> shareSavedFile() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/obd_pid_results.txt');
      if (await file.exists()) {
        await Share.shareXFiles([XFile(file.path)], text: '📄 OBD2 PID 결과 공유');
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('공유할 파일이 없습니다')));
      }
    } catch (e) {
      print('❌ 파일 공유 실패: $e');
    }
  }

  @override
  void dispose() {
    _inputSubscription?.cancel();
    connection?.dispose();
    _responseController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('OBD2 전체 PID 스캔')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButton<BluetoothDevice>(
              value: selectedDevice,
              items:
                  devices
                      .map(
                        (device) => DropdownMenuItem(
                          value: device,
                          child: Text(device.name ?? device.address),
                        ),
                      )
                      .toList(),
              onChanged: (device) {
                setState(() => selectedDevice = device);
              },
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: isConnected ? null : connect,
              child: const Text('📶 연결 및 스캔 시작'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: openSavedFile,
              child: const Text('📂 저장된 파일 열기'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: shareSavedFile,
              child: const Text('📤 파일 공유하기'),
            ),
            const SizedBox(height: 24),
            const Text('📄 최근 응답 결과:'),
            Expanded(
              child: ListView(
                children:
                    pidResults.entries
                        .map(
                          (e) => ListTile(
                            title: Text('PID ${e.key}'),
                            subtitle: Text(e.value),
                          ),
                        )
                        .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
