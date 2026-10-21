import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_bar_widget.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/checkout_steps.dart';
import '../controllers/checkout_payment_controller.dart';

class CheckoutPaymentView extends GetView<CheckoutPaymentController> {
  const CheckoutPaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBarWidget(title: 'ການຊຳລະເງິນ', bottom: const CheckoutSteps(current: 2)),
      body: Obx(
      () => Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16.w),
              children: [
                Text('ເລືອກວິທີຊຳລະເງິນ', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700)),
                SizedBox(height: 10.h),
                ...controller.options.map(
                  (option) => GestureDetector(
                    onTap: () => controller.select(option),
                    child: Container(
                      margin: EdgeInsets.only(bottom: 10.h),
                      padding: EdgeInsets.all(14.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: controller.isSelected(option.id) ? AppColors.primary : Colors.transparent,
                          width: 1.6,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 38.r,
                            width: 38.r,
                            decoration: BoxDecoration(
                              color: AppColors.surfaceAlt,
                              borderRadius: BorderRadius.circular(11.r),
                            ),
                            child: Icon(
                              controller.iconFor(option.icon),
                              size: 19.r,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Text(
                              option.name,
                              style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w600),
                            ),
                          ),
                          Icon(
                            controller.isSelected(option.id)
                                ? Icons.radio_button_checked_rounded
                                : Icons.radio_button_off_rounded,
                            size: 20.r,
                            color: controller.isSelected(option.id) ? AppColors.primary : AppColors.textHint,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 6.h),
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.lock_outline_rounded, size: 18, color: AppColors.success),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          'ຂໍ້ມູນການຊຳລະຂອງທ່ານຖືກປົກປ້ອງດ້ວຍການເຂົ້າລະຫັດ SSL',
                          style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(16.w),
            child: SafeArea(
              top: false,
              child: AppButton(label: 'ກວດສອບຄຳສັ່ງຊື້', onPressed: controller.next),
            ),
          ),
        ],
      ),
      ),
    );
  }
}
