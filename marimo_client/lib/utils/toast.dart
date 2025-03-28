import 'package:flutter/material.dart';

void showToast(
  BuildContext context,
  String message, {
  IconData icon = Icons.info,
  String type = 'info', // Add a type for different message styles
}) {
  final overlay = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder: (context) {
      // Set background color based on message type
      Color backgroundColor;
      if (type == 'success') {
        backgroundColor = Colors.green;
      } else if (type == 'error') {
        backgroundColor = Colors.red;
      } else {
        backgroundColor = const Color(
          0xFF1F2937,
        ); // Default info color (slate-800)
      }

      return Positioned(
        bottom: 110, // Adjusted position to be a bit higher
        left: MediaQuery.of(context).size.width * 0.075,
        right: MediaQuery.of(context).size.width * 0.075,
        child: AnimatedOpacity(
          opacity: 1.0,
          duration: const Duration(milliseconds: 300),
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
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
      );
    },
  );

  overlay.insert(overlayEntry);

  // ✨ 자동 사라짐 처리
  Future.delayed(const Duration(seconds: 2)).then((_) {
    overlayEntry.remove();
  });
}
