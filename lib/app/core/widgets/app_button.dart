import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.loading = false,
    this.icon,
    this.color = AppColors.primary,
    this.textColor = Colors.white,
    this.outlined = false,
    this.height,
    this.expanded = true,
    this.radius,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final IconData? icon;
  final Color color;
  final Color textColor;
  final bool outlined;
  final double? height;
  final bool expanded;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    final child = loading
        ? SizedBox(
            height: 20.r,
            width: 20.r,
            child: CircularProgressIndicator(strokeWidth: 2.2, color: outlined ? color : textColor),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[Icon(icon, size: 18.r, color: outlined ? color : textColor), SizedBox(width: 8.w)],
              Text(label),
            ],
          );

    final style = ElevatedButton.styleFrom(
      backgroundColor: outlined ? Colors.transparent : color,
      foregroundColor: outlined ? color : textColor,
      elevation: 0,
      minimumSize: Size.fromHeight(height ?? AppSizes.buttonHeight),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius ?? AppSizes.radius)),
      side: outlined ? BorderSide(color: color, width: 1.4) : BorderSide.none,
      textStyle: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700),
      disabledBackgroundColor: (outlined ? Colors.transparent : color).withValues(alpha: .5),
      disabledForegroundColor: Colors.white70,
    );

    final button = SizedBox(
      width: expanded ? double.infinity : null,
      child: ElevatedButton(
        style: style,
        onPressed: loading ? null : onPressed,
        child: child,
      ),
    );
    return button;
  }
}
