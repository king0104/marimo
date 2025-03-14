import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Obd2TestScreen extends StatefulWidget {
  const Obd2TestScreen({super.key});

  @override
  State<Obd2TestScreen> createState() => _Obd2TestScreenState();
}

class _Obd2TestScreenState extends State<Obd2TestScreen> {
  static const platform = MethodChannel('com.example.marimo_client/bluetooth');
  List<String> bluetoothDevices = []; // ✅ 블루투스 기기 목록 저장
  String? selectedDevice; // ✅ 사용자가 선택한 블루투스 기기
  String? selectedDeviceMac; // ✅ 선택된 기기의 MAC 주소

  // ✅ 블루투스 활성화 요청
  Future<void> navigateToBluetooth() async {
    try {
      final dynamic result = await platform.invokeMethod('connectBluetooth');

      if (result is bool) {
        print(
          "✅ Bluetooth Connection Success: ${result ? 'Enabled' : 'Failed to Enable'}",
        );
      } else if (result is String) {
        print("✅ Bluetooth Connection Result: $result");
      } else {
        print("❌ Unexpected Bluetooth Response Type: $result");
      }
    } on PlatformException catch (e) {
      print("❌ Failed to connect to Bluetooth: '${e.message}'");
    }
  }

  // ✅ 페어링된 블루투스 기기 목록 가져오기
  Future<void> getPairedDevices() async {
    try {
      final List<dynamic> devices = await platform.invokeMethod(
        'getPairedDevices',
      );
      setState(() {
        bluetoothDevices = devices.cast<String>();
      });
      print("✅ Paired Bluetooth Devices: $bluetoothDevices");
    } on PlatformException catch (e) {
      print("❌ Failed to get paired devices: '${e.message}'");
    }
  }

  // ✅ 블루투스 기기 선택 다이얼로그 띄우기
  Future<void> showBluetoothDevicePicker() async {
    try {
      final String? macAddress = await platform.invokeMethod(
        'showBluetoothDevicePicker',
      );

      if (macAddress != null && macAddress.isNotEmpty) {
        setState(() {
          selectedDeviceMac = macAddress;
        });

        print("✅ Selected Device MAC Address: $selectedDeviceMac");
      } else {
        print("❌ No device selected.");
      }
    } on PlatformException catch (e) {
      print("❌ Failed to show Bluetooth picker: '${e.message}'");
    }
  }

  // ✅ 사용자가 선택한 기기 연결
  Future<void> connectToSelectedDevice() async {
    if (selectedDeviceMac == null) {
      print("❌ No device selected for connection.");
      return;
    }

    try {
      final String result = await platform.invokeMethod(
        'connectToDevice',
        selectedDeviceMac,
      );
      print("✅ Connected to Selected Device: $result");
    } on PlatformException catch (e) {
      print("❌ Failed to connect to selected device: '${e.message}'");
    }
  }

  // ✅ Galaxy Buds+ 자동 연결
  Future<void> connectToGalaxyBuds() async {
    try {
      final String macAddress = await platform.invokeMethod(
        'getGalaxyBudsMacAddress',
      );
      print("✅ Found Galaxy Buds MAC Address: $macAddress");

      final String result = await platform.invokeMethod(
        'connectToDevice',
        macAddress,
      );
      print("✅ Connected to Galaxy Buds+: $result");
    } on PlatformException catch (e) {
      print("❌ Failed to connect to Galaxy Buds+: '${e.message}'");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("OBD2 Test Screen")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton(
              onPressed: navigateToBluetooth,
              child: const Text("블루투스 연결"),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: getPairedDevices,
              child: const Text("페어링된 블루투스 기기 목록"),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: showBluetoothDevicePicker,
              child: const Text("블루투스 기기 선택"),
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: connectToGalaxyBuds,
              child: const Text("Galaxy Buds+ 자동 연결"),
            ),
          ),
          if (selectedDeviceMac != null) ...[
            const SizedBox(height: 20),
            Text(
              "선택된 기기 MAC: $selectedDeviceMac",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: connectToSelectedDevice,
                child: const Text("선택한 기기 연결"),
              ),
            ),
          ],
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: bluetoothDevices.length,
              itemBuilder: (context, index) {
                final device = bluetoothDevices[index];

                return ListTile(
                  leading: const Icon(Icons.bluetooth),
                  title: Text(device),
                  onTap: () {
                    final macAddressMatch = RegExp(
                      r"([0-9A-Fa-f]{2}(:|-)){5}[0-9A-Fa-f]{2}",
                    ).firstMatch(device);
                    final macAddress = macAddressMatch?.group(0);

                    if (macAddress != null) {
                      setState(() {
                        selectedDevice = device;
                        selectedDeviceMac = macAddress;
                      });

                      print("✅ Selected Device: $selectedDeviceMac");
                    } else {
                      print("❌ Invalid MAC Address: $device");
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
