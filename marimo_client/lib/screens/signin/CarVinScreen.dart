import 'package:flutter/material.dart';
import 'package:marimo_client/screens/signin/widgets/CarInput.dart';
import 'package:marimo_client/screens/signin/widgets/CustomTitleText.dart';

class CarVinScreen extends StatefulWidget {
  const CarVinScreen({super.key});

  @override
  _CarVinScreenState createState() => _CarVinScreenState();
}

class _CarVinScreenState extends State<CarVinScreen> {
  final TextEditingController carNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 60),
            CustomTitleText(text: "차대 번호를 입력해주세요.", highlight: "차대 번호"),
            SizedBox(height: 20),
            CarInput(controller: carNumberController),
          ],
        ),
      ),
    );
  }
}
