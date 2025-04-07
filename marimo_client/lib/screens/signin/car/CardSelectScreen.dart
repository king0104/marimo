// CardSelectScreen.dart
import 'package:flutter/material.dart';
import 'package:marimo_client/providers/member/auth_provider.dart';
import 'package:marimo_client/screens/signin/widgets/car/CardSelector.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marimo_client/screens/signin/widgets/CustomTitleText.dart';
import 'package:marimo_client/providers/card_provider.dart';

class CardSelectScreen extends StatefulWidget {
  const CardSelectScreen({super.key});

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
      return const Center(child: CircularProgressIndicator());
    }

    if (cardProvider.cards.isEmpty) {
      return const Center(child: Text("불러올 카드가 없습니다."));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          const CustomTitleText(text: "주유 시 사용하는 카드를 골라주세요.", highlight: "카드"),
          const SizedBox(height: 40),
          CardSelector(cards: cardProvider.cards),
        ],
      ),
    );
  }
}
