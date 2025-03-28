import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marimo_client/theme.dart';

class CustomTitleText extends StatelessWidget {
  final String text;
  final String highlight;
  final Color highlightColor;
  final double fontSize;
  final FontWeight fontWeight;
  final Color textColor;

  const CustomTitleText({
    super.key,
    required this.text,
    required this.highlight,
    this.highlightColor = brandColor,
    this.fontSize = 20,
    this.fontWeight = FontWeight.w700,
    this.textColor = backgroundBlackColor,
  });

  @override
  @override
  Widget build(BuildContext context) {
    // 강조할 부분을 기준으로 분리
    List<String> parts = text.split(highlight);

    // highlight가 "카드"일 때만 패딩 적용
    final bool isCardHighlight = highlight == "카드";
    final EdgeInsetsGeometry effectivePadding =
        isCardHighlight
            ? EdgeInsets.symmetric(horizontal: 20.w)
            : EdgeInsets.zero;

    return Padding(
      padding: effectivePadding,
      child: Text.rich(
        TextSpan(
          text: parts[0], // 강조 전 텍스트
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: textColor,
          ),
          children: [
            TextSpan(text: highlight, style: TextStyle(color: highlightColor)),
            if (parts.length > 1)
              TextSpan(text: parts[1], style: TextStyle(color: textColor)),
          ],
        ),
      ),
    );
  }
}
