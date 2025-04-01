import 'package:permission_handler/permission_handler.dart';

Future<void> requestBluetoothPermissions() async {
  if (await Permission.bluetoothConnect.isDenied) {
    await Permission.bluetoothConnect.request();
  }

  if (await Permission.bluetoothScan.isDenied) {
    await Permission.bluetoothScan.request();
  }

  if (await Permission.location.isDenied) {
    await Permission.location.request();
  }
}
