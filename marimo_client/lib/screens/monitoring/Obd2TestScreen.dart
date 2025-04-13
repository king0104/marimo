import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'dart:typed_data';

class Obd2TestScreen extends StatefulWidget {
  const Obd2TestScreen({super.key});

  @override
  State<Obd2TestScreen> createState() => _Obd2TestScreenState();
}

class _Obd2TestScreenState extends State<Obd2TestScreen> {
  List<BluetoothDevice> devices = [];
  BluetoothConnection? connection;
  BluetoothDevice? selectedDevice;
  String log = '';
  bool isConnected = false;

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

  void connect() async {
    if (selectedDevice == null) return;

    try {
      connection = await BluetoothConnection.toAddress(selectedDevice!.address);
      setState(() {
        isConnected = true;
        log += '✅ 연결됨: ${selectedDevice!.name}\n';
      });

      connection!.input!
          .listen((data) {
            setState(() {
              log += '📥 ${String.fromCharCodes(data)}\n';
            });
          })
          .onDone(() {
            setState(() {
              isConnected = false;
              log += '❌ 연결 종료됨\n';
            });
          });
    } catch (e) {
      setState(() {
        log += '❌ 연결 실패: $e\n';
      });
    }
  }

  void sendCommand(String command) {
    if (connection != null && isConnected) {
      connection!.output.add(Uint8List.fromList('$command\r'.codeUnits));
      setState(() {
        log += '📤 $command\n';
      });
    }
  }

  @override
  void dispose() {
    connection?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('OBD2 Bluetooth 테스트')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButton<BluetoothDevice>(
              value: selectedDevice,
              items:
                  devices.map((device) {
                    return DropdownMenuItem(
                      value: device,
                      child: Text(device.name ?? device.address),
                    );
                  }).toList(),
              onChanged: (device) {
                setState(() {
                  selectedDevice = device;
                });
              },
            ),
            ElevatedButton(
              onPressed: isConnected ? null : connect,
              child: const Text('연결'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => sendCommand("010C"), // RPM 요청
              child: const Text("010C 보내기"),
            ),
            const SizedBox(height: 12),
            Expanded(child: SingleChildScrollView(child: Text(log))),
          ],
        ),
      ),
    );
  }
}
