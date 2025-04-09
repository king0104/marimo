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

  // 저장
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
      print('🔴 서버 응답 코드: ${response.statusCode}');
      print('🔴 서버 응답 본문: ${utf8.decode(response.bodyBytes)}');
      final errorMessage = utf8.decode(response.bodyBytes);
      throw Exception("결제 저장 실패: $errorMessage");
    }
  }

  // ✅ 조회
  static Future<List<CarPaymentEntry>> fetchPaymentsByMonth({
    required String carId,
    required int year,
    required int month,
    required String accessToken,
  }) async {
    final url = Uri.parse(
      '$baseUrl/api/v1/payments/cars/$carId?year=$year&month=$month',
    );
    final headers = buildHeaders(token: accessToken);

    final response = await http.get(url, headers: headers);

    // print('📡 응답 JSON: ${utf8.decode(response.bodyBytes)}');

    if (response.statusCode == 200) {
      // JSON 응답을 Map으로 파싱
      final Map<String, dynamic> responseData = jsonDecode(
        utf8.decode(response.bodyBytes),
      );

      // 'payments' 키에서 실제 결제 목록을 가져옴
      final List<dynamic> paymentsList = responseData['payments'] ?? [];

      // 각 결제 항목을 CarPaymentEntry 객체로 변환
      final entries =
          paymentsList.map((item) => CarPaymentEntry.fromJson(item)).toList();

      return entries;
    } else {
      print('📡 최종 요청 URL: $url');
      print('📡 요청 헤더: $headers');
      print('❌ 전체 차계부 조회 실패 응답 코드: ${response.statusCode}');
      print('❌ 응답 내용: ${utf8.decode(response.bodyBytes)}');
      print('🔐 accessToken: $accessToken');

      throw Exception('전체 차계부 조회 실패: ${utf8.decode(response.bodyBytes)}');
    }
  }

  /// ✅ 현재 달 + 전월 데이터를 함께 조회하는 메서드
  static Future<Map<String, List<CarPaymentEntry>>>
  fetchCurrentAndPreviousMonth({
    required String carId,
    required int selectedYear,
    required int selectedMonth,
    required String accessToken,
  }) async {
    // 전월 계산
    int prevMonth = selectedMonth - 1;
    int prevYear = selectedYear;
    if (prevMonth == 0) {
      prevMonth = 12;
      prevYear--;
    }

    final headers = buildHeaders(token: accessToken);

    final currentUrl = Uri.parse(
      '$baseUrl/api/v1/payments/cars/$carId?year=$selectedYear&month=$selectedMonth',
    );
    final previousUrl = Uri.parse(
      '$baseUrl/api/v1/payments/cars/$carId?year=$prevYear&month=$prevMonth',
    );

    final currentResponse = await http.get(currentUrl, headers: headers);
    final prevResponse = await http.get(previousUrl, headers: headers);

    if (currentResponse.statusCode == 200 && prevResponse.statusCode == 200) {
      final currentData = jsonDecode(utf8.decode(currentResponse.bodyBytes));
      final prevData = jsonDecode(utf8.decode(prevResponse.bodyBytes));

      final currentList =
          (currentData['payments'] ?? [])
              .map<CarPaymentEntry>((item) => CarPaymentEntry.fromJson(item))
              .toList();

      final prevList =
          (prevData['payments'] ?? [])
              .map<CarPaymentEntry>((item) => CarPaymentEntry.fromJson(item))
              .toList();

      return {'current': currentList, 'previous': prevList};
    } else {
      throw Exception(
        '현재/전월 데이터 조회 실패\n'
        '현재 응답: ${utf8.decode(currentResponse.bodyBytes)}\n'
        '전월 응답: ${utf8.decode(prevResponse.bodyBytes)}',
      );
    }
  }

  // 개별 내역 조회
  static Future<Map<String, dynamic>> fetchPaymentDetail({
    required String paymentId,
    required String category,
    required String accessToken,
  }) async {
    String endpoint;
    switch (category) {
      case '주유':
        endpoint = '/api/v1/payments/$paymentId/oil';
        break;
      case '정비':
        endpoint = '/api/v1/payments/$paymentId/repair';
        break;
      case '세차':
        endpoint = '/api/v1/payments/$paymentId/wash';
        break;
      default:
        throw Exception('알 수 없는 카테고리: $category');
    }

    final url = Uri.parse('$baseUrl$endpoint');
    final headers = buildHeaders(token: accessToken);

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      return decoded;
    } else {
      throw Exception('상세 조회 실패: ${utf8.decode(response.bodyBytes)}');
    }
  }
}
