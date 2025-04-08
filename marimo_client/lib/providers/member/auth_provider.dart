import 'package:flutter/material.dart';
import 'package:marimo_client/mocks/obd_sample.dart';
import 'package:marimo_client/services/user/user_service.dart';
import 'package:marimo_client/services/car/obd_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  String? _accessToken;
  String? _userName;

  String? get accessToken => _accessToken;
  String? get userName => _userName;

  bool get isLoggedIn => _accessToken != null && _accessToken!.isNotEmpty;

  // 로그인 성공 시 accessToken 설정 및 사용자 이름 로드
  void setAccessToken(String token) {
    _accessToken = token;
    _loadUserName(); // 토큰 설정 시 자동으로 사용자 이름 로드
    notifyListeners();
  }

  // 사용자 이름 로드
  Future<void> _loadUserName() async {
    if (_accessToken == null) return;

    try {
      final name = await UserService.getUserName(accessToken: _accessToken!);
      _userName = name;

      // ✅ 이름 확인 후 샘플 데이터 삽입
      if (name == 'marimo') {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('last_obd_data');
        await preloadSampleObdDataIfNeeded();

        final distance = parseDistanceSinceDtcCleared();
        if (distance != null) {
          await ObdService.sendTotalDistance(
            carId: '12', // 또는 실제 carId 사용
            totalDistance: distance,
            accessToken: _accessToken!,
          );
          print('📨 샘플 주행거리 전송 완료: $distance km');
        }

        print('🌱 marimo 사용자: 샘플 OBD + 거리 삽입 완료');
      }

      notifyListeners();
    } catch (e) {
      print('사용자 이름 로드 실패: $e');
    }
  }

  // 로그아웃 시 토큰과 사용자 이름 제거
  void logout() {
    _accessToken = null;
    _userName = null;
    notifyListeners();
  }
}
