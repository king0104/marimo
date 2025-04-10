// car_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:marimo_client/models/car_model.dart';
import 'package:marimo_client/services/commons/api.dart';

class CarService {
  static final String baseUrl =
      dotenv.env['API_BASE_URL'] ?? 'http://j12a605.p.ssafy.io:8080';

  /// 차량 목록 조회
  static Future<List<CarModel>> getCars({required String accessToken}) async {
    final url = Uri.parse('$baseUrl/api/v1/cars');
    final headers = await buildHeaders(token: accessToken);

    print('📡 [REQUEST] GET $url');
    print('🧾 Headers: $headers');

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final body = utf8.decode(response.bodyBytes);
      final json = jsonDecode(body);
      print("✅ 차량 목록 응답: $json");

      final List<dynamic> carListJson = json['carInfoDtos'] ?? [];
      return carListJson
          .map((e) => CarModel.fromJson({...e, 'id': e['carId']}))
          .toList();
    } else {
      final errorBody = utf8.decode(response.bodyBytes);
      print("❌ 차량 목록 조회 실패: $errorBody");
      throw Exception("차량 목록 조회 실패: $errorBody");
    }
  }
}
