import 'package:flutter/material.dart';
import 'package:marimo_client/screens/signin/widgets/LoginButton.dart';
import 'package:marimo_client/screens/signin/widgets/LoginHero.dart';
import 'package:marimo_client/screens/signin/widgets/LoginInput.dart';
import 'package:marimo_client/screens/signin/widgets/LoginLinkRow.dart';
import 'package:marimo_client/screens/signin/widgets/LoginSlogan.dart';
import 'package:marimo_client/screens/signin/widgets/OauthButtons.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 배경색 설정
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const LoginSlogan(),
              const SizedBox(height: 18),
              const LoginHero(), // 로고 & 텍스트
              const SizedBox(height: 38),
              const LoginInput(hintText: "아이디를 입력해주세요."), // 아이디 입력
              const SizedBox(height: 30),
              const LoginInput(
                hintText: "비밀번호를 입력해주세요.",
                isPassword: true,
              ), // 비밀번호 입력
              const SizedBox(height: 30),
              LoginButton(
                text: "마리모 로그인",
                onPressed: () => print("로그인 버튼 눌림"),
              ), // 로그인 버튼
              const SizedBox(height: 30),
              const LoginLinkRow(), // 비밀번호 찾기, 회원가입
              const SizedBox(height: 30),
              const OauthButtons(), // SNS 계정으로로그인
            ],
          ),
        ),
      ),
    );
  }
}
