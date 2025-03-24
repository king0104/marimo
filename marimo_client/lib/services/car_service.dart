import 'dart:convert';
import 'package:http/http.dart' as http;

class CarService {
  final String baseUrl;

  CarService({required this.baseUrl});

  Future<String?> registerCar({
    required Map<String, dynamic> carData,
    required String accessToken,
  }) async {
    final url = Uri.parse('$baseUrl/car/register');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(carData),
      );

      final data = jsonDecode(response.body);

      switch (response.statusCode) {
        case 200:
        case 201:
          return data['carId']; // 등록 성공 시 carId 반환

        case 400:
          throw Exception('잘못된 요청: ${data['errorMessage']}');
        case 401:
          throw Exception('인증 실패: ${data['errorMessage']}');
        case 500:
          throw Exception('서버 오류: ${data['errorMessage']}');
        default:
          throw Exception('알 수 없는 오류: ${response.statusCode}');
      }
    } catch (e) {
      print('🚨 차량 등록 중 오류: $e');
      rethrow;
    }
  }
}
