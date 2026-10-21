import 'package:flutter/material.dart';

/// Brand palette taken from the UI board (ShoeStore red / dark navy).
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFFE11D2A);
  static const Color primaryDark = Color(0xFFB0111C);
  static const Color primaryLight = Color(0xFFFFE7E9);

  static const Color secondary = Color(0xFF111827);
  static const Color accent = Color(0xFFF59E0B);

  static const Color background = Color(0xFFF7F8FA);
  static const Color surface = Colors.white;
  static const Color surfaceAlt = Color(0xFFF1F3F7);

  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textHint = Color(0xFF9CA3AF);
  static const Color divider = Color(0xFFE5E7EB);

  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);
  static const Color danger = Color(0xFFEF4444);

  static const Color darkBackground = Color(0xFF0B1220);
  static const Color darkSurface = Color(0xFF111827);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFE11D2A), Color(0xFFB0111C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient splashGradient = LinearGradient(
    colors: [Color(0xFF0B1220), Color(0xFF1F2937), Color(0xFF7F1018)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Order status colours, mirrored from the admin panel.
  static Color statusColor(String status) {
    switch (status) {
      case 'PENDING':
        return warning;
      case 'CONFIRMED':
        return info;
      case 'PACKING':
        return const Color(0xFF6366F1);
      case 'SHIPPING':
        return const Color(0xFFF97316);
      case 'DELIVERED':
        return success;
      case 'CANCELLED':
        return danger;
      default:
        return textSecondary;
    }
  }

  static String statusLabel(String status) {
    switch (status) {
      case 'PENDING':
        return 'ລໍຖ້າຢືນຢັນ';
      case 'CONFIRMED':
        return 'ຢືນຢັນແລ້ວ';
      case 'PACKING':
        return 'ກຳລັງກຽມສົ່ງ';
      case 'SHIPPING':
        return 'ກຳລັງຂົນສົ່ງ';
      case 'DELIVERED':
        return 'ສຳເລັດ';
      case 'CANCELLED':
        return 'ຍົກເລີກ';
      default:
        return status;
    }
  }
}
