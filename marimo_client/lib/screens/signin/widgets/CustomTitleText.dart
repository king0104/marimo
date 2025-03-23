import 'package:flutter/material.dart';
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
  Widget build(BuildContext context) {
    // 강조할 부분을 기준으로 분리
    List<String> parts = text.split(highlight);

    return Text.rich(
      TextSpan(
        text: parts[0], // 강조 전 텍스트
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: textColor,
        ),
        children: [
          TextSpan(
            // 강조할 텍스트
            text: highlight,
            style: TextStyle(color: highlightColor),
          ),
          if (parts.length > 1) // 강조 후 텍스트
            TextSpan(text: parts[1], style: TextStyle(color: textColor)),
        ],
      ),
    );
  }
}
