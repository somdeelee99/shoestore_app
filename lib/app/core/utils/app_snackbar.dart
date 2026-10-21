import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/app_colors.dart';

class AppSnackbar {
  AppSnackbar._();

  static void success(String message, {String title = 'ສຳເລັດ'}) => _show(
        title,
        message,
        AppColors.success,
        Icons.check_circle_rounded,
      );

  static void error(String message, {String title = 'ຜິດພາດ'}) => _show(
        title,
        message,
        AppColors.danger,
        Icons.error_rounded,
      );

  static void info(String message, {String title = 'ແຈ້ງເຕືອນ'}) => _show(
        title,
        message,
        AppColors.info,
        Icons.info_rounded,
      );

  static void _show(String title, String message, Color color, IconData icon) {
    if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.white,
      colorText: AppColors.textPrimary,
      margin: const EdgeInsets.all(14),
      borderRadius: 16,
      duration: const Duration(seconds: 3),
      icon: Icon(icon, color: color),
      boxShadows: [
        BoxShadow(color: Colors.black.withValues(alpha: .08), blurRadius: 20, offset: const Offset(0, 8)),
      ],
    );
  }
}
