import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:marimo_client/mocks/obd_sample.dart';
import 'package:marimo_client/services/user/user_service.dart';
import 'package:marimo_client/services/car/obd_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

final secureStorage = FlutterSecureStorage();

class AuthProvider extends ChangeNotifier {
  String? _accessToken;
  String? _userName;

  String? get accessToken => _accessToken;
  String? get userName => _userName;

  bool get isLoggedIn => _accessToken != null && _accessToken!.isNotEmpty;

  // 앱 시작 시 호출 - 저장된 토큰 자동 불러오기
  Future<void> loadTokenFromStorage() async {
    final token = await secureStorage.read(key: 'accessToken');
    if (token != null && token.isNotEmpty) {
      _accessToken = token;
      await _loadUserName();
      notifyListeners();
    }
  }

  void setAccessToken(String token) async {
    _accessToken = token;
    await secureStorage.write(key: 'accessToken', value: token);
    await _loadUserName();
    notifyListeners();
  }

  Future<void> _loadUserName() async {
    if (_accessToken == null) return;

    try {
      final name = await UserService.getUserName(accessToken: _accessToken!);
      _userName = name;

      if (name == 'marimo') {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('last_obd_data');
        await preloadSampleObdDataIfNeeded();

        final distance = parseDistanceSinceDtcCleared();
        if (distance != null) {
          await ObdService.sendTotalDistance(
            carId: '12',
            totalDistance: distance,
            accessToken: _accessToken!,
          );
          print('📨 샘플 주행거리 전송 완료: $distance km');
        }

        print('🌱 marimo 사용자: 샘플 OBD + 거리 삽입 완료');
      }
    } catch (e) {
      print('사용자 이름 로드 실패: $e');
    }
  }

  void logout() async {
    _accessToken = null;
    _userName = null;
    await secureStorage.delete(key: 'accessToken');
    notifyListeners();
  }
}
