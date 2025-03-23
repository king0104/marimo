import 'package:flutter/material.dart';
import 'package:marimo_client/theme.dart';

class CarConfirmationSheet extends StatelessWidget {
  final String carNumber;
  final VoidCallback onConfirmed;

  const CarConfirmationSheet({
    super.key,
    required this.carNumber,
    required this.onConfirmed,
  });

  @override
  Widget build(BuildContext context) {
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

          const Text(
            "김두철님 명의 차량인가요?",
            style: TextStyle(
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
              // 🔹 아니요 버튼 (그림자 없음)
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context), // 팝업 닫기
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                        Color(0xFFFFFFFF),
                      ),
                      elevation: WidgetStatePropertyAll(0), // ✅ 모든 상태에서 그림자 제거
                      shadowColor: WidgetStatePropertyAll(
                        Colors.transparent,
                      ), // ✅ 그림자 색상 제거
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: const BorderSide(color: Color(0xFFBEBFC0)),
                        ),
                      ),
                    ),
                    child: const Text(
                      "아니오",
                      style: TextStyle(
                        color: Color(0xFF000000),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),

              // 🔹 네, 제 명의예요 버튼 (그림자 없음)
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // 팝업 닫기
                      onConfirmed(); // ✅ 확인 후 다음 단계로 이동
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                        const Color(0xFF4888FF),
                      ),
                      elevation: WidgetStatePropertyAll(0), // ✅ 모든 상태에서 그림자 제거
                      shadowColor: WidgetStatePropertyAll(
                        Colors.transparent,
                      ), // ✅ 그림자 색상 제거
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    child: const Text(
                      "네. 제 명의에요",
                      style: TextStyle(
                        color: Color(0xFFFFFFFF),
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
