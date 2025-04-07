// CardSelector.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marimo_client/services/card/card_service.dart';
import 'package:provider/provider.dart';
import 'package:marimo_client/theme.dart';
import 'package:marimo_client/providers/card_provider.dart';

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

  @override
  Widget build(BuildContext context) {
    final provider = context.read<CardProvider>();
    final cards = widget.cards;

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

              return Center(
                child: Transform.scale(
                  scale: 1.0, // 원하는 애니메이션 값 넣어도 됨
                  child: Container(
                    height: 316.h,
                    margin: EdgeInsets.symmetric(horizontal: 2.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.r),
                      child: Image.asset(
                        'assets/images/cards/sample_card.png', // 실제 카드 이미지 경로 매핑 필요
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          cards[provider.selectedIndex].cardName,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            height: 1.43,
            color: black,
          ),
        ),
      ],
    );
  }
}
