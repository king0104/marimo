import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:marimo_client/theme.dart';
import 'package:marimo_client/constants/card_assets.dart';

class CardSelector extends StatefulWidget {
  const CardSelector({super.key});

  @override
  State<CardSelector> createState() => _CardSelectorState();
}

class _CardSelectorState extends State<CardSelector> {
  final PageController _pageController = PageController(viewportFraction: 0.55);
  int _currentPage = 0;

  final List<Map<String, String>> _cards = hyundaiCardAssets;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 316.h,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _cards.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final card = _cards[index];
              return AnimatedBuilder(
                animation: _pageController,
                builder: (context, child) {
                  double value = 1.0;
                  if (_pageController.hasClients &&
                      _pageController.position.haveDimensions) {
                    value = (_pageController.page! - index).abs();
                  } else {
                    value =
                        (_currentPage - index)
                            .abs()
                            .toDouble(); // 초기 렌더링 fallback
                  }

                  value = (1 - (value * 0.2)).clamp(0.85, 1.0);

                  return Center(
                    child: Transform.scale(
                      scale: value,
                      child: Container(
                        height: 316.h,
                        margin: EdgeInsets.symmetric(horizontal: 2.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16.r),
                          child: Image.asset(card['image']!, fit: BoxFit.cover),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          _cards[_currentPage]['name']!,
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
