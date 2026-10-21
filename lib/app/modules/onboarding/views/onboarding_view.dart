import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.only(top: 52.h, right: 18.w),
              child: TextButton(
                onPressed: controller.finish,
                child: Text('ຂ້າມ', style: TextStyle(color: AppColors.textSecondary, fontSize: 13.sp)),
              ),
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: controller.pageController,
              onPageChanged: controller.onPageChanged,
              itemCount: controller.pages.length,
              itemBuilder: (_, i) {
                final page = controller.pages[i];
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 6,
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.r),
                            image: DecorationImage(image: NetworkImage(page.image), fit: BoxFit.cover),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: .12),
                                blurRadius: 30,
                                offset: const Offset(0, 16),
                              ),
                            ],
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.r),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.transparent, Colors.black.withValues(alpha: .35)],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 32.h),
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            Text(
                              page.title,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                                height: 1.25,
                              ),
                            ).animate().fadeIn().slideY(begin: .2),
                            SizedBox(height: 12.h),
                            Text(
                              page.subtitle,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary, height: 1.6),
                            ).animate().fadeIn(delay: 120.ms),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 8.h),
          SmoothPageIndicator(
            controller: controller.pageController,
            count: controller.pages.length,
            effect: ExpandingDotsEffect(
              dotHeight: 7.r,
              dotWidth: 7.r,
              activeDotColor: AppColors.primary,
              dotColor: AppColors.divider,
              expansionFactor: 3.4,
              spacing: 6.w,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(24.w, 26.h, 24.w, 34.h),
            child: Obx(
              () => AppButton(
                label: controller.index.value == controller.pages.length - 1 ? 'ເລີ່ມຕົ້ນໃຊ້ງານ' : 'ຕໍ່ໄປ',
                icon: Icons.arrow_forward_rounded,
                onPressed: controller.next,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
