import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:marimo_client/models/member/email_verification_result_model.dart';

class AuthService {
  // .env에 설정된 API_BASE_URL을 읽어오고, 없으면 기본값 사용
  static final String baseUrl =
      dotenv.env['API_BASE_URL'] ?? 'http://j12a605.p.ssafy.io:8080';

  // 전역적으로 accessToken을 저장 (추후 모든 API 요청 시 사용)
  static String? _accessToken;

  /// accessToken을 포함한 공통 헤더 생성 (token 인수가 없으면 전역 _accessToken 사용)
  static Map<String, String> buildHeaders({String? token}) {
    final headers = <String, String>{'Content-Type': 'application/json'};
    token ??= _accessToken;
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  /// 회원가입 POST /api/v1/members (JSON 방식)
  static Future<bool> signUp({
    required String email,
    required String name,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/api/v1/members');
    final body = jsonEncode({
      'email': email,
      'name': name,
      'password': password,
    });

    final response = await http.post(url, headers: buildHeaders(), body: body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      throw Exception('Failed to sign up: ${response.body}');
    }
  }

  /// 이메일 인증코드 전송 POST /api/v1/auth/email/send (JSON 방식)
  static Future<bool> sendEmailVerificationCode({required String email}) async {
    final url = Uri.parse('$baseUrl/api/v1/auth/email/send');
    final body = jsonEncode({'email': email});

    final response = await http.post(url, headers: buildHeaders(), body: body);

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(
        'Failed to send email verification code: ${response.body}',
      );
    }
  }

  /// 이메일 인증코드 검증 POST /api/v1/auth/email/verify (JSON 방식)
  static Future<EmailVerificationResult> verifyEmailCode({
    required String email,
    required String authCode,
  }) async {
    final url = Uri.parse('$baseUrl/api/v1/auth/email/verify');
    final body = jsonEncode({'email': email, 'authCode': authCode});

    final response = await http.post(url, headers: buildHeaders(), body: body);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return EmailVerificationResult.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to verify email code: ${response.body}');
    }
  }

  /// 로그인 요청: POST /api/v1/members/form (form-data 방식)
  /// 로그인 성공 시 응답 헤더의 'Authorization: Bearer {accessToken}'에서 토큰을 추출하고 전역에 저장합니다.
  static Future<String> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/api/v1/members/form');
    // form-data 형식: application/x-www-form-urlencoded
    final body =
        "email=${Uri.encodeComponent(email)}&password=${Uri.encodeComponent(password)}";

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: body,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final authHeader = response.headers['authorization'];
      if (authHeader != null && authHeader.startsWith('Bearer ')) {
        final token = authHeader.substring(7);
        // 전역 변수 업데이트
        _accessToken = token;
        return token;
      } else {
        throw Exception("로그인 성공했으나 access token을 받지 못했습니다.");
      }
    } else {
      throw Exception("로그인 실패: ${response.body}");
    }
  }
}
