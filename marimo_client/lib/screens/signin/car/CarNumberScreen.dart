import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:marimo_client/screens/signin/widgets/car/CarInput.dart';
import 'package:marimo_client/screens/signin/widgets/CustomTitleText.dart';
import 'package:marimo_client/providers/car_registration_provider.dart';

class CarNumberScreen extends StatefulWidget {
  const CarNumberScreen({super.key});

  @override
  _CarNumberScreenState createState() => _CarNumberScreenState();
}

class _CarNumberScreenState extends State<CarNumberScreen> {
  final TextEditingController carNumberController = TextEditingController();
  final FocusNode carNumberFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    final provider = Provider.of<CarRegistrationProvider>(
      context,
      listen: false,
    );
    carNumberController.text = provider.plateNumber ?? '';

    carNumberFocusNode.addListener(() {
      // 포커스가 사라졌을 때 자동 저장
      if (!carNumberFocusNode.hasFocus) {
        provider.setPlateNumber(carNumberController.text);
      }
    });
  }

  @override
  void dispose() {
    carNumberController.dispose();
    carNumberFocusNode.dispose(); // ⚠️ 꼭 dispose 해줘야 함!
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            CustomTitleText(text: "차량 번호를 입력해주세요.", highlight: "차량 번호"),
            const SizedBox(height: 20),
            CarInput(
              controller: carNumberController,
              focusNode: carNumberFocusNode, // 👈 focusNode 주입
              hintText: "예: 123가1234",
            ),
          ],
        ),
      ),
    );
  }
}
