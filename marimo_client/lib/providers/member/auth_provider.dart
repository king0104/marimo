import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:marimo_client/mocks/obd_sample.dart';
import 'package:marimo_client/providers/car_provider.dart';
import 'package:marimo_client/services/user/user_service.dart';
import 'package:marimo_client/services/car/obd_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final secureStorage = FlutterSecureStorage();

class AuthProvider extends ChangeNotifier {
  String? _accessToken;
  String? _userName;

  String? get accessToken => _accessToken;
  String? get userName => _userName;

  bool get isLoggedIn => _accessToken != null && _accessToken!.isNotEmpty;

  // ✅ 앱 시작 시 호출
  Future<void> loadTokenFromStorage([BuildContext? context]) async {
    final token = await secureStorage.read(key: 'accessToken');
    if (token == null || token.isEmpty) return;

    final isExpired = _isTokenExpired(token, debug: true);
    if (isExpired) {
      print('⏰ 저장된 토큰 만료됨 → 자동 로그아웃 처리');
      await logout();
      return;
    }

    _accessToken = token;
    await _loadUserName(context); // ✅ context 넘기되 null도 가능
    notifyListeners();
  }

  // ✅ 로그인 후 토큰 저장
  void setAccessToken(String token, [BuildContext? context]) async {
    _accessToken = token;
    await secureStorage.write(key: 'accessToken', value: token);

    final exp = _getTokenExp(token);
    if (exp != null) {
      final expiryDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      print('🔐 accessToken 저장됨 (exp: $exp)');
      print('⏳ 만료 시간: $expiryDate');
    }

    await _loadUserName(context);
    notifyListeners();
  }

  // ✅ 토큰 만료 여부 판단
  bool _isTokenExpired(String token, {bool debug = false}) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return true;

      final payload = json.decode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
      );
      final exp = payload['exp'];

      final expiryDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      final now = DateTime.now();

      if (debug) {
        print('🕒 현재 시각: $now');
        print('🧭 토큰 만료 시각: $expiryDate');
        print('📌 남은 시간: ${expiryDate.difference(now).inSeconds}초');
      }

      return now.isAfter(expiryDate);
    } catch (e) {
      print('❌ 토큰 디코딩 실패: $e');
      return true;
    }
  }

  // ✅ exp만 따로 뽑는 함수 (로그용)
  int? _getTokenExp(String token) {
    try {
      final parts = token.split('.');
      final payload = json.decode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
      );
      return payload['exp'];
    } catch (_) {
      return null;
    }
  }

  // ✅ 사용자 이름 불러오기
  Future<void> _loadUserName([BuildContext? context]) async {
    if (_accessToken == null) return;

    try {
      final name = await UserService.getUserName(accessToken: _accessToken!);
      _userName = name;

      if (name == '차미정') {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('last_obd_data');
        await preloadSampleObdDataIfNeeded();

        final distance = parseDistanceSinceDtcCleared();

        if (distance != null && context != null) {
          final carProvider = Provider.of<CarProvider>(context, listen: false);
          final carId = carProvider.firstCarId;

          if (carId != null) {
            await ObdService.sendTotalDistance(
              carId: carId,
              totalDistance: distance,
              accessToken: _accessToken!,
            );
            print('📨 샘플 주행거리 전송 완료: $distance km');
          } else {
            print('🚫 차량 ID 없음 → 주행거리 전송 생략');
          }
        } else {
          print('⚠️ context 없음 → 주행거리 전송 생략');
        }

        final sampleDtcCodes = [
          'P2430',
          'C0300',
          'B0024',
          'C3EA0',
          'P3007',
          'U2902',
          'P07EB',
          'P0243',
        ];
        await prefs.setStringList('stored_dtc_codes', sampleDtcCodes);
        print('💾 샘플 DTC 코드 삽입 완료: $sampleDtcCodes');

        print('🌱 marimo 사용자: 샘플 OBD + 거리 + DTC 삽입 완료');
      }
    } catch (e) {
      print('❌ 사용자 이름 로드 실패: $e');
    }
  }

  Future<void> logout() async {
    _accessToken = null;
    _userName = null;
    await secureStorage.delete(key: 'accessToken');
    notifyListeners();
  }
}
