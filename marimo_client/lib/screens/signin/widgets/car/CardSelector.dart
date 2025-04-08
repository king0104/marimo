import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:marimo_client/providers/card_provider.dart';
import 'package:marimo_client/services/card/card_service.dart';
import 'package:marimo_client/theme.dart';

class CardSelector extends StatefulWidget {
  final List<CardInfo> cards;
  const CardSelector({super.key, required this.cards});

  @override
  State<CardSelector> createState() => _CardSelectorState();
}

class _CardSelectorState extends State<CardSelector> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.55);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  String getCardImagePath(String cardName) {
    // 띄어쓰기 제거 + 소문자 변환 후 asset 경로 매핑
    final fileName = cardName.toLowerCase().replaceAll(' ', '');
    return 'assets/images/cards/$fileName.png';
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CardProvider>();
    final cards = widget.cards;
    final selectedCard = cards[provider.selectedIndex];
    final numberFormat = NumberFormat('#,###');

    String formatCardDescription(String description) {
      return description
          .replaceAll('\n', ', ')
          .replaceAll('HYUNDAI', '현대')
          .replaceAll('S_OIL', 'S-OIL')
          .replaceAll('GS', 'GS')
          .replaceAll('SK', 'SK');
    }

    String formatBaselinePerformance(String rawText) {
      final regex = RegExp(r'(\d{3,})'); // 숫자 3자리 이상
      return rawText.replaceAllMapped(regex, (match) {
        final number = int.tryParse(match[0]!);
        if (number == null) return match[0]!;
        return NumberFormat('#,###').format(number);
      });
    }

    return Column(
      children: [
        SizedBox(
          height: 316.h,
          child: PageView.builder(
            controller: _pageController,
            itemCount: cards.length,
            onPageChanged: provider.setSelectedIndex,
            itemBuilder: (context, index) {
              final card = cards[index];
              final imagePath = getCardImagePath(card.cardName);

              return Center(
                child: Transform.scale(
                  scale: provider.selectedIndex == index ? 1 : 0.85,
                  child: Container(
                    height: 380.h,
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.r),
                      child: Image.asset(
                        imagePath,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) => Image.asset(
                              'assets/images/cards/sample_card.png',
                            ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 24.h),
        Text(
          selectedCard.cardName,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: black,
          ),
        ),
        SizedBox(height: 8.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Text(
            formatCardDescription(selectedCard.cardDescription.trim()),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              height: 1.375,
              fontWeight: FontWeight.w400,
              color: iconColor,
            ),
          ),
        ),
        SizedBox(height: 8.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Text(
            '기본 실적:  ${formatBaselinePerformance(selectedCard.baselinePerformance.trim())}',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w300,
              color: lightgrayColor,
            ),
          ),
        ),
      ],
    );
  }
}
