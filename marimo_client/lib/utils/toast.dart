import 'package:flutter/material.dart';
import 'package:marimo_client/theme.dart';

void showToast(
  BuildContext context,
  String message, {
  IconData icon = Icons.info,
  String type = 'info',
  String position = 'bottom-up', // 추가된 인자
}) {
  final overlay = Overlay.of(context);
  late OverlayEntry overlayEntry;
  final animationController = AnimationController(
    vsync: Navigator.of(context),
    duration: const Duration(milliseconds: 300),
  );

  final bool isTopDown = position == 'top-down';

  final animation = Tween<Offset>(
    begin: Offset(0, isTopDown ? -0.2 : 0.2),
    end: const Offset(0, 0),
  ).animate(
    CurvedAnimation(parent: animationController, curve: Curves.easeOut),
  );

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
        top: isTopDown ? 110 : null,
        bottom: isTopDown ? null : 110,
        left: MediaQuery.of(context).size.width * 0.075,
        right: MediaQuery.of(context).size.width * 0.075,
        child: SlideTransition(
          position: animation,
          child: FadeTransition(
            opacity: animationController,
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
