import 'package:flutter/material.dart';
import 'package:marimo_client/screens/signin/car/RegisterCarScreen.dart';
import 'package:marimo_client/screens/signin/widgets/sign_up/SignUpInput.dart'; // 공통 입력 필드 import
import 'package:marimo_client/screens/signin/widgets/sign_up/SignUpInputWithButton.dart';
import 'package:marimo_client/screens/signin/widgets/CustomTitleText.dart'; // 버튼 포함 입력 필드 import

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController authCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height, // 화면 전체 높이만큼 설정
            ),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 32),
                          CustomTitleText(
                            text: "안녕하세요!\n먼저 내 정보를 등록해주세요",
                            highlight: "내 정보",
                          ),
                          const SizedBox(height: 32),
                          SignUpInput(
                            label: "이름",
                            hint: "홍길동",
                            controller: nameController,
                          ),
                          const SizedBox(height: 12),
                          SignUpInput(
                            label: "비밀번호",
                            hint: "영문자, 숫자, 특수문자 포함, 8~20자 사이",
                            controller: passwordController,
                            isPassword: true,
                          ),
                          const SizedBox(height: 12),
                          SignUpInput(
                            label: "비밀번호 확인",
                            hint: "영문자, 숫자, 특수문자 포함, 8~20자 사이",
                            controller: confirmPasswordController,
                            isPassword: true,
                          ),
                          const SizedBox(height: 12),
                          SignUpInputWithButton(
                            label: "이메일",
                            hint: "example@abc.com",
                            buttonText: "인증",
                            controller: emailController,
                            onPressed: () {
                              // TODO: 이메일 인증 버튼 기능 추가
                            },
                          ),
                          const SizedBox(height: 12),
                          SignUpInputWithButton(
                            label: "인증 번호 입력",
                            hint: "",
                            buttonText: "확인",
                            controller: authCodeController,
                            onPressed: () {
                              // TODO: 인증번호 확인 버튼 기능 추가
                            },
                          ),
                          const SizedBox(height: 25),
                          const Text(
                            "Hint",
                            style: TextStyle(
                              color: Color(0xFF5E5E5E),
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              height: 1.35,
                            ),
                          ),
                          const SizedBox(height: 38),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => const RegisterCarScreen(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF4888FF),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                "저장",
                                style: TextStyle(
                                  color: Color(0xFFFFFFFF),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
