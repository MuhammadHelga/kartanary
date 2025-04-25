import 'package:flutter/material.dart';

class AppTypography {
  static const _fontFamily = 'Poppins';

  // DISPLAY
  static const TextStyle LargeRegular = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 57,
    height: 64 / 57,
  );

  static const TextStyle LargeSemiBold = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w600,
    fontSize: 57,
    height: 64 / 57,
  );

  static const TextStyle LargeBold = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w700,
    fontSize: 57,
    height: 64 / 57,
  );

  static const TextStyle MediumRegular = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 45,
    height: 52 / 45,
  );

  static const TextStyle SmallRegular = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 36,
    height: 44 / 36,
  );

  // HEADLINE
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 32,
    height: 40 / 32,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 28,
    height: 36 / 28,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 24,
    height: 32 / 24,
  );

  // TITLE
  static const TextStyle titleLarge = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w500,
    fontSize: 22,
    height: 28 / 22,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w500,
    fontSize: 16,
    height: (24 + 0.15) / 16, // height + tracking adjustment
  );

  static const TextStyle titleSmall = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w500,
    fontSize: 14,
    height: (20 + 0.1) / 14,
  );

  // LABEL
  static const TextStyle labelLarge = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w500,
    fontSize: 14,
    height: (20 + 0.1) / 14,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w500,
    fontSize: 12,
    height: (16 + 0.5) / 12,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w500,
    fontSize: 11,
    height: (16 + 0.5) / 11,
  );

  // BODY
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    height: (24 + 0.5) / 16,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    height: (20 + 0.25) / 14,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    height: (16 + 0.4) / 12,
  );
}
