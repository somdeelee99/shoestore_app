import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';

class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
    this.controller,
    this.hint = 'ຄົ້ນຫາສິນຄ້າ...',
    this.onChanged,
    this.onSubmitted,
    this.onFilter,
    this.readOnly = false,
    this.onTap,
  });

  final TextEditingController? controller;
  final String hint;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onFilter;
  final bool readOnly;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 46.h,
            decoration: BoxDecoration(
              color: AppColors.surfaceAlt,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: TextField(
              controller: controller,
              readOnly: readOnly,
              onTap: onTap,
              onChanged: onChanged,
              onSubmitted: onSubmitted,
              style: TextStyle(fontSize: 13.sp),
              decoration: InputDecoration(
                hintText: hint,
                filled: false,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                prefixIcon: Icon(Icons.search_rounded, size: 19.r, color: AppColors.textHint),
                contentPadding: EdgeInsets.symmetric(vertical: 13.h),
              ),
            ),
          ),
        ),
        if (onFilter != null) ...[
          SizedBox(width: 8.w),
          GestureDetector(
            onTap: onFilter,
            child: Container(
              height: 46.h,
              width: 46.h,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Icon(Icons.tune_rounded, size: 20.r, color: Colors.white),
            ),
          ),
        ],
      ],
    );
  }
}
