import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';

class QuantityStepper extends StatelessWidget {
  const QuantityStepper({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 1,
    this.max = 99,
    this.compact = false,
  });

  final int value;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final size = compact ? 26.w : 32.w;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _button(Icons.remove_rounded, value > min ? () => onChanged(value - 1) : null, size),
          SizedBox(
            width: compact ? 26.w : 34.w,
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: (compact ? 12 : 14).sp, fontWeight: FontWeight.w700),
            ),
          ),
          _button(Icons.add_rounded, value < max ? () => onChanged(value + 1) : null, size),
        ],
      ),
    );
  }

  Widget _button(IconData icon, VoidCallback? onTap, double size) => GestureDetector(
        onTap: onTap,
        child: Container(
          height: size,
          width: size,
          decoration: BoxDecoration(
            color: onTap == null ? Colors.transparent : Colors.white,
            borderRadius: BorderRadius.circular(8.r),
            boxShadow: onTap == null ? null : AppSizes.softShadow,
          ),
          child: Icon(
            icon,
            size: (size * .55),
            color: onTap == null ? AppColors.textHint : AppColors.textPrimary,
          ),
        ),
      );
}
