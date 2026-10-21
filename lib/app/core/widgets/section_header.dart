import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel = 'ເບິ່ງທັງໝົດ',
    this.onAction,
    this.padding,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 15.5.sp, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
          ),
          const Spacer(),
          if (onAction != null)
            GestureDetector(
              onTap: onAction,
              child: Row(
                children: [
                  Text(
                    actionLabel ?? '',
                    style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: AppColors.primary),
                  ),
                  Icon(Icons.chevron_right_rounded, size: 16.r, color: AppColors.primary),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
