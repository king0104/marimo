import 'package:flutter/material.dart';
import 'package:marimo_client/theme.dart';

class OauthButtons extends StatelessWidget {
  final VoidCallback? onGoogleLogin;
  final VoidCallback? onKakaoLogin;

  const OauthButtons({super.key, this.onGoogleLogin, this.onKakaoLogin});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "SNS 계정으로 로그인",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: iconColor, // 피그마에는 #757575인데,
            fontWeight: FontWeight.w300,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: onGoogleLogin,
              icon: Image.asset(
                "assets/images/icons/oauth_google.png",
                height: 56,
              ),
            ),
            const SizedBox(width: 28),
            IconButton(
              onPressed: onKakaoLogin,
              icon: Image.asset(
                "assets/images/icons/oauth_kakao.png",
                height: 56,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
