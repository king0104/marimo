// car_payment_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:marimo_client/services/commons/api.dart';
import 'package:marimo_client/providers/car_payment_provider.dart';

class CarPaymentService {
  static final String baseUrl =
      dotenv.env['API_BASE_URL'] ?? 'http://j12a605.p.ssafy.io:8080';

  static Future<void> savePayment({
    required CarPaymentProvider provider,
    required String carId,
    required String accessToken,
  }) async {
    final category = provider.selectedCategory ?? '주유';

    // ✅ 카테고리에 따라 URL 분기
    String endpoint;
    switch (category) {
      case '주유':
        endpoint = '/api/v1/payments/oil';
        break;
      case '정비':
        endpoint = '/api/v1/payments/repair';
        break;
      case '세차':
        endpoint = '/api/v1/payments/wash';
        break;
      default:
        throw Exception('알 수 없는 카테고리: $category');
    }

    final url = Uri.parse('$baseUrl$endpoint');
    final headers = buildHeaders(token: accessToken);

    final bodyMap = provider.toJsonForDB(
      carId: carId,
      location: provider.location.isNotEmpty ? provider.location : null,
      memo: provider.memo.isNotEmpty ? provider.memo : null,
      fuelType: category == '주유' ? provider.fuelType : null,
      repairParts: category == '정비' ? provider.selectedRepairItems : null,
    );

    // 👇 디버깅 로그 추가
    print('📦 [디버그] provider.location: ${provider.location}');
    print('📦 [디버그] provider.memo: ${provider.memo}');
    print('📦 [디버그] provider.fuelType: ${provider.fuelType}');
    print('📦 [디버그] provider.repairParts: ${provider.selectedRepairItems}');
    print('📦 BodyMap to encode: $bodyMap');

    final body = jsonEncode(bodyMap);

    print('📡 [REQUEST] POST $url');
    print('🧾 Headers: $headers');
    print('📦 Body JSON: $body');

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseBody = utf8.decode(response.bodyBytes);
      print("✅ 결제 내역 저장 성공: $responseBody");
    } else {
      final errorMessage = utf8.decode(response.bodyBytes);
      print("❌ 결제 내역 저장 실패: $errorMessage");
      throw Exception("결제 저장 실패: $errorMessage");
    }
  }
}
