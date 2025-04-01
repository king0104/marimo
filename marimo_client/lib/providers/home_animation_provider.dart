import 'package:flutter/material.dart';

class HomeAnimationProvider with ChangeNotifier {
  bool _shouldAnimate = true;

  bool get shouldAnimate => _shouldAnimate;

  void disableAnimation() {
    _shouldAnimate = false;
    notifyListeners();
  }
}
