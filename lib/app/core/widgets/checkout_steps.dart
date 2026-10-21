import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';

/// The 1→4 step bar used at the top of every checkout screen.
class CheckoutSteps extends StatelessWidget implements PreferredSizeWidget {
  const CheckoutSteps({super.key, required this.current});

  /// 0 = address, 1 = shipping, 2 = payment, 3 = review
  final int current;

  static const _labels = ['ທີ່ຢູ່', 'ການສົ່ງ', 'ການຊຳລະ', 'ກວດສອບ'];

  @override
  Size get preferredSize => Size.fromHeight(58.h);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 10.h),
      child: Row(
        children: List.generate(_labels.length, (i) {
          final done = i < current;
          final active = i == current;
          return Expanded(
            child: Row(
              children: [
                Container(
                  height: 24.r,
                  width: 24.r,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: done || active ? AppColors.primary : AppColors.surfaceAlt,
                    shape: BoxShape.circle,
                  ),
                  child: done
                      ? Icon(Icons.check_rounded, size: 13.r, color: Colors.white)
                      : Text(
                          '${i + 1}',
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w700,
                            color: active ? Colors.white : AppColors.textHint,
                          ),
                        ),
                ),
                SizedBox(width: 5.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _labels[i],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 9.5.sp,
                          fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                          color: active ? AppColors.textPrimary : AppColors.textSecondary,
                        ),
                      ),
                      if (i < _labels.length - 1)
                        Container(
                          margin: EdgeInsets.only(top: 5.h),
                          height: 1.5,
                          color: done ? AppColors.primary : AppColors.divider,
                        ),
                    ],
                  ),
                ),
                SizedBox(width: 4.w),
              ],
            ),
          );
        }),
      ),
    );
  }
}
