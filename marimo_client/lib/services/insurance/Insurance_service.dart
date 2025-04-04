import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:marimo_client/services/commons/api.dart';

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
    final headers = buildHeaders(token: accessToken);
    
    // 날짜 형식 변환 (YYYY.MM.DD -> YYYY-MM-DDT00:00:00)
    final formattedStartDate = _formatDate(startDate, isEndDate: false);
    final formattedEndDate = _formatDate(endDate, isEndDate: true);
    final formattedRegistrationDate = _formatDate(distanceRegistrationDate, isEndDate: false);

    final body = jsonEncode({
      'insuranceCompanyName': insuranceCompanyName.toLowerCase(),
      'startDate': formattedStartDate,
      'endDate': formattedEndDate,
      'distanceRegistrationDate': formattedRegistrationDate,
      'registeredDistance': registeredDistance,
      'insurancePremium': insurancePremium,
    });

    print('📡 [REQUEST] POST $url');
    print('🧾 Headers: $headers');
    print('📦 Body: $body');

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseBody = utf8.decode(response.bodyBytes);
      print("✅ 보험 등록 성공: $responseBody");
      
      final json = jsonDecode(responseBody);
      return json['carInsuranceId'];
    } else {
      final errorMessage = utf8.decode(response.bodyBytes);
      print("❌ 보험 등록 실패: $errorMessage");
      
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
}
