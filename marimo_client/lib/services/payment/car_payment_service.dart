// car_payment_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:marimo_client/services/commons/api.dart';
import 'package:marimo_client/providers/car_payment_provider.dart';
import 'package:marimo_client/models/payment/car_payment_entry.dart';

class CarPaymentService {
  static final String baseUrl =
      dotenv.env['API_BASE_URL'] ?? 'http://j12a605.p.ssafy.io:8080';

  static Future<String> savePayment({
    required CarPaymentProvider provider,
    required String carId,
    required String accessToken,
  }) async {
    final category = provider.selectedCategory ?? '주유';

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

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(bodyMap),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      final paymentId = decoded['paymentId']; // 서버 응답에서 paymentId 추출
      print("✅ 결제 내역 저장 성공: paymentId = $paymentId");
      return paymentId; // ✅ 반환
    } else {
      final errorMessage = utf8.decode(response.bodyBytes);
      throw Exception("결제 저장 실패: $errorMessage");
    }
  }

  static Future<List<CarPaymentEntry>> fetchPaymentsByMonth({
    required int year,
    required int month,
    required String accessToken,
  }) async {
    final url = Uri.parse('$baseUrl/api/v1/payments?year=$year&month=$month');
    final headers = buildHeaders(token: accessToken);

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));

      return data.map((item) {
        return CarPaymentEntry(
          paymentId: item['id'].toString(),
          category: item['category'],
          amount: item['price'],
          date: DateTime.parse(item['paymentDate']),
          details: item,
        );
      }).toList();
    } else {
      final message = utf8.decode(response.bodyBytes);
      throw Exception('전체 차계부 조회 실패: $message');
    }
  }
}
