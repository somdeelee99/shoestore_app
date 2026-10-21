import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Spacing / radius tokens (all responsive through flutter_screenutil).
class AppSizes {
  AppSizes._();

  static EdgeInsets get page => EdgeInsets.symmetric(horizontal: 16.w);
  static EdgeInsets get pageV => EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h);

  static double get xs => 4.w;
  static double get sm => 8.w;
  static double get md => 12.w;
  static double get lg => 16.w;
  static double get xl => 24.w;
  static double get xxl => 32.w;

  static double get radiusSm => 10.r;
  static double get radius => 14.r;
  static double get radiusLg => 20.r;
  static double get radiusXl => 28.r;

  static double get buttonHeight => 52.h;
  static double get inputHeight => 52.h;
  static double get appBarHeight => 56.h;

  static List<BoxShadow> get softShadow => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 16,
          offset: const Offset(0, 6),
        ),
      ];

  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: const Color(0xFF111827).withValues(alpha: 0.06),
          blurRadius: 24,
          offset: const Offset(0, 10),
        ),
      ];
}
