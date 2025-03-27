import 'package:flutter_dotenv/flutter_dotenv.dart';

// 공통 API 헬퍼: 모든 API 호출 시 기본 헤더를 생성합니다.
Map<String, String> buildHeaders({String? token}) {
  final headers = <String, String>{'Content-Type': 'application/json'};
  if (token != null && token.isNotEmpty) {
    headers['Authorization'] = 'Bearer $token';
  }
  return headers;
}
