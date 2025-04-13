import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'package:marimo_client/screens/signin/widgets/car/CarInput.dart';
import 'package:marimo_client/screens/signin/widgets/CustomTitleText.dart';
import 'package:marimo_client/providers/car_registration_provider.dart';

class CarNicknameScreen extends StatefulWidget {
  const CarNicknameScreen({super.key});

  @override
  State<CarNicknameScreen> createState() => _CarNicknameScreenState();
}

class _CarNicknameScreenState extends State<CarNicknameScreen> {
  final TextEditingController nicknameController = TextEditingController();
  final FocusNode nicknameFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    final provider = Provider.of<CarRegistrationProvider>(
      context,
      listen: false,
    );
    nicknameController.text = provider.nickname ?? '';

    nicknameFocusNode.addListener(() {
      if (!nicknameFocusNode.hasFocus) {
        provider.setNickname(nicknameController.text);
      }
    });
  }

  @override
  void dispose() {
    nicknameController.dispose();
    nicknameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            const CustomTitleText(
              text: "마지막으로 내 차에 이름을 지어 주세요.",
              highlight: "내 차에 이름을",
            ),
            const SizedBox(height: 20),
            CarInput(
              controller: nicknameController,
              focusNode: nicknameFocusNode,
              hintText: "예: 우리 마리모카",
              labelText: "닉네임",
            ),
          ],
        ),
      ),
    );
  }
}
