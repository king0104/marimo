import 'package:flutter/material.dart';
import 'package:marimo_client/services/user/user_service.dart';

class AuthProvider extends ChangeNotifier {
  String? _accessToken;
  String? _userName;

  String? get accessToken => _accessToken;
  String? get userName => _userName;

  bool get isLoggedIn => _accessToken != null && _accessToken!.isNotEmpty;

  // 로그인 성공 시 accessToken 설정 및 사용자 이름 로드
  void setAccessToken(String token) {
    _accessToken = token;
    _loadUserName();  // 토큰 설정 시 자동으로 사용자 이름 로드
    notifyListeners();
  }

  // 사용자 이름 로드
  Future<void> _loadUserName() async {
    if (_accessToken == null) return;

    try {
      final name = await UserService.getUserName(
        accessToken: _accessToken!,
      );
      _userName = name;
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

