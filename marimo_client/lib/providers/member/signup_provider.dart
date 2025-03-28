import 'package:flutter/material.dart';
import 'package:marimo_client/models/member/email_verification_result_model.dart';
import 'package:marimo_client/services/auth/auth_service.dart';

class SignUpProvider extends ChangeNotifier {
  bool isEmailSent = false;
  bool isEmailVerified = false;
  bool isLoading = false;
  String errorMessage = '';

  /// 이메일 인증코드 전송
  Future<void> sendEmailVerification(String email) async {
    isLoading = true;
    notifyListeners();

    try {
      await AuthService.sendEmailVerificationCode(email: email);
      isEmailSent = true;
    } catch (error) {
      errorMessage = error.toString();
      isEmailSent = false;
    }

    isLoading = false;
    notifyListeners();
  }

  /// 이메일 인증코드 검증
  Future<void> verifyEmail(String email, String authCode) async {
    isLoading = true;
    notifyListeners();

    try {
      EmailVerificationResult result = await AuthService.verifyEmailCode(
        email: email,
        authCode: authCode,
      );
      isEmailVerified = result.valid;
    } catch (error) {
      errorMessage = error.toString();
      isEmailVerified = false;
    }

    isLoading = false;
    notifyListeners();
  }

  /// 회원가입 요청
  Future<bool> signUp({
    required String email,
    required String name,
    required String password,
  }) async {
    isLoading = true;
    notifyListeners();

    bool success = false;
    try {
      success = await AuthService.signUp(
        email: email,
        name: name,
        password: password,
      );
    } catch (error) {
      errorMessage = error.toString();
    }

    isLoading = false;
    notifyListeners();
    return success;
  }

  /// 상태 초기화 (필요시 호출)
  void reset() {
    isEmailSent = false;
    isEmailVerified = false;
    errorMessage = '';
    notifyListeners();
  }
}
