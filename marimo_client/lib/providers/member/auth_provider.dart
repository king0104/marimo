import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  String? _accessToken;

  String? get accessToken => _accessToken;

  bool get isLoggedIn => _accessToken != null && _accessToken!.isNotEmpty;

  // 로그인 성공 시 accessToken 설정
  void setAccessToken(String token) {
    _accessToken = token;
    notifyListeners();
  }

  // 로그아웃 시 토큰 제거
  void logout() {
    _accessToken = null;
    notifyListeners();
  }
}
