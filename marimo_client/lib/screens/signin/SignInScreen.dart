import 'package:flutter/material.dart';
import 'package:marimo_client/providers/member/auth_provider.dart';
import 'package:marimo_client/screens/signin/widgets/sign_in/LoginButton.dart';
import 'package:marimo_client/screens/signin/widgets/sign_in/LoginHero.dart';
import 'package:marimo_client/screens/signin/widgets/sign_in/LoginInput.dart';
import 'package:marimo_client/screens/signin/widgets/sign_in/LoginLinkRow.dart';
import 'package:marimo_client/screens/signin/widgets/sign_in/LoginSlogan.dart';
import 'package:marimo_client/screens/signin/widgets/sign_in/OauthButtons.dart';
import 'package:marimo_client/services/auth/auth_service.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  // TextEditingControllers를 추가하여 입력값을 관리합니다.
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    try {
      final token = await AuthService.login(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      // 로그인 성공 시 AuthProvider에 token 저장
      Provider.of<AuthProvider>(context, listen: false).setAccessToken(token);
      // 로그인 성공 후 메인 화면 등으로 전환하는 로직을 추가할 수 있습니다.
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("로그인 성공!")));
    } catch (error) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

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
              // 이메일 입력 (LoginInput 위젯에 controller 파라미터 추가)
              LoginInput(hintText: "이메일을 입력해주세요.", controller: emailController),
              const SizedBox(height: 30),
              // 비밀번호 입력
              LoginInput(
                hintText: "비밀번호를 입력해주세요.",
                isPassword: true,
                controller: passwordController,
              ),
              const SizedBox(height: 30),
              // 로그인 버튼
              LoginButton(text: "마리모 로그인", onPressed: _login),
              const SizedBox(height: 30),
              const LoginLinkRow(), // 비밀번호 찾기, 회원가입 링크
              const SizedBox(height: 30),
              const OauthButtons(), // SNS 계정으로 로그인
            ],
          ),
        ),
      ),
    );
  }
}
