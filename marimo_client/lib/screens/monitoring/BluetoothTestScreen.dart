import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class BluetoothTestScreen extends StatefulWidget {
  const BluetoothTestScreen({super.key});

  @override
  State<BluetoothTestScreen> createState() => _BluetoothTestScreenState();
}

class _BluetoothTestScreenState extends State<BluetoothTestScreen> {
  List<BluetoothDevice> pairedDevices = []; // ✅ 기존에 페어링된 장치 목록
  List<ScanResult> scanResults = []; // ✅ 스캔된 BLE 장치 목록
  bool isScanning = false;

  @override
  void initState() {
    super.initState();
    requestBluetoothPermissions();
    getBondedDevices(); // ✅ 페어링된 기기 가져오기
    FlutterBluePlus.scanResults.listen((results) {
      setState(() {
        scanResults =
            results
                .where(
                  (result) => result.device.name.isNotEmpty,
                ) // ✅ Unknown Device 제거
                .toList();
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
    if (isScanning) return; // 이미 스캔 중이면 실행하지 않음

    setState(() {
      isScanning = true;
      scanResults.clear();
    });

    print("✅ Start BLE Scan...");

    FlutterBluePlus.startScan(
      timeout: const Duration(seconds: 5),
      androidLegacy: true, // ✅ BLE 장치 검색 활성화
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
      await device.connect();
      print("✅ Connected to ${device.name} (${device.id})");
      setState(() {
        if (!pairedDevices.contains(device)) {
          pairedDevices.add(device); // ✅ 연결된 기기 추가
        }
      });
    } catch (e) {
      print("❌ Failed to connect: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    List<BluetoothDevice> allDevices =
        [
          ...pairedDevices, // ✅ 기존 페어링된 장치
          ...scanResults.map((result) => result.device), // ✅ 스캔된 장치
        ].toSet().toList(); // ✅ 중복 제거

    return Scaffold(
      appBar: AppBar(title: const Text("Bluetooth Test Screen")),
      body: Column(
        children: [
          Center(
            child: ElevatedButton(
              onPressed: isScanning ? null : scanForDevices,
              child:
                  isScanning
                      ? const Text("Scanning...")
                      : const Text("Scan for Devices"),
            ),
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
        ],
      ),
    );
  }
}
