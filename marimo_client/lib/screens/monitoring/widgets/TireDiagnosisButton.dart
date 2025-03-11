import 'package:flutter/material.dart';

class TireDiagnosisButton extends StatelessWidget {
  const TireDiagnosisButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        print("AI 진단 받기 클릭!");
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white, // 버튼 배경색 (흰색)
        foregroundColor: Colors.black, // 글씨 색상 (검정)
        padding: const EdgeInsets.symmetric(
          horizontal: 9,
          vertical: 10,
        ), // 내부 여백
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // 모서리 둥글게
          side: BorderSide(color: Colors.blue.shade300), // 테두리 추가
        ),
        elevation: 2, // 버튼 그림자 효과
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // 좌우 정렬
        children: [
          // 왼쪽 아이콘 + 텍스트
          Row(
            children: [
              Image.asset('assets/tire_icon.png', width: 40), // 아이콘 (assets 필요)
              const SizedBox(width: 10),
              const Text(
                "마지막 점검 후 20000km 주행",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(width: 20), // 버튼 안 여백
          // 우측 아이콘
          const Icon(Icons.chevron_right, size: 18),
        ],
      ),
    );
  }
}
