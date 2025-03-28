import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ObdDtcScanScreen extends StatefulWidget {
  const ObdDtcScanScreen({super.key});

  @override
  State<ObdDtcScanScreen> createState() => _ObdDtcScanScreenState();
}

class _ObdDtcScanScreenState extends State<ObdDtcScanScreen> {
  List<BluetoothDevice> devices = [];
  BluetoothDevice? selectedDevice;
  BluetoothConnection? connection;
  StreamSubscription<Uint8List>? _inputSubscription;
  final StreamController<String> _responseController =
      StreamController.broadcast();
  final Map<String, String> dtcResults = {};
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
      await scanDTCs();
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

  Future<void> scanDTCs() async {
    setState(() => isScanning = true);
    dtcResults.clear();

    final dtcModes = ['02', '03', '07'];
    for (final mode in dtcModes) {
      try {
        final res = await sendAndWait(mode);
        dtcResults[mode] = res;
      } catch (e) {
        dtcResults[mode] = 'NO RESPONSE';
      }
      await Future.delayed(const Duration(milliseconds: 200));
    }

    await saveToFile();
    setState(() => isScanning = false);
  }

  Future<void> saveToFile() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/obd_dtc_results.txt');
      final content = dtcResults.entries
          .map((e) => 'Mode ${e.key}: ${e.value}')
          .join('\n');
      await file.writeAsString(content);
      print('✅ DTC 저장 완료: ${file.path}');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('DTC 저장 완료: ${file.path}')));
    } catch (e) {
      print('❌ DTC 저장 실패: $e');
    }
  }

  Future<void> openSavedFile() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/obd_dtc_results.txt');
      if (await file.exists()) {
        final content = await file.readAsString();
        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text('📄 저장된 DTC 결과'),
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
      final file = File('${dir.path}/obd_dtc_results.txt');
      if (await file.exists()) {
        await Share.shareXFiles([XFile(file.path)], text: '📄 OBD2 고장 코드 결과');
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
      appBar: AppBar(title: const Text('OBD2 고장 코드 조회 (모드 02, 03, 07)')),
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
              child: const Text('📶 연결 및 DTC 조회'),
            ),
            const SizedBox(height: 8),
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
            const Text('📄 고장 코드 결과:'),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                children:
                    dtcResults.entries
                        .map(
                          (e) => ListTile(
                            title: Text('Mode ${e.key}'),
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
