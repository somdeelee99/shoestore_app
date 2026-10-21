import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';

class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.status, this.label, this.color, this.icon});

  final String status;
  final String? label;
  final Color? color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.statusColor(status);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: c.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[Icon(icon, size: 12.r, color: c), SizedBox(width: 4.w)],
          Text(
            label ?? AppColors.statusLabel(status),
            style: TextStyle(fontSize: 10.5.sp, fontWeight: FontWeight.w600, color: c),
          ),
        ],
      ),
    );
  }
}
