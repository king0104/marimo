import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:marimo_client/screens/signin/widgets/car/CarInput.dart';
import 'package:marimo_client/screens/signin/widgets/CustomTitleText.dart';
import 'package:marimo_client/providers/car_registration_provider.dart';

class CarVinScreen extends StatefulWidget {
  const CarVinScreen({super.key});

  @override
  _CarVinScreenState createState() => _CarVinScreenState();
}

class _CarVinScreenState extends State<CarVinScreen> {
  final TextEditingController vinController = TextEditingController();
  final FocusNode vinFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    final provider = Provider.of<CarRegistrationProvider>(
      context,
      listen: false,
    );
    vinController.text = provider.vehicleIdentificationNumber ?? '';
    vinFocusNode.addListener(() {
      if (!vinFocusNode.hasFocus) {
        provider.setVin(vinController.text);
      }
    });
  }

  @override
  void dispose() {
    vinFocusNode.dispose();
    vinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            CustomTitleText(text: "차대 번호를 입력해주세요.", highlight: "차대 번호"),
            const SizedBox(height: 20),
            CarInput(
              controller: vinController,
              focusNode: vinFocusNode, // ✅ 포커스 감지용
              hintText: "예: KMHEC41BPFA123456",
              labelText: "차대 번호",
            ),
          ],
        ),
      ),
    );
  }
}
