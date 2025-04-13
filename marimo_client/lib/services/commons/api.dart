import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final secureStorage = FlutterSecureStorage();

// 공통 API 헬퍼: 모든 API 호출 시 기본 헤더를 생성합니다.
Future<Map<String, String>> buildHeaders({String? token}) async {
  final headers = <String, String>{'Content-Type': 'application/json'};

  // 토큰이 null이면 secure storage에서 시도
  if (token == null || token.isEmpty) {
    token = await secureStorage.read(key: 'accessToken');
    print('📦 SecureStorage에서 토큰 불러옴: $token');
  }

  if (token != null && token.isNotEmpty) {
    headers['Authorization'] = 'Bearer $token';
  }

  return headers;
}
