import 'package:flutter/material.dart';
import 'package:marimo_client/screens/signin/widgets/CarBrandSelector.dart';

class CarBrandScreen extends StatelessWidget {
  const CarBrandScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final manufacturers = [
      {"name": "Add", "logo": null}, // 빈 칸 추가 버튼
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
            const Text(
              "제조사를 선택해주세요.",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            CarBrandSelector(
              manufacturers: manufacturers,
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
