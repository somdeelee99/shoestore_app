import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_bar_widget.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/loading_list.dart';
import '../controllers/coupons_controller.dart';

class CouponsView extends GetView<CouponsController> {
  const CouponsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppBarWidget(title: 'ຄູປອງຂອງຂ້ອຍ'),
      body: Obx(() {
        if (controller.loading.value && controller.coupons.isEmpty) {
          return Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(children: const [LoadingCard(height: 96), LoadingCard(height: 96)]),
          );
        }
        if (controller.coupons.isEmpty) {
          return const EmptyState(
            icon: Icons.local_offer_outlined,
            title: 'ຍັງບໍ່ມີຄູປອງ',
            description: 'ຕິດຕາມໂປຣໂມຊັ່ນເພື່ອຮັບຄູປອງສ່ວນຫຼຸດ',
          );
        }
        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: controller.fetch,
          child: ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: controller.coupons.length + 1,
            itemBuilder: (_, i) {
              if (i == 0) {
                return Container(
                  margin: EdgeInsets.only(bottom: 14.h),
                  padding: EdgeInsets.all(14.w),
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.tips_and_updates_outlined, color: AppColors.accent, size: 22),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Text(
                          'ພິມລະຫັດຄູປອງທີ່ໜ້າກະຕ່າ ເພື່ອຮັບສ່ວນຫຼຸດ',
                          style: TextStyle(fontSize: 11.sp, color: Colors.white, height: 1.4),
                        ),
                      ),
                    ],
                  ),
                );
              }
              final coupon = controller.coupons[i - 1];
              return Container(
                margin: EdgeInsets.only(bottom: 12.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 92.w,
                      padding: EdgeInsets.symmetric(vertical: 22.h),
                      decoration: const BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.horizontal(left: Radius.circular(16)),
                      ),
                      child: Column(
                        children: [
                          Text(
                            coupon.type == 'PERCENT' ? '${coupon.value.round()}%' : Formatters.number(coupon.value),
                            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w900, color: Colors.white),
                          ),
                          Text(
                            coupon.type == 'PERCENT' ? 'ສ່ວນຫຼຸດ' : 'ບາດ',
                            style: TextStyle(fontSize: 10.sp, color: Colors.white.withValues(alpha: .9)),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(12.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              coupon.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w700),
                            ),
                            SizedBox(height: 3.h),
                            Text(
                              'ຂັ້ນຕ່ຳ ${Formatters.money(coupon.minSpend)}',
                              style: TextStyle(fontSize: 10.5.sp, color: AppColors.textHint),
                            ),
                            if (coupon.endAt != null)
                              Text(
                                'ໝົດອາຍຸ ${Formatters.date(coupon.endAt)}',
                                style: TextStyle(fontSize: 10.5.sp, color: AppColors.textHint),
                              ),
                            SizedBox(height: 8.h),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () => controller.copyCode(coupon),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 4.h),
                                    decoration: BoxDecoration(
                                      color: AppColors.surfaceAlt,
                                      borderRadius: BorderRadius.circular(6.r),
                                      border: Border.all(color: AppColors.divider),
                                    ),
                                    child: Text(
                                      coupon.code,
                                      style: TextStyle(
                                        fontSize: 10.5.sp,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: .6,
                                      ),
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () => controller.useCoupon(coupon),
                                  child: Text(
                                    'ໃຊ້ເລີຍ',
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
