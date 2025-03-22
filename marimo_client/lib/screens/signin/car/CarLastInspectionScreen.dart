import 'package:flutter/material.dart';
import 'package:marimo_client/screens/signin/widgets/car/CarInput.dart';
import 'package:marimo_client/screens/signin/widgets/CustomTitleText.dart';

class CarLastInspectionScreen extends StatefulWidget {
  const CarLastInspectionScreen({super.key});

  @override
  _CarLastInspectionScreenState createState() =>
      _CarLastInspectionScreenState();
}

class _CarLastInspectionScreenState extends State<CarLastInspectionScreen> {
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
            CustomTitleText(
              text: "마지막 차량 점검일을 입력해주세요.",
              highlight: "마지막 차량 점검일",
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
