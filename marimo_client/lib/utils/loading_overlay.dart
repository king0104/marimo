import 'package:flutter/material.dart';

OverlayEntry? _loadingOverlayEntry;
void showLoadingOverlay(BuildContext context, {String? message}) {
  if (_loadingOverlayEntry != null) return;

  _loadingOverlayEntry = OverlayEntry(
    builder:
        (_) => Stack(
          children: [
            ModalBarrier(
              dismissible: false,
              color: Colors.black.withOpacity(0.3),
            ),
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 24,
                ),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(color: Colors.white),
                    if (message != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        message,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
  );

  /// ✅ context 안전하게 사용
  WidgetsBinding.instance.addPostFrameCallback((_) {
    final overlay = Overlay.of(context, rootOverlay: true);
    if (overlay != null && _loadingOverlayEntry != null) {
      overlay.insert(_loadingOverlayEntry!);
    }
  });
}

void hideLoadingOverlay() {
  _loadingOverlayEntry?.remove();
  _loadingOverlayEntry = null;
}
