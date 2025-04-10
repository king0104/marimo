import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:marimo_client/services/commons/api.dart';
import 'package:marimo_client/screens/Insurance/SelectInsuranceScreen.dart';

// 커스텀 예외 클래스 추가
class InsuranceException implements Exception {
  final int statusCode;
  final String message;

  InsuranceException(this.statusCode, this.message);

  @override
  String toString() => message;
}

class InsuranceService {
  static final String baseUrl =
      dotenv.env['API_BASE_URL'] ?? 'http://j12a605.p.ssafy.io:8080';

  static Future<String> registerInsurance({
    required String carId,
    required String accessToken,
    required String insuranceCompanyName,
    required String startDate,
    required String endDate,
    required String distanceRegistrationDate,
    required int registeredDistance,
    required int insurancePremium,
  }) async {
    final url = Uri.parse('$baseUrl/api/v1/car-insurances/cars/$carId');
    final headers = await buildHeaders(token: accessToken);

    final body = jsonEncode({
      'insuranceCompanyName': insuranceCompanyName.toLowerCase(),
      'startDate': startDate,
      'endDate': endDate,
      'distanceRegistrationDate': distanceRegistrationDate,
      'registeredDistance': registeredDistance,
      'insurancePremium': insurancePremium,
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final json = jsonDecode(utf8.decode(response.bodyBytes));
      return json['carInsuranceId'];
    } else {
      final errorMessage = utf8.decode(response.bodyBytes);
      switch (response.statusCode) {
        case 400:
          throw Exception("필수 정보가 누락되었습니다");
        case 403:
          throw Exception("권한이 없습니다");
        default:
          throw Exception("보험 등록 실패: $errorMessage");
      }
    }
  }

  static String _formatDate(String date, {required bool isEndDate}) {
    // YYYY.MM.DD -> YYYY-MM-DDT00:00:00 or YYYY-MM-DDT23:59:59
    final parts = date.split('.');
    final time = isEndDate ? "23:59:59" : "00:00:00";
    return "${parts[0]}-${parts[1].padLeft(2, '0')}-${parts[2].padLeft(2, '0')}T$time";
  }

  static Future<Map<String, dynamic>> getInsuranceInfo(
    String carId,
    String accessToken,
  ) async {
    final url = Uri.parse('$baseUrl/api/v1/car-insurances/cars/$carId');
    final headers = await buildHeaders(token: accessToken);

    print('📡 [REQUEST] GET $url');
    print('🧾 Headers: $headers');

    try {
      final response = await http
          .get(url, headers: headers)
          .timeout(const Duration(seconds: 10));

      print('📩 [RESPONSE] Status Code: ${response.statusCode}');
      print('📩 [RESPONSE] Body: ${utf8.decode(response.bodyBytes)}');

      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes));
      } else {
        switch (response.statusCode) {
          case 403:
            throw InsuranceException(403, "권한이 없습니다");
          case 404:
            throw InsuranceException(404, "보험 정보를 찾을 수 없습니다");
          default:
            throw InsuranceException(response.statusCode, "보험 정보 조회 실패");
        }
      }
    } catch (e) {
      print('🚨 Error: $e');
      rethrow;
    }
  }

  // 보험사 코드로 한글 이름 찾기 helper 메서드
  static String getInsuranceNameByCode(String code) {
    final companies = SelectInsuranceScreen.insuranceCompanies;
    final company = companies.firstWhere(
      (company) => company['code'] == code,
      orElse: () => {'name': '알 수 없는 보험사', 'logo': ''},
    );
    return company['name'];
  }

  // 보험사 코드로 로고 경로 찾기 helper 메서드
  static String getInsuranceLogoByCode(String code) {
    final companies = SelectInsuranceScreen.insuranceCompanies;
    final company = companies.firstWhere(
      (company) => company['code'] == code,
      orElse: () => {'name': '알 수 없는 보험사', 'logo': ''},
    );
    return company['logo'];
  }

  static Future<void> deleteInsurance(
    String carInsuranceId,
    String accessToken,
  ) async {
    final url = Uri.parse('$baseUrl/api/v1/car-insurances/$carInsuranceId');
    final headers = await buildHeaders(token: accessToken);

    try {
      final response = await http.delete(url, headers: headers);

      if (response.statusCode != 200) {
        final errorMessage = utf8.decode(response.bodyBytes);
        switch (response.statusCode) {
          case 400:
            throw Exception("삭제 요청이 잘못되었습니다");
          case 404:
            throw Exception("보험 정보를 찾을 수 없습니다");
          case 500:
            throw Exception("서버 오류가 발생했습니다");
          default:
            throw Exception("보험 삭제 실패: $errorMessage");
        }
      }
    } catch (e) {
      rethrow;
    }
  }
}
