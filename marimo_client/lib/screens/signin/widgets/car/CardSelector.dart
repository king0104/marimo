import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marimo_client/theme.dart';

class CardSelector extends StatefulWidget {
  const CardSelector({super.key});

  @override
  State<CardSelector> createState() => _CardSelectorState();
}

class _CardSelectorState extends State<CardSelector> {
  final PageController _pageController = PageController(viewportFraction: 0.7);
  int _currentPage = 0;

  final List<Map<String, String>> _cards = [
    {
      'name': '현대카드 MX Black Edition2',
      'image': 'assets/images/cards/hyundai/mx_black.png',
    },
    {'name': '다른 카드 이름', 'image': 'assets/images/cards/hyundai/what.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _cards[_currentPage]['name']!,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            height: 1.43,
            color: black,
          ),
        ),
        SizedBox(height: 8.h),
        SizedBox(
          height: 310.h,
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
                  return Center(
                    child: Transform.scale(
                      scale: value,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 6.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16.r),
                          child: Image.asset(
                            card['image']!,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
