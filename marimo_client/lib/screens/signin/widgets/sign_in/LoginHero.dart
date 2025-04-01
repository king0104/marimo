import 'package:flutter/material.dart';

class LoginHero extends StatelessWidget {
  const LoginHero({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          "assets/images/login_logo.png", // 로고 이미지 (경로 수정 필요)
          height: 57,
        ),
        const SizedBox(width: 9),
        RichText(
          textAlign: TextAlign.left,
          text: const TextSpan(
            style: TextStyle(
              fontFamily: "Esamanru",
              fontSize: 15,
              fontWeight: FontWeight.w500,
              height: 1.38,
            ),
            children: [
              // "마이" 중 "마"만 파란색
              TextSpan(text: "마", style: TextStyle(color: Color(0xFF007DFC))),
              TextSpan(text: "이\n", style: TextStyle(color: Color(0xFF000000))),

              // "리틀" 중 "리"만 파란색
              TextSpan(text: "리", style: TextStyle(color: Color(0xFF007DFC))),
              TextSpan(text: "틀\n", style: TextStyle(color: Color(0xFF000000))),

              // "모빌리티" 중 "모"만 파란색
              TextSpan(text: "모", style: TextStyle(color: Color(0xFF007DFC))),
              TextSpan(text: "빌리티", style: TextStyle(color: Color(0xFF000000))),
            ],
          ),
        ),
      ],
    );
  }
}
