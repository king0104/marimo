import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';

import 'package:marimo_client/services/commons/api.dart';
import 'package:marimo_client/providers/obd_polling_provider.dart';

class ObdService {
  static final String baseUrl =
      dotenv.env['API_BASE_URL'] ?? 'http://j12a605.p.ssafy.io:8080';

  /// ✅ OBD 응답값을 서버 포맷에 맞춰 변환
  static List<Map<String, String>> formatObdData(
    Map<String, String> responses,
  ) {
    return responses.entries.map((entry) {
      return {
        'pid': entry.key.toUpperCase(), // 예: '0C'
        'code': entry.value.toUpperCase(), // 예: '0B86'
      };
    }).toList();
  }

  /// ✅ 서버로 OBD 데이터 전송
  static Future<void> sendObdData({
    required String carId,
    required String accessToken,
    required ObdPollingProvider provider,
  }) async {
    final url = Uri.parse('$baseUrl/api/v1/obd2/cars/$carId');
    final headers = buildHeaders(token: accessToken);

    final formattedData = formatObdData(provider.responses);
    final timestamp = DateFormat("yyyy-MM-ddTHH:mm:ss").format(DateTime.now());

    final body = jsonEncode({
      'clientCreatedAt': timestamp,
      'obd2RawDatas': formattedData,
    });

    print('📡 [REQUEST] POST $url');
    print('🧾 Headers: $headers');
    print('📦 Body JSON: $body');

    final response = await http.post(url, headers: headers, body: body);

    final decoded = utf8.decode(response.bodyBytes);
    if (response.statusCode == 200 || response.statusCode == 201) {
      print("✅ OBD2 데이터 전송 성공: $decoded");
    } else {
      print("❌ OBD2 데이터 전송 실패: $decoded");
      throw Exception("OBD2 데이터 전송 실패: $decoded");
    }
  }

  static Future<void> sendTotalDistance({
    required String carId,
    required int totalDistance,
    required String accessToken,
  }) async {
    final url = Uri.parse('$baseUrl/api/v1/cars/$carId/total-distance');
    final headers = buildHeaders(token: accessToken);

    final body = jsonEncode({'totalDistance': totalDistance});

    print('📡 [REQUEST] POST $url');
    print('🧾 Headers: $headers');
    print('📦 Body JSON: $body');

    final response = await http.patch(url, headers: headers, body: body);

    final decoded = utf8.decode(response.bodyBytes);
    if (response.statusCode == 200 || response.statusCode == 201) {
      print("✅ 주행거리 전송 성공: $decoded");
    } else {
      print("❌ 주행거리 전송 실패: $decoded");
      throw Exception("주행거리 전송 실패: $decoded");
    }
  }
}
