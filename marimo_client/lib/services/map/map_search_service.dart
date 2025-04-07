import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:marimo_client/services/commons/api.dart';

class MapSearchService {
  static final String baseUrl =
      dotenv.env['API_BASE_URL'] ?? 'http://j12a605.p.ssafy.io:8080';

  /// ✅ 주유소 추천 목록 조회 (POST 방식 + 필터 포함)
  static Future<List<Map<String, dynamic>>> getGasStations({
    required String accessToken,
    required double latitude,
    required double longitude,
    int radius = 3,
    List<String>? brandList, // ✅ 수정
    String? oilType, // ✅ 수정
    bool? hasSelfService,
    bool? hasMaintenance,
    bool? hasCarWash,
    bool? hasCvs,
  }) async {
    final url = Uri.parse('$baseUrl/api/v1/maps/recommend/gas');
    final headers = buildHeaders(token: accessToken);

    final body = jsonEncode({
      "latitude": latitude,
      "longitude": longitude,
      "radius": radius,
      "hasSelfService": hasSelfService,
      "hasMaintenance": hasMaintenance,
      "hasCarWash": hasCarWash,
      "hasCvs": hasCvs,
      "brandList": brandList,
      "oilType": oilType,
    });

    print('📡 [REQUEST] POST $url');
    print('🧾 Headers: $headers');
    print('📦 Body: $body');

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final body = utf8.decode(response.bodyBytes);
      final json = jsonDecode(body); // 실제로는 List<dynamic>
      print("✅ 주유소 추천 목록 응답: $json");

      final List<Map<String, dynamic>> gasStations =
          (json as List).cast<Map<String, dynamic>>();

      return gasStations;
    } else {
      final errorBody = utf8.decode(response.bodyBytes);
      print("❌ 주유소 추천 조회 실패: $errorBody");
      throw Exception("주유소 추천 조회 실패: $errorBody");
    }
  }

  /// 정비소 추천 목록 조회 (추후 구현)
  static Future<List<Map<String, dynamic>>> getRepairShops({
    required String accessToken,
  }) async {
    throw UnimplementedError('정비소 추천 API는 아직 준비 중입니다.');
  }

  /// 세차장 추천 목록 조회 (추후 구현)
  static Future<List<Map<String, dynamic>>> getCarWashes({
    required String accessToken,
  }) async {
    throw UnimplementedError('세차장 추천 API는 아직 준비 중입니다.');
  }
}
