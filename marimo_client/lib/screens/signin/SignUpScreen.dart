import 'dart:async';
import 'package:flutter/material.dart';
import 'package:marimo_client/providers/member/signup_provider.dart';
import 'package:marimo_client/screens/signin/SignInScreen.dart';
import 'package:marimo_client/screens/signin/car/RegisterCarScreen.dart';
import 'package:marimo_client/screens/signin/widgets/sign_up/SignUpInput.dart';
import 'package:marimo_client/screens/signin/widgets/sign_up/SignUpInputWithButton.dart';
import 'package:marimo_client/screens/signin/widgets/CustomTitleText.dart';
import 'package:provider/provider.dart';
import 'package:marimo_client/utils/toast.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // SignUpProvider를 생성하여 단계별 폼을 관리합니다.
    return ChangeNotifierProvider<SignUpProvider>(
      create: (_) => SignUpProvider(),
      child: const SignUpScreenBody(),
    );
  }
}

class SignUpScreenBody extends StatefulWidget {
  const SignUpScreenBody({Key? key}) : super(key: key);

  @override
  _SignUpScreenBodyState createState() => _SignUpScreenBodyState();
}

class _SignUpScreenBodyState extends State<SignUpScreenBody> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController authCodeController = TextEditingController();

  // 단계: 0=이름, 1=비밀번호, 2=비밀번호 확인, 3=이메일, 4=인증번호, 5=회원가입 버튼
  int currentStep = 0;
  Timer? _debounce;

  // 오류 메시지 변수
  String? nameError;
  String? passwordError;
  String? confirmPasswordError;
  String? emailError;
  String? authCodeError;

  @override
  void dispose() {
    nameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    emailController.dispose();
    authCodeController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  // 이름 유효성 검사: 2~10자, 자음/모음만 입력 불가
  void _onNameChanged(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      setState(() => nameError = "이름을 입력해주세요.");
      return;
    } else if (trimmed.length < 2 || trimmed.length > 10) {
      setState(() => nameError = "2~10자 사이여야 합니다.");
      return;
    } else if (RegExp(r'^[ㄱ-ㅎㅏ-ㅣ]+$').hasMatch(trimmed)) {
      setState(() => nameError = "자음 또는 모음만 단독으로 입력할 수 없습니다.");
      return;
    } else {
      setState(() {
        nameError = null;
        if (currentStep == 0) currentStep = 1;
      });
    }
  }

  // 비밀번호 유효성 검사: 8~20자, 영문자, 숫자, 특수문자 포함 (@$!%*?&#)
  void _onPasswordChanged(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      setState(() => passwordError = "비밀번호를 입력해주세요.");
      return;
    } else if (!RegExp(
      r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&#])[A-Za-z\d@$!%*?&#]{8,20}$',
    ).hasMatch(trimmed)) {
      setState(
        () =>
            passwordError =
                "비밀번호는 영문자, 숫자, 특수문자(@\$!%*?&#)를 포함하여 8~20자 사이여야 합니다.",
      );
      return;
    } else {
      setState(() {
        passwordError = null;
        if (currentStep == 1) currentStep = 2;
      });
    }
  }

  // 비밀번호 확인 검사: 동일한 규칙 및 비밀번호와 일치해야 함
  void _onConfirmPasswordChanged(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      setState(() => confirmPasswordError = "비밀번호 확인을 해주세요.");
      return;
    } else if (!RegExp(
      r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&#])[A-Za-z\d@$!%*?&#]{8,20}$',
    ).hasMatch(trimmed)) {
      setState(
        () =>
            confirmPasswordError =
                "비밀번호는 영문자, 숫자, 특수문자(@\$!%*?&#)를 포함하여 8~20자 사이여야 합니다.",
      );
      return;
    } else if (trimmed != passwordController.text.trim()) {
      setState(() => confirmPasswordError = "비밀번호가 일치하지 않습니다.");
      return;
    } else {
      setState(() {
        confirmPasswordError = null;
        if (currentStep == 2) currentStep = 3;
      });
    }
  }

  // 이메일 유효성 검사: 빈값 및 형식 검사
  void _validateEmail() {
    final trimmed = emailController.text.trim();
    if (trimmed.isEmpty) {
      setState(() => emailError = "이메일를 입력해주세요.");
      return;
    }
    final emailPattern = r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$';
    if (!RegExp(emailPattern).hasMatch(trimmed)) {
      setState(() => emailError = "올바른 이메일 형식이 아닙니다.");
      return;
    }
    setState(() {
      emailError = null;
    });
  }

  // 인증번호 검사: 8자리여야 함
  void _onAuthCodeChanged(String value, SignUpProvider signUpProvider) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      setState(() => authCodeError = "인증 번호를 입력해주세요.");
      return;
    } else if (trimmed.length != 8) {
      setState(() => authCodeError = "인증 번호는 8자리여야 합니다.");
      return;
    } else {
      setState(() => authCodeError = null);
      if (_debounce?.isActive ?? false) _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 300), () async {
        await signUpProvider.verifyEmail(emailController.text.trim(), trimmed);
        if (signUpProvider.isEmailVerified) {
          showToast(context, "이메일 인증 완료", icon: Icons.check, type: 'success');
          setState(() {
            currentStep = 5;
          });
        } else {
          showToast(
            context,
            signUpProvider.errorMessage.isNotEmpty
                ? signUpProvider.errorMessage
                : "이메일 인증 실패",
            icon: Icons.error,
            type: 'error',
          );
        }
      });
    }
  }

  /// 단계별 위젯을 AnimatedSwitcher로 구성하여 반환합니다.
  Widget _buildStepContent(SignUpProvider signUpProvider) {
    List<Widget> steps = [];

    // 0. 이름 입력
    if (currentStep >= 0) {
      steps.add(
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Column(
            key: const ValueKey("nameField"),
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SignUpInput(
                label: "이름",
                hint: "홍길동",
                controller: nameController,
                onChanged: _onNameChanged,
              ),
              if (nameError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    nameError!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      );
    }

    // 1. 비밀번호 입력
    if (currentStep >= 1) {
      steps.add(const SizedBox(height: 12));
      steps.add(
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Column(
            key: const ValueKey("passwordField"),
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SignUpInput(
                label: "비밀번호",
                hint: "영문자, 숫자, 특수문자 포함, 8~20자 사이",
                controller: passwordController,
                isPassword: true,
                onChanged: _onPasswordChanged,
              ),
              if (passwordError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    passwordError!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      );
    }

    // 2. 비밀번호 확인 입력
    if (currentStep >= 2) {
      steps.add(const SizedBox(height: 12));
      steps.add(
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Column(
            key: const ValueKey("confirmPasswordField"),
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SignUpInput(
                label: "비밀번호 확인",
                hint: "영문자, 숫자, 특수문자 포함, 8~20자 사이",
                controller: confirmPasswordController,
                isPassword: true,
                onChanged: _onConfirmPasswordChanged,
              ),
              if (confirmPasswordError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    confirmPasswordError!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      );
    }

    // 3. 이메일 입력 + 인증 버튼
    if (currentStep >= 3) {
      steps.add(const SizedBox(height: 12));
      steps.add(
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Column(
            key: const ValueKey("emailField"),
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SignUpInputWithButton(
                label: "이메일",
                hint: "example@abc.com",
                buttonText: "인증",
                controller: emailController,
                onPressed: () async {
                  _validateEmail();
                  if (emailError != null) {
                    showToast(
                      context,
                      emailError!,
                      icon: Icons.error,
                      type: 'error',
                    );
                    return;
                  }
                  await signUpProvider.sendEmailVerification(
                    emailController.text.trim(),
                  );
                  if (signUpProvider.errorMessage.isEmpty) {
                    showToast(
                      context,
                      "인증코드 전송 완료",
                      icon: Icons.check,
                      type: 'success',
                    );
                    setState(() {
                      currentStep = 4;
                    });
                  } else {
                    showToast(
                      context,
                      signUpProvider.errorMessage,
                      icon: Icons.error,
                      type: 'error',
                    );
                  }
                },
              ),
              if (emailError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    emailError!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      );
    }

    // 4. 이메일 인증번호 입력
    if (currentStep >= 4) {
      steps.add(const SizedBox(height: 12));
      steps.add(
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Column(
            key: const ValueKey("authCodeField"),
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SignUpInput(
                label: "인증 번호 입력",
                hint: "",
                controller: authCodeController,
                onChanged: (value) => _onAuthCodeChanged(value, signUpProvider),
              ),
              if (authCodeError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    authCodeError!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      );
    }

    // 5. 회원가입 버튼
    if (currentStep >= 5) {
      steps.add(const SizedBox(height: 25));
      steps.add(
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: SizedBox(
            key: const ValueKey("signUpButton"),
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () async {
                if (passwordController.text.trim() !=
                    confirmPasswordController.text.trim()) {
                  showToast(
                    context,
                    "비밀번호가 일치하지 않습니다.",
                    icon: Icons.error,
                    type: 'error',
                  );
                  return;
                }
                bool success = await signUpProvider.signUp(
                  email: emailController.text.trim(),
                  name: nameController.text.trim(),
                  password: passwordController.text.trim(),
                );
                if (success) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const SignInScreen()),
                  );
                } else {
                  showToast(
                    context,
                    signUpProvider.errorMessage,
                    icon: Icons.error,
                    type: 'error',
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4888FF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "마리모 회원가입",
                style: TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: steps,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<SignUpProvider>(
        builder: (context, signUpProvider, child) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 32),
                      CustomTitleText(
                        text: "안녕하세요!\n먼저 내 정보를 등록해주세요",
                        highlight: "내 정보",
                      ),
                      const SizedBox(height: 32),
                      Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: _buildStepContent(signUpProvider),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
