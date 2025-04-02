import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marimo_client/main.dart';
import 'package:marimo_client/providers/car_provider.dart';
import 'package:marimo_client/providers/member/auth_provider.dart';
import 'package:marimo_client/screens/signin/widgets/sign_in/LoginButton.dart';
import 'package:marimo_client/screens/signin/widgets/sign_in/LoginHero.dart';
import 'package:marimo_client/screens/signin/widgets/sign_in/LoginInput.dart';
import 'package:marimo_client/screens/signin/widgets/sign_in/LoginLinkRow.dart';
import 'package:marimo_client/screens/signin/widgets/sign_in/LoginSlogan.dart';
import 'package:marimo_client/screens/signin/widgets/sign_in/OauthButtons.dart';
import 'package:marimo_client/services/auth/auth_service.dart';
import 'package:marimo_client/utils/toast.dart';
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
      // 1. 로그인 요청 → accessToken 반환
      final token = await AuthService.login(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // 2. 토큰 저장
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final carProvider = Provider.of<CarProvider>(context, listen: false);
      authProvider.setAccessToken(token);

      // 3. 차량 목록 받아오되, 실패해도 무시
      try {
        await carProvider.fetchCarsFromServer(token);
      } catch (e) {
        showToast(
          context,
          '차량 목록 불러오기 실패 (나중에 다시 시도해주세요)',
          icon: Icons.warning,
          type: 'error',
        );
        print('🚨 차량 목록 조회 실패 (무시됨): $e');
      }

      // 4. 라우팅
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const InitialRouter()),
        (Route<dynamic> route) => false,
      );
    } catch (error) {
      // ❌ 로그인 자체 실패
      showToast(context, "로그인 실패: $error", icon: Icons.error, type: 'error');
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
              SizedBox(height: 104.h),
              const LoginSlogan(),
              SizedBox(height: 18.h),
              const LoginHero(), // 로고 & 텍스트
              SizedBox(height: 36.h),
              // 이메일 입력 (LoginInput 위젯에 controller 파라미터 추가)
              LoginInput(hintText: "이메일을 입력해주세요.", controller: emailController),
              SizedBox(height: 30.h),
              // 비밀번호 입력
              LoginInput(
                hintText: "비밀번호를 입력해주세요.",
                isPassword: true,
                controller: passwordController,
              ),
              SizedBox(height: 30.h),
              // 로그인 버튼
              LoginButton(text: "마리모 로그인", onPressed: _login),
              SizedBox(height: 30.h),
              const LoginLinkRow(), // 비밀번호 찾기, 회원가입 링크
              SizedBox(height: 26.h),
              const OauthButtons(), // SNS 계정으로 로그인
            ],
          ),
        ),
      ),
    );
  }
}
