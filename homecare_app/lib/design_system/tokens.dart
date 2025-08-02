import 'package:flutter/material.dart';

/// Radix-UI 스타일의 디자인 토큰
class RadixTokens {
  RadixTokens._();

  // Colors - Radix Colors 팔레트 기반
  static const Color slate1 = Color(0xFFFCFCFD);
  static const Color slate2 = Color(0xFFF9F9FB);
  static const Color slate3 = Color(0xFFF0F0F3);
  static const Color slate4 = Color(0xFFE8E8EC);
  static const Color slate5 = Color(0xFFE0E1E6);
  static const Color slate6 = Color(0xFFD9DAE0);
  static const Color slate7 = Color(0xFFCECFD6);
  static const Color slate8 = Color(0xFFBBBCC4);
  static const Color slate9 = Color(0xFF8B8D98);
  static const Color slate10 = Color(0xFF80828D);
  static const Color slate11 = Color(0xFF65676F);
  static const Color slate12 = Color(0xFF1C1D20);

  static const Color blue1 = Color(0xFFFBFDFF);
  static const Color blue2 = Color(0xFFF4FAFF);
  static const Color blue3 = Color(0xFFE6F4FE);
  static const Color blue4 = Color(0xFFD0ECFF);
  static const Color blue5 = Color(0xFFB7E0FF);
  static const Color blue6 = Color(0xFF96D0FF);
  static const Color blue7 = Color(0xFF68BCFF);
  static const Color blue8 = Color(0xFF20A1FF);
  static const Color blue9 = Color(0xFF0084FF);
  static const Color blue10 = Color(0xFF0074E6);
  static const Color blue11 = Color(0xFF0062CC);
  static const Color blue12 = Color(0xFF002A5C);

  // Grass Colors - 포인트 컬러
  static const Color grass1 = Color(0xFFFBFEFC);
  static const Color grass2 = Color(0xFFF3FCF4);
  static const Color grass3 = Color(0xFFEBF9EE);
  static const Color grass4 = Color(0xFFDFF3E4);
  static const Color grass5 = Color(0xFFCEEBD7);
  static const Color grass6 = Color(0xFFB7DFC8);
  static const Color grass7 = Color(0xFF97CFB0);
  static const Color grass8 = Color(0xFF65BA75);
  static const Color grass9 = Color(0xFF46A758);
  static const Color grass10 = Color(0xFF3D9A50);
  static const Color grass11 = Color(0xFF297C3B);
  static const Color grass12 = Color(0xFF1B311E);

  // Indigo Colors - 포인트 컬러
  static const Color indigo1 = Color(0xFFFDFDFF);
  static const Color indigo2 = Color(0xFFF8FAFF);
  static const Color indigo3 = Color(0xFFF0F4FF);
  static const Color indigo4 = Color(0xFFE6EDFF);
  static const Color indigo5 = Color(0xFFD9E2FF);
  static const Color indigo6 = Color(0xFFC6D4FF);
  static const Color indigo7 = Color(0xFFADC2FF);
  static const Color indigo8 = Color(0xFF8DA4FF);
  static const Color indigo9 = Color(0xFF3E63DD);
  static const Color indigo10 = Color(0xFF3A5CCC);
  static const Color indigo11 = Color(0xFF3451B2);
  static const Color indigo12 = Color(0xFF101D46);

  // Spacing - Radix Space Scale
  static const double space1 = 4.0;
  static const double space2 = 8.0;
  static const double space3 = 12.0;
  static const double space4 = 16.0;
  static const double space5 = 20.0;
  static const double space6 = 24.0;
  static const double space7 = 28.0;
  static const double space8 = 32.0;
  static const double space9 = 36.0;

  // Radius
  static const double radius1 = 3.0;
  static const double radius2 = 4.0;
  static const double radius3 = 6.0;
  static const double radius4 = 8.0;
  static const double radius5 = 12.0;
  static const double radius6 = 16.0;

  // Typography
  static const TextStyle heading1 = TextStyle(
    fontSize: 35,
    fontWeight: FontWeight.w800,
    height: 1.2,
    letterSpacing: -0.025,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w700,
    height: 1.25,
    letterSpacing: -0.025,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 25,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: -0.015,
  );

  static const TextStyle body1 = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const TextStyle body2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.45,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );
}