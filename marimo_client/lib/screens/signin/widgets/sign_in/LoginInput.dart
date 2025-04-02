import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marimo_client/theme.dart';

class LoginInput extends StatelessWidget {
  final String hintText;
  final bool isPassword;
  final TextEditingController? controller;

  const LoginInput({
    super.key,
    required this.hintText,
    this.isPassword = false,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.h, // ✅ 높이 고정
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        style: TextStyle(fontSize: 16.sp),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: lightgrayColor, fontSize: 16.sp),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: lightgrayColor, width: 1.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: lightgrayColor, width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: lightgrayColor, width: 1.0),
          ),
          filled: true,
          fillColor: white,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 12.h, // 내부 여백도 적절히 조절
          ),
        ),
      ),
    );
  }
}
