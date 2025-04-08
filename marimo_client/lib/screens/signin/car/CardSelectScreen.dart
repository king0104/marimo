// CardSelectScreen.dart
import 'package:flutter/material.dart';
import 'package:marimo_client/providers/member/auth_provider.dart';
import 'package:marimo_client/screens/signin/widgets/car/CardSelector.dart';
import 'package:marimo_client/theme.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marimo_client/screens/signin/widgets/CustomTitleText.dart';
import 'package:marimo_client/providers/card_provider.dart';

class CardSelectScreen extends StatefulWidget {
  final String userName;
  const CardSelectScreen({super.key, required this.userName});

  @override
  State<CardSelectScreen> createState() => _CardSelectScreenState();
}

class _CardSelectScreenState extends State<CardSelectScreen> {
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final token = context.read<AuthProvider>().accessToken;
      if (token != null) {
        context.read<CardProvider>().fetchCards(token);
      }
      _isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cardProvider = context.watch<CardProvider>();

    if (cardProvider.isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: brandColor),
            SizedBox(height: 16.h),
            Text(
              "${widget.userName}님의 보유 카드를 불러오는 중입니다.",
              style: TextStyle(
                fontSize: 16.sp,
                color: iconColor,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      );
    }

    if (cardProvider.cards.isEmpty) {
      return Center(
        child: Text(
          "불러올 카드가 없습니다.",
          style: TextStyle(
            fontSize: 16.sp,
            color: iconColor,
            fontWeight: FontWeight.w300,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 40.h),
          const CustomTitleText(text: "주유 시 사용하는 카드를 골라주세요.", highlight: "카드"),
          SizedBox(height: 40.h),
          CardSelector(cards: cardProvider.cards),
        ],
      ),
    );
  }
}
