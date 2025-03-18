import 'package:flutter/material.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 배경색 설정
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 로고 & 텍스트
              Column(
                children: [
                  Image.asset(
                    "assets/images/logo-splash.png", // 로고 이미지 (경로 수정 필요)
                    height: 60,
                  ),
                  const SizedBox(height: 10),
                  RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: "마이\n",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: "리틀\n",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: "모빌리티",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // 아이디 입력 필드
              TextField(
                decoration: InputDecoration(
                  hintText: "아이디를 입력해주세요.",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                ),
              ),

              const SizedBox(height: 15),

              // 비밀번호 입력 필드
              TextField(
                obscureText: true, // 비밀번호 가리기
                decoration: InputDecoration(
                  hintText: "비밀번호를 입력해주세요.",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                ),
              ),

              const SizedBox(height: 20),

              // 로그인 버튼
              ElevatedButton(
                onPressed: () {
                  // 로그인 버튼 클릭 시 동작 추가
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // 버튼 색상
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text(
                  "마리모 로그인",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // 비밀번호 찾기 & 회원가입
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      // 비밀번호 찾기 동작 추가
                    },
                    child: const Text(
                      "비밀번호 찾기",
                      style: TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // 회원가입 동작 추가
                    },
                    child: const Text(
                      "회원가입",
                      style: TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // SNS 로그인 텍스트
              const Text(
                "SNS 계정으로 로그인",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54, fontSize: 12),
              ),

              const SizedBox(height: 10),

              // SNS 로그인 버튼 (Google, Kakao)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      // 구글 로그인 동작 추가
                    },
                    icon: Image.asset(
                      "assets/google_icon.png",
                      height: 40,
                    ), // 구글 아이콘 (경로 수정 필요)
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    onPressed: () {
                      // 카카오 로그인 동작 추가
                    },
                    icon: Image.asset(
                      "assets/kakao_icon.png",
                      height: 40,
                    ), // 카카오 아이콘 (경로 수정 필요)
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
