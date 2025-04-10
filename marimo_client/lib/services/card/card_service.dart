// card_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:marimo_client/services/commons/api.dart';

class CardInfo {
  final String cardUniqueNo;
  final String cardIssuerName;
  final String cardName;
  final String cardDescription;
  final String baselinePerformance;

  CardInfo({
    required this.cardUniqueNo,
    required this.cardIssuerName,
    required this.cardName,
    required this.cardDescription,
    required this.baselinePerformance,
  });

  factory CardInfo.fromJson(Map<String, dynamic> json) {
    return CardInfo(
      cardUniqueNo: json['cardUniqueNo'],
      cardIssuerName: json['cardIssuerName'],
      cardName: json['cardName'],
      cardDescription: json['cardDescription'],
      baselinePerformance: json['baselinePerformance'],
    );
  }
}

class CardService {
  static final String baseUrl =
      dotenv.env['API_BASE_URL'] ?? 'http://j12a605.p.ssafy.io:8080';

  /// 주유 카드 목록 조회
  static Future<List<CardInfo>> getCards({required String accessToken}) async {
    final url = Uri.parse('$baseUrl/api/v1/cards');
    final headers = await buildHeaders(token: accessToken);

    print('📡 [REQUEST] GET $url');
    print('🧾 Headers: $headers');

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final body = utf8.decode(response.bodyBytes);
      final json = jsonDecode(body);
      print("✅ 카드 목록 응답: $json");

      final List<dynamic> cardListJson = json['cards'] ?? [];
      return cardListJson.map((e) => CardInfo.fromJson(e)).toList();
    } else {
      final errorBody = utf8.decode(response.bodyBytes);
      print("❌ 카드 목록 조회 실패: $errorBody");
      throw Exception("카드 목록 조회 실패: $errorBody");
    }
  }

  static Future<void> registerUserOilCard({
    required String accessToken,
    required String cardUniqueNo,
  }) async {
    final url = Uri.parse('$baseUrl/api/v1/cards/oil/me');
    final headers = await buildHeaders(token: accessToken);

    final body = jsonEncode({"cardUniqueNo": cardUniqueNo});

    print('📡 [REQUEST] POST $url');
    print('🧾 Headers: $headers');
    print('📦 Body: $body');

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 201) {
      final responseBody = utf8.decode(response.bodyBytes);
      print("✅ 주유 카드 등록 성공! 응답 바디 : $responseBody");
    } else {
      final errorBody = utf8.decode(response.bodyBytes);
      print("❌ 주유 카드 등록 실패: $errorBody");
      throw Exception("주유 카드 등록 실패: $errorBody");
    }
  }
}
