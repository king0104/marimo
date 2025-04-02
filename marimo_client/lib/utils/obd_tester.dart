import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

Map<String, String> parseRawObdTextToMap(String raw) {
  final lines = raw.split('\n');
  final Map<String, String> result = {};
  String? currentPid;

  for (final line in lines) {
    final trimmed = line.trim();

    if (trimmed.startsWith('PID')) {
      final split = trimmed.split(':');
      if (split.length == 2) {
        currentPid = split[0].replaceAll('PID ', '').trim();
        final value = split[1].trim();
        if (value.isNotEmpty) {
          result[currentPid] = value;
        }
      }
    } else if (currentPid != null) {
      // 이전 PID가 있고, 줄바꿈된 응답이 있을 때 이어 붙이기
      result[currentPid] = '${result[currentPid]!}\n$trimmed';
    }
  }

  return result;
}

Future<void> saveRawObdTextToLocal(String raw) async {
  final map = parseRawObdTextToMap(raw);
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('last_obd_data', jsonEncode(map));
}
