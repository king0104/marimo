// ResultInformation.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marimo_client/theme.dart';

class ResultInformation extends StatelessWidget {
  final double treadDepth;
  final double cardHeight; // ✅ 카드 높이 비율 기준 추가

  const ResultInformation({
    super.key,
    required this.treadDepth,
    required this.cardHeight,
  });

  String getLevel() {
    if (treadDepth < 3.0) return '나쁨';
    if (treadDepth < 5.0) return '보통';
    return '양호';
  }

  String getComment() {
    final level = getLevel();
    switch (level) {
      case '나쁨':
        return '타이어가 많이 아파요..\n지금 타이어를 갈아 끼우는 것을 추천해요.';
      case '보통':
        return '타이어 상태가 괜찮은 편입니다!\n주기적으로 진단해 주세요.';
      default:
        return '타이어가 건강한 편입니다!\n그래도 항상 주기적 점검은 해주셔야 하는거 알죠!?';
    }
  }

  Color getLevelColor(String level) {
    switch (level) {
      case '나쁨':
        return pointRedColor;
      case '보통':
        return pointColor;
      default:
        return brandColor;
    }
  }

  String getEmoji(String level) {
    switch (level) {
      case '나쁨':
        return '😵';
      case '보통':
        return '🙂';
      default:
        return '😆';
    }
  }

  @override
  Widget build(BuildContext context) {
    final level = getLevel();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
            children: [
              const TextSpan(text: '수준 : '),
              TextSpan(
                text: '$level ',
                style: TextStyle(
                  color: getLevelColor(level),
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextSpan(text: getEmoji(level)),
            ],
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          '사용감 : 트레드가 ${treadDepth.toStringAsFixed(1)}mm 남았어요',
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 25.h), // ✅ 여백을 고정 px 기준 반응형으로
        Text(
          getComment(),
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w300,
            color: Colors.black,
            height: 1.6,
          ),
        ),
      ],
    );
  }
}
