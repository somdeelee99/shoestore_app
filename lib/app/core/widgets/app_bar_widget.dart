import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../constants/app_colors.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({
    super.key,
    required this.title,
    this.actions,
    this.showBack = true,
    this.bottom,
    this.backgroundColor = Colors.white,
  });

  final String title;
  final List<Widget>? actions;
  final bool showBack;
  final PreferredSizeWidget? bottom;
  final Color backgroundColor;

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      centerTitle: true,
      title: Text(title),
      leading: showBack
          ? IconButton(
              icon: Container(
                padding: EdgeInsets.all(6.r),
                decoration: const BoxDecoration(color: AppColors.surfaceAlt, shape: BoxShape.circle),
                child: Icon(Icons.arrow_back_rounded, size: 18.r, color: AppColors.textPrimary),
              ),
              onPressed: () => Get.back(),
            )
          : null,
      actions: actions,
      bottom: bottom,
    );
  }
}
