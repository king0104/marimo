import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:marimo_client/providers/car_registration_provider.dart';
import 'package:marimo_client/screens/signin/widgets/CustomTitleText.dart';
import 'package:marimo_client/screens/signin/widgets/car/CarModelSelector.dart';

class CarModelScreen extends StatelessWidget {
  const CarModelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CarRegistrationProvider>(context);
    final selectedModel = provider.modelName ?? "";

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            CustomTitleText(text: "모델을 선택해주세요.", highlight: "모델"),
            const SizedBox(height: 20),
            CarModelSelector(
              models: ["팰리세이드", "아반떼", "쏘나타 디 엣지", "그랜저", "캐스퍼", "베뉴"],
              initiallySelectedModel: selectedModel,
              onSelected: (model) {
                provider.setModelName(model);
              },
            ),
          ],
        ),
      ),
    );
  }
}
