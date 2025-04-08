import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marimo_client/theme.dart';

void showToast(
  BuildContext context,
  String message, {
  IconData icon = Icons.info,
  String type = 'info',
  String position = 'bottom-up',
}) {
  final overlay = Overlay.of(context);
  late OverlayEntry overlayEntry;
  final animationController = AnimationController(
    vsync: Navigator.of(context),
    duration: const Duration(milliseconds: 300),
    reverseDuration: const Duration(milliseconds: 150),
  );

  final bool isTopDown = position == 'top-down';

  final fadeInAnimation = CurvedAnimation(
    parent: animationController,
    curve: Curves.easeOut,
  );

  final scaleAnimation = TweenSequence<double>([
    TweenSequenceItem(tween: Tween(begin: 0.8, end: 1.05), weight: 70),
    TweenSequenceItem(tween: Tween(begin: 1.05, end: 1.0), weight: 30),
  ]).animate(fadeInAnimation);

  Color backgroundColor;
  switch (type) {
    case 'success':
      backgroundColor = pointColor;
      break;
    case 'error':
      backgroundColor = pointRedColor;
      break;
    default:
      backgroundColor = backgroundBlackColor;
  }

  overlayEntry = OverlayEntry(
    builder: (context) {
      return Positioned(
        top: isTopDown ? 40 : null,
        bottom: isTopDown ? null : 110,
        left: 20.w,
        right: 20.w,
        child: FadeTransition(
          opacity: fadeInAnimation,
          child: ScaleTransition(
            scale: scaleAnimation,
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: black.withAlpha(14),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(icon, color: Colors.white, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        message,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );

  overlay.insert(overlayEntry);
  animationController.forward();

  Future.delayed(const Duration(seconds: 2)).then((_) async {
    await animationController.reverse();
    overlayEntry.remove();
    animationController.dispose();
  });
}
