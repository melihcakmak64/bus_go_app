// lib/core/theme/app_colors.dart
import 'package:flutter/material.dart';

abstract final class AppColors {
  static const Color surface = Color(0xFFF8F9FF);
  static const Color surfaceLowest = Color(0xFFFFFFFF);
  static const Color surfaceLow = Color(0xFFEFF4FF);
  static const Color surfaceHigh = Color(0xFFDCE9FF);
  static const Color surfaceHighest = Color(0xFFD3E4FE);

  static const Color primary = Color(0xFF000000);
  static const Color primaryContainer = Color(0xFF131B2E);
  static const Color secondary = Color(0xFFA73A00);
  static const Color secondaryContainer = Color(0xFFFD651E);
  static const Color secondaryFixed = Color(0xFFFFDBCE);
  static const Color onSecondaryContainer = Color(0xFF571A00);
  static const Color tertiaryContainer = Color(0xFF001551);

  static const Color onSurface = Color(0xFF0B1C30);
  static const Color onSurfaceVariant = Color(0xFF45464D);
  static const Color outline = Color(0xFF76777D);
  static const Color outlineVariant = Color(0xFFC6C6CD);
  static const Color error = Color(0xFFBA1A1A);
  static const Color success = Color(0xFF16A34A);
}