import 'package:flutter/material.dart';
import 'package:marimo_client/screens/signin/widgets/SignUpInput.dart'; // 공통 입력 필드 import
import 'package:marimo_client/screens/signin/widgets/SignUpInputWithButton.dart'; // 버튼 포함 입력 필드 import

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
                          const Text.rich(
                            TextSpan(
                              text: "안녕하세요!\n먼저 ",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF19181D),
                              ),
                              children: [
                                TextSpan(
                                  text: "내 정보",
                                  style: TextStyle(color: Color(0xFF4888FF)),
                                ),
                                TextSpan(
                                  text: "를 등록해주세요",
                                  style: TextStyle(color: Color(0xFF19181D)),
                                ),
                              ],
                            ),
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
                                // TODO: 저장 버튼 기능 추가
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
