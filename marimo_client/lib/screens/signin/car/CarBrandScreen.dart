import 'package:flutter/material.dart';
import 'package:marimo_client/screens/signin/widgets/car/BrandSelector.dart';
import 'package:marimo_client/screens/signin/widgets/CustomTitleText.dart';

class CarBrandScreen extends StatelessWidget {
  const CarBrandScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final manufacturers = [
      {"name": "Hyundai", "logo": "assets/images/logo/logo_hyundai.png"},
      {"name": "Kia", "logo": "assets/images/logo/logo_kia.png"},
      {"name": "KGM", "logo": "assets/images/logo/logo_kgm.png"},
    ];

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 60),
            CustomTitleText(text: "제조사를 선택해주세요.", highlight: "제조사"),
            const SizedBox(height: 22),
            BrandSelector(
              brands: manufacturers,
              onSelected: (selected) {
                print("선택된 제조사: $selected");
              },
            ),
          ],
        ),
      ),
    );
  }
}
