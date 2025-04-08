import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marimo_client/screens/signin/widgets/car/BrandSelector.dart';
import 'package:marimo_client/screens/signin/widgets/CustomTitleText.dart';
import 'package:provider/provider.dart';
import 'package:marimo_client/providers/car_registration_provider.dart';

class CarBrandScreen extends StatelessWidget {
  const CarBrandScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ 화면이 그려진 직후 키보드 내리기
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).unfocus();
    });

    final manufacturers = [
      {"name": "현대", "logo": "assets/images/logo/logo_hyundai.png"},
      {"name": "기아", "logo": "assets/images/logo/logo_kia.png"},
      {"name": "토요타", "logo": "assets/images/logo/logo_toyota.png"},
      {"name": "KGM", "logo": "assets/images/logo/logo_kgm.png"},
    ];

    final selectedBrand = Provider.of<CarRegistrationProvider>(context).brand;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            CustomTitleText(text: "제조사를 선택해주세요.", highlight: "제조사"),
            const SizedBox(height: 22),
            BrandSelector(
              brands: manufacturers,
              selectedBrand: selectedBrand,
              onSelected: (selected) {
                Provider.of<CarRegistrationProvider>(
                  context,
                  listen: false,
                ).setBrand(selected);
              },
            ),
          ],
        ),
      ),
    );
  }
}
