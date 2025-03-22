import 'package:flutter/material.dart';

const brandColor = Color(0xFF4888FF);
const pointColor = Color(0xFF7BDE88);
const backgroundColor = Color(0xFFFBFBFB);
const iconColor = Color(0xFF7E7E7E);
const pointRedColor = Color(0xFFFF4E4E);
const lightgrayColor = Color(0xFFBEBFC0);

final ThemeData appTheme = ThemeData(
  fontFamily: 'Freesentation',
  scaffoldBackgroundColor: backgroundColor,
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: brandColor, // 주요 브랜드 색상
    onPrimary: Colors.white,
    secondary: pointColor,
    onSecondary: Colors.white,
    background: backgroundColor,
    onBackground: iconColor,
    surface: Colors.white,
    onSurface: iconColor,
    error: pointRedColor,
    onError: Colors.white,
  ),
);
