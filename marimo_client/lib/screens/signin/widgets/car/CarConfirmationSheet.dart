import 'package:flutter/material.dart';
import 'package:marimo_client/theme.dart';

class CarConfirmationSheet extends StatelessWidget {
  final String carNumber;
  final String userName;
  final VoidCallback onConfirmed;

  const CarConfirmationSheet({
    super.key,
    required this.carNumber,
    required this.userName,
    required this.onConfirmed,
  });

  @override
  Widget build(BuildContext context) {
    final displayName = '$userName님';

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            carNumber,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color(0xFF4888FF),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "$displayName 명의 차량인가요?",
            style: const TextStyle(
              fontSize: 20,
              color: backgroundBlackColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "법인, 렌트, 리스 차량은\n아니오를 눌러주세요.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey, height: 1.5),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // ❌ 아니오 버튼
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(color: Color(0xFFBEBFC0)),
                      ),
                    ),
                    child: const Text(
                      "아니오",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),

              // ✅ 네 버튼
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      onConfirmed();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4888FF),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "네. 제 명의에요",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
