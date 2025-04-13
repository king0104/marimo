import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:marimo_client/models/member/email_verification_result_model.dart';

class AuthService {
  static final String baseUrl =
      dotenv.env['API_BASE_URL'] ?? 'http://j12a605.p.ssafy.io:8080';

  static String? _accessToken;

  static Map<String, String> buildHeaders({String? token}) {
    final headers = <String, String>{'Content-Type': 'application/json'};
    token ??= _accessToken;
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

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

  static Future<EmailVerificationResult> verifyEmailCode({
    required String email,
    required String authCode,
  }) async {
    final url = Uri.parse('$baseUrl/api/v1/auth/email/verify');
    final body = jsonEncode({'email': email, 'authCode': authCode});

    final response = await http.post(url, headers: buildHeaders(), body: body);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return EmailVerificationResult.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to verify email code: ${response.body}');
    }
  }

  static Future<String> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/api/v1/members/form');
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
