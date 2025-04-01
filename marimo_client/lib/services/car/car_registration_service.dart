import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:marimo_client/services/commons/api.dart';
import 'package:marimo_client/providers/car_registration_provider.dart';
import 'package:marimo_client/models/car_model.dart'; // ✅ CarModel import

class CarRegistrationService {
  static final String baseUrl =
      dotenv.env['API_BASE_URL'] ?? 'http://j12a605.p.ssafy.io:8080';

  static Future<CarModel> registerCar({
    required CarRegistrationProvider provider,
    required String accessToken,
  }) async {
    final url = Uri.parse('$baseUrl/api/v1/cars');
    final headers = buildHeaders(token: accessToken);
    final body = jsonEncode(provider.toJson());

    print('📡 [REQUEST] POST $url');
    print('🧾 Headers: $headers');
    print('📦 Body Map: ${provider.toJson()}');
    print('📦 Body JSON: $body');

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseBody = utf8.decode(response.bodyBytes);
      print("✅ 차량 등록 성공: $responseBody");

      final json = jsonDecode(responseBody);

      // ✅ carId만 들어 있는 경우 처리
      if (json['carId'] != null) {
        return CarModel(id: json['carId']);
      } else {
        throw Exception("서버 응답에 carId가 없습니다: $responseBody");
      }
    } else {
      final errorMessage = utf8.decode(response.bodyBytes);
      print("❌ 차량 등록 실패: $errorMessage");
      throw Exception("차량 등록 실패: $errorMessage");
    }
  }
}
