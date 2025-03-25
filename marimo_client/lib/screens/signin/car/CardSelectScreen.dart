import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marimo_client/screens/signin/widgets/car/CarInput.dart';
import 'package:marimo_client/screens/signin/widgets/CustomTitleText.dart';
import 'package:marimo_client/screens/signin/widgets/car/CardSelector.dart';

class CardSelectScreen extends StatefulWidget {
  const CardSelectScreen({super.key});

  @override
  _CardSelectScreenState createState() => _CardSelectScreenState();
}

class _CardSelectScreenState extends State<CardSelectScreen> {
  final TextEditingController carNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40),
            CustomTitleText(text: "주유 시 사용하는 카드를 골라주세요.", highlight: "카드"),
            SizedBox(height: 50),
            CardSelector(),
          ],
        ),
      ),
    );
  }
}
