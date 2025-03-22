import 'package:flutter/material.dart';

class LoginInput extends StatelessWidget {
  final String hintText;
  final bool isPassword;
  final TextEditingController? controller;

  const LoginInput({
    super.key,
    required this.hintText,
    this.isPassword = false, // 기본 값: 이메일
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isPassword, // 비밀번호 필드 여부
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0xFFBEBFc0), fontSize: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFBEBFC0), width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Color(0xFFBEBFC0), // ✅ 테두리 색상을 명확하게 설정
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Color(0xFFBEBFC0), // ✅ 포커스 상태에서도 같은 색 유지
            width: 1.0,
          ),
        ),
        filled: true,
        fillColor: Color(0xFFFFFFFF),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }
}
