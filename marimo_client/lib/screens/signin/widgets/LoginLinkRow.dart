import 'package:flutter/material.dart';

class LoginLinkRow extends StatelessWidget {
  final VoidCallback? onFindPassword;
  final VoidCallback? onSignUp;

  const LoginLinkRow({super.key, this.onFindPassword, this.onSignUp});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: onFindPassword,
          child: const Text(
            "비밀번호 찾기",
            style: TextStyle(
              color: Color(0xFF000000),
              fontSize: 14,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        TextButton(
          onPressed: onSignUp,
          child: const Text(
            "회원가입",
            style: TextStyle(
              color: Color(0xFF000000),
              fontSize: 14,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ],
    );
  }
}
