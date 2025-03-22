import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color textColor;

  const LoginButton({
    super.key,
    required this.text,
    this.onPressed,
    this.backgroundColor = const Color(0xFF4888FF), // 기본 버튼 색상 (파란색)
    this.textColor = const Color(0xFFFFFFFF), // 기본 텍스트 색상 (흰색)
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(vertical: 18),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
    );
  }
}
