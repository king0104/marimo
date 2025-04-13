import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marimo_client/screens/signin/widgets/car/BrandSelector.dart';
import 'package:marimo_client/screens/signin/widgets/CustomTitleText.dart';
import 'package:marimo_client/theme.dart';

class CardBrandScreen extends StatefulWidget {
  const CardBrandScreen({super.key});

  @override
  _CardBrandScreenState createState() => _CardBrandScreenState();
}

class _CardBrandScreenState extends State<CardBrandScreen> {
  final TextEditingController carNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cardCompanies = [
      {"name": "신한 카드", "logo": "assets/images/logo/logo_shinhan.png"},
      {"name": "삼성 카드", "logo": "assets/images/logo/logo_samsung.png"},
      {"name": "현대 카드", "logo": "assets/images/logo/logo_hyundai_card.png"},
      {"name": "KB 카드", "logo": "assets/images/logo/logo_kb.png"},
      {"name": "우리 카드", "logo": "assets/images/logo/logo_woori.png"},
      {"name": "롯데 카드", "logo": "assets/images/logo/logo_lotte.png"},
      {"name": "하나 카드", "logo": "assets/images/logo/logo_hana.png"},
      {"name": "NH농협카드", "logo": "assets/images/logo/logo_nh.png"},
      {"name": "바로 카드", "logo": "assets/images/logo/logo_baro.png"},
      {"name": "IBK기업은행", "logo": "assets/images/logo/logo_ibk.png"},
      {"name": "카카오뱅크", "logo": "assets/images/logo/logo_kakao_bank.png"},
      {"name": "네이버페이", "logo": "assets/images/logo/logo_naver_pay.png"},
    ];

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40),
            CustomTitleText(
              text: "주유 시 사용하는 카드의\n카드사의 정보를 입력해주세요.",
              highlight: "카드사의 정보",
            ),
            SizedBox(height: 20),
            Text(
              '입력하신 카드 혜택을 반영해,\n가장 저렴한 주유소를 추천해 드릴게요. 💳',
              style: TextStyle(
                color: iconColor,
                fontSize: 16,
                fontWeight: FontWeight.w300,
                height: 1.25,
              ),
            ),
            SizedBox(height: 20),
            BrandSelector(
              brands: cardCompanies,
              onSelected: (selected) {
                print("선택된 카드사: $selected");
              },
            ),
          ],
        ),
      ),
    );
  }
}
