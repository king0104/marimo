import 'package:flutter/material.dart';
import 'package:marimo_client/screens/signin/widgets/CarInput.dart';
import 'package:marimo_client/screens/signin/widgets/CustomTitleText.dart';

class CarModelScreen extends StatefulWidget {
  const CarModelScreen({super.key});

  @override
  _CarModelScreenState createState() => _CarModelScreenState();
}

class _CarModelScreenState extends State<CarModelScreen> {
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
            CustomTitleText(text: "모델을 선택해주세요.", highlight: "모델"),
            SizedBox(height: 20),
            CarInput(controller: carNumberController),
          ],
        ),
      ),
    );
  }
}
