// card_provider.dart
import 'package:flutter/material.dart';
import 'package:marimo_client/services/card/card_service.dart';

class CardProvider with ChangeNotifier {
  List<CardInfo> _cards = [];
  int _selectedIndex = 0;
  bool _isLoading = false;

  List<CardInfo> get cards => _cards;
  int get selectedIndex => _selectedIndex;
  bool get isLoading => _isLoading;

  CardInfo? get selectedCard =>
      _cards.isNotEmpty ? _cards[_selectedIndex] : null;

  Future<void> fetchCards(String accessToken) async {
    _isLoading = true;
    notifyListeners();

    try {
      final fetchedCards = await CardService.getCards(accessToken: accessToken);
      _cards = fetchedCards;
    } catch (e) {
      print("🔥 카드 불러오기 실패: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  void setSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}
