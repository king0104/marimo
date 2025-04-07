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

class _SignInScreenState extends State<SignInScreen>
    with TickerProviderStateMixin {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  late final List<AnimationController> _controllers;
  late final List<Animation<double>> _fadeAnimations;
  late final List<Animation<Offset>> _slideAnimations;
  @override
  void initState() {
    super.initState();

    _controllers = List.generate(6, (index) {
      return AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
      );
    });

    _fadeAnimations =
        _controllers.map((c) {
          return Tween<double>(
            begin: 0,
            end: 1,
          ).animate(CurvedAnimation(parent: c, curve: Curves.easeIn));
        }).toList();

    _slideAnimations =
        _controllers.map((c) {
          return Tween<Offset>(
            begin: const Offset(-0.3, 0), // 왼쪽에서 시작
            end: Offset.zero,
          ).animate(
            CurvedAnimation(parent: c, curve: Curves.easeOutBack), // 바운스 느낌
          );
        }).toList();

    _playAnimations();
  }

  Future<void> _playAnimations() async {
    for (int i = 0; i < _controllers.length; i++) {
      await Future.delayed(const Duration(milliseconds: 100));
      _controllers[i].forward();
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  Widget animated(int index, Widget child) {
    return FadeTransition(
      opacity: _fadeAnimations[index],
      child: SlideTransition(position: _slideAnimations[index], child: child),
    );
  }

  Future<void> _login() async {
    try {
      final token = await AuthService.login(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final carProvider = Provider.of<CarProvider>(context, listen: false);
      authProvider.setAccessToken(token);

      // 토스트 먼저 표시
      showToast(
        context,
        "마리모에 오신 것을 환영합니다!",
        icon: Icons.check_circle_outline,
        type: 'success',
        position: 'top-down',
      );

      // 토스트가 보이는 동안 미리 데이터를 로딩
      await Future.wait([
        Future.delayed(const Duration(seconds: 2)), // 토스트 지속 시간
        carProvider.fetchCarsFromServer(token).catchError((e) {
          showToast(
            context,
            '차량 목록 불러오기 실패 (나중에 다시 시도해주세요)',
            icon: Icons.warning,
            type: 'error',
            position: 'top-down',
          );
          print('🚨 차량 목록 조회 실패 (무시됨): $e');
        }),
      ]);

      // 이후 화면 이동
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const InitialRouter()),
        (Route<dynamic> route) => false,
      );
    } catch (error) {
      print("로그인 오류: $error");
      showToast(context, "로그인을 다시 해주세요.", icon: Icons.error, type: 'error', position: 'top-down',);
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
              animated(0, const LoginSlogan()),
              SizedBox(height: 18.h),
              animated(1, const LoginHero()),
              SizedBox(height: 36.h),
              animated(
                2,
                LoginInput(
                  hintText: "이메일을 입력해주세요.",
                  controller: emailController,
                ),
              ),
              SizedBox(height: 30.h),
              animated(
                3,
                LoginInput(
                  hintText: "비밀번호를 입력해주세요.",
                  isPassword: true,
                  controller: passwordController,
                ),
              ),
              SizedBox(height: 30.h),
              animated(4, LoginButton(text: "마리모 로그인", onPressed: _login)),
              SizedBox(height: 30.h),
              animated(
                5,
                Column(
                  children: const [
                    LoginLinkRow(),
                    SizedBox(height: 26),
                    OauthButtons(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
