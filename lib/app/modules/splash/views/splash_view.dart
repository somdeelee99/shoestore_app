import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/app_colors.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.splashGradient),
        child: Stack(
          children: [
            // decorative glow
            Positioned(
              top: -80.h,
              right: -60.w,
              child: Container(
                height: 260.r,
                width: 260.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(colors: [
                    AppColors.primary.withValues(alpha: .55),
                    Colors.transparent
                  ]),
                ),
              ),
            ),
            Positioned(
              bottom: -100.h,
              left: -70.w,
              child: Container(
                height: 300.r,
                width: 300.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(colors: [
                    AppColors.primary.withValues(alpha: .35),
                    Colors.transparent
                  ]),
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 96.r,
                    width: 96.r,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28.r),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withValues(alpha: .35),
                            blurRadius: 40,
                            offset: const Offset(0, 18)),
                      ],
                    ),
                    child: Icon(Icons.directions_run_rounded,
                        size: 56.r, color: AppColors.primary),
                  )
                      .animate()
                      .scale(duration: 700.ms, curve: Curves.easeOutBack)
                      .fadeIn(duration: 500.ms),
                  SizedBox(height: 24.h),
                  Text(
                    'SHOE STORE',
                    style: TextStyle(
                      fontSize: 26.sp,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 6,
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 300.ms, duration: 600.ms)
                      .slideY(begin: .3, end: 0),
                  SizedBox(height: 6.h),
                  Text(
                    'ຮ້ານເກີບຄຸນນະພາບ',
                    style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.white.withValues(alpha: .65),
                        letterSpacing: 2),
                  ).animate().fadeIn(delay: 500.ms, duration: 600.ms),
                ],
              ),
            ),
            Positioned(
              bottom: 48.h,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  SizedBox(
                    height: 22.r,
                    width: 22.r,
                    child: const CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white54),
                  ),
                  SizedBox(height: 14.h),
                  Text(
                    'ກຳລັງໂຫລດ...',
                    style: TextStyle(fontSize: 11.sp, color: Colors.white38),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
