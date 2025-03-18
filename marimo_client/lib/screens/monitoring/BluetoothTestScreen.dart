import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';

class BluetoothTestScreen extends StatefulWidget {
  const BluetoothTestScreen({super.key});

  @override
  State<BluetoothTestScreen> createState() => _BluetoothTestScreenState();
}

class _BluetoothTestScreenState extends State<BluetoothTestScreen> {
  List<BluetoothDevice> pairedDevices = []; // ✅ 기존에 페어링된 장치 목록
  List<ScanResult> scanResults = []; // ✅ 스캔된 BLE 장치 목록
  bool isScanning = false;
  BluetoothDevice? connectedDevice;
  BluetoothCharacteristic? obdCharacteristic; // OBD2 BLE 특성

  @override
  void initState() {
    super.initState();
    requestBluetoothPermissions();
    getBondedDevices();
    FlutterBluePlus.scanResults.listen((results) {
      setState(() {
        scanResults =
            results.where((result) => result.device.name.isNotEmpty).toList();
      });
    });
    scanForDevices();
  }

  // ✅ 블루투스 권한 요청
  Future<void> requestBluetoothPermissions() async {
    if (await Permission.bluetoothScan.request().isGranted &&
        await Permission.bluetoothConnect.request().isGranted &&
        await Permission.location.request().isGranted) {
      print("✅ Bluetooth Permissions Granted");
    } else {
      print("❌ Bluetooth Permissions Denied");
    }
  }

  // ✅ 기존에 페어링된 기기 가져오기
  Future<void> getBondedDevices() async {
    List<BluetoothDevice> devices = await FlutterBluePlus.connectedDevices;
    setState(() {
      pairedDevices = devices;
    });
    print("✅ Paired Devices: ${pairedDevices.map((e) => e.name).toList()}");
  }

  // ✅ 블루투스 장치 검색 시작
  void scanForDevices() {
    if (isScanning) return;

    setState(() {
      isScanning = true;
      scanResults.clear();
    });

    print("✅ Start BLE Scan...");
    FlutterBluePlus.startScan(
      timeout: const Duration(seconds: 5),
      androidLegacy: true,
    );

    Future.delayed(const Duration(seconds: 5), () {
      FlutterBluePlus.stopScan();
      setState(() {
        isScanning = false;
      });
      print("✅ Stop BLE Scan.");
    });
  }

  // ✅ 장치와 연결 시도
  Future<void> connectToDevice(BluetoothDevice device) async {
    try {
      await FlutterBluePlus.stopScan();
      await Future.delayed(const Duration(seconds: 1));

      await device.connect(
        autoConnect: false,
        timeout: const Duration(seconds: 10),
      );
      await setMTU(device);
      connectedDevice = device;

      print("✅ Connected to ${device.name} (${device.id})");

      // ✅ BLE 서비스 & 특성 검색
      await discoverServices(device);
    } catch (e) {
      print("❌ Failed to connect: $e");
      await clearGattCache(device);
    }
  }

  // ✅ MTU 크기 설정
  Future<void> setMTU(BluetoothDevice device) async {
    try {
      await device.requestMtu(256);
      print("✅ MTU size set to 256");
    } catch (e) {
      print("❌ Failed to set MTU: $e");
    }
  }

  // ✅ BLE GATT 캐시 정리
  Future<void> clearGattCache(BluetoothDevice device) async {
    try {
      await device.disconnect();
      await Future.delayed(const Duration(seconds: 1));
      print("✅ Cleared BLE GATT cache for ${device.name}");
    } catch (e) {
      print("❌ Failed to clear GATT cache: $e");
    }
  }

  // ✅ OBD2 서비스 및 특성 찾기
  Future<void> discoverServices(BluetoothDevice device) async {
    List<BluetoothService> services = await device.discoverServices();

    for (var service in services) {
      for (var characteristic in service.characteristics) {
        print("🔍 발견된 특성: ${characteristic.uuid}");
        print("    ⏩ Read 가능: ${characteristic.properties.read}");
        print("    ⏩ Write 가능: ${characteristic.properties.write}");
        print("    ⏩ Notify 가능: ${characteristic.properties.notify}");

        if (characteristic.properties.notify) {
          obdCharacteristic = characteristic;
          await obdCharacteristic!.setNotifyValue(true);
          obdCharacteristic!.value.listen((value) {
            if (value.isEmpty) {
              print("\n🔹🔹🔹🔹 OBD2 데이터 수신 🔹🔹🔹🔹");
              print("⚠️ 데이터 없음 (Empty Response)");
              print("🔹🔹🔹🔹🔹🔹🔹🔹🔹🔹🔹🔹🔹🔹🔹🔹\n");
              return;
            }

            // HEX 변환
            String hexResponse = value
                .map((e) => e.toRadixString(16).padLeft(2, '0'))
                .join(' ');

            // 바이너리 변환 (8자리 이진수 변환)
            String binaryResponse = value
                .map((e) => e.toRadixString(2).padLeft(8, '0'))
                .join(' ');

            print("\n🔹🔹🔹🔹 OBD2 데이터 수신 🔹🔹🔹🔹");
            print("📩 HEX 데이터:    $hexResponse");
            print("📩 Binary 데이터: $binaryResponse");

            // ASCII 변환 (깨질 가능성이 있는 데이터 예외 처리)
            try {
              String asciiResponse =
                  utf8.decode(value, allowMalformed: true).trim();
              if (asciiResponse.isNotEmpty && asciiResponse != "�") {
                print("📩 ASCII 데이터:  $asciiResponse");
              }
            } catch (e) {
              print("⚠️ ASCII 변환 실패: $e");
            }

            print("🔹🔹🔹🔹🔹🔹🔹🔹🔹🔹🔹🔹🔹🔹🔹🔹\n");
          });
          print("✅ OBD2 실시간 데이터 수신 활성화됨");
        }
      }
    }
  }

  // ✅ OBD2 데이터 요청 (PID 전송)
  Future<void> sendOBD2Command(String command) async {
    if (obdCharacteristic == null) {
      print("❌ OBD2 특성이 없음");
      return;
    }

    try {
      String formattedCommand = "$command\r"; // OBD2 명령어 끝에 개행 추가
      await obdCharacteristic!.write(utf8.encode(formattedCommand));
      print("🚀 OBD2 명령어 전송: $command");
    } catch (e) {
      print("❌ OBD2 명령어 전송 실패: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    List<BluetoothDevice> allDevices =
        [
          ...pairedDevices,
          ...scanResults.map((result) => result.device),
        ].toSet().toList();

    return Scaffold(
      appBar: AppBar(title: const Text("OBD2 BLE Scanner")),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: isScanning ? null : scanForDevices,
            child:
                isScanning
                    ? const Text("Scanning...")
                    : const Text("Scan for Devices"),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: allDevices.length,
              itemBuilder: (context, index) {
                final device = allDevices[index];
                return ListTile(
                  title: Text(
                    device.name.isNotEmpty ? device.name : "Unknown Device",
                  ),
                  subtitle: Text(device.id.toString()),
                  trailing: ElevatedButton(
                    onPressed: () => connectToDevice(device),
                    child: const Text("Connect"),
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () => sendOBD2Command("010C"),
            child: const Text("요청: 엔진 RPM"),
          ),
          ElevatedButton(
            onPressed: () => sendOBD2Command("010D"),
            child: const Text("요청: 차량 속도"),
          ),
          ElevatedButton(
            onPressed: () => sendOBD2Command("0105"),
            child: const Text("요청: 냉각수 온도"),
          ),
        ],
      ),
    );
  }
}
