import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const String fontFamily = 'PlusJakartaSans';

  static const TextStyle displayLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -1.0,
    color: ink900,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.8,
    color: ink900,
  );

  static const TextStyle headingL = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.3,
    color: ink900,
  );

  static const TextStyle headingM = TextStyle(
    fontFamily: fontFamily,
    fontSize: 17,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
    color: ink900,
  );

  static const TextStyle headingS = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.1,
    color: ink900,
  );

  static const TextStyle bodyL = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.0,
    color: ink700,
  );

  static const TextStyle bodyM = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.0,
    color: ink700,
  );

  static const TextStyle bodyS = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.1,
    color: ink500,
  );

  static const TextStyle labelM = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.2,
    color: ink500,
  );

  static const TextStyle labelS = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.3,
    color: ink500,
  );

  static const TextStyle priceL = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    fontFeatures: [FontFeature.tabularFigures()],
    color: ink900,
  );

  static const TextStyle priceM = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    fontFeatures: [FontFeature.tabularFigures()],
    color: ink900,
  );
}
