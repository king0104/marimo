import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:marimo_client/services/commons/api.dart';

class UserService {
  static final String baseUrl =
      dotenv.env['API_BASE_URL'] ?? 'http://j12a605.p.ssafy.io:8080';

  /// 사용자 이름 조회
  static Future<String> getUserName({required String accessToken}) async {
    final url = Uri.parse('$baseUrl/api/v1/members/name');
    final headers = await buildHeaders(token: accessToken);

    print('📡 [REQUEST] GET $url');
    print('🧾 Headers: $headers');

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final body = utf8.decode(response.bodyBytes);
      final json = jsonDecode(body);
      final name = json['name'] as String?;

      if (name == null) {
        throw Exception("이름 정보가 없습니다");
      }

      print("✅ 사용자 이름: $name");
      return name;
    } else {
      final errorBody = utf8.decode(response.bodyBytes);
      print("❌ 사용자 이름 조회 실패: $errorBody");
      throw Exception("사용자 이름 조회 실패: $errorBody");
    }
  }
}
