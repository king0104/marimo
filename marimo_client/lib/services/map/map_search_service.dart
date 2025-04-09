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
    int? radius,
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
      "latitude": 37.500612, // latitude,
      "longitude": 127.036431, //longitude,
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

    final status = response.statusCode;
    final rawBody = utf8.decode(response.bodyBytes);

    print('📬 [RESPONSE STATUS] $status');
    print('📬 [RESPONSE BODY] $rawBody');

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
  /// 정비소 추천 목록 조회
  static Future<List<Map<String, dynamic>>> getRepairShops({
    required String accessToken,
    required double latitude,
    required double longitude,
  }) async {
    final url = Uri.parse(
      '$baseUrl/api/v1/maps/recommend/repair'
      '?latitude=$latitude&longitude=$longitude',
    );

    final headers = buildHeaders(token: accessToken);

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final decoded = utf8.decode(response.bodyBytes);
      final List<Map<String, dynamic>> result =
          (jsonDecode(decoded) as List).cast<Map<String, dynamic>>();
      print("✅ 정비소 추천 목록 응답: $result");
      return result;
    } else {
      throw Exception("정비소 API 실패: ${response.statusCode} - ${response.body}");
    }
  }

  /// 세차장 추천 목록 조회 (추후 구현)
  static Future<List<Map<String, dynamic>>> getCarWashes({
    required String accessToken,
  }) async {
    throw UnimplementedError('세차장 추천 API는 아직 준비 중입니다.');
  }
}
