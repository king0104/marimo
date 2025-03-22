import 'package:flutter/material.dart';

class LoginSlogan extends StatelessWidget {
  final String text;
  final Color textColor;
  final double fontSize;

  const LoginSlogan({
    super.key,
    this.text = "안전하고 건강한 드라이빙!", // 기본값 설정
    this.textColor = const Color(0xFF7E7E7E), // 연한 회색 (#9E9E9E)
    this.fontSize = 15, // 기본 글자 크기
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: textColor,
          fontSize: fontSize,
          fontWeight: FontWeight.w300,
          fontFamily: "Esamanru",
        ),
      ),
    );
  }
}
