import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_bar_widget.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/checkout_steps.dart';
import '../controllers/checkout_shipping_controller.dart';

class CheckoutShippingView extends GetView<CheckoutShippingController> {
  const CheckoutShippingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBarWidget(title: 'ວິທີການສົ່ງ', bottom: const CheckoutSteps(current: 1)),
      body: Obx(
        () => Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(16.w),
                children: [
                  Text('ເລືອກວິທີການຂົນສົ່ງ', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700)),
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
                            Icon(
                              option.id == 'SAME_DAY' ? Icons.bolt_rounded : Icons.local_shipping_outlined,
                              size: 22.r,
                              color: controller.isSelected(option.id) ? AppColors.primary : AppColors.textSecondary,
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    option.name,
                                    style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700),
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    option.eta,
                                    style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              option.fee == 0 ? 'ຟຣີ' : Formatters.money(option.fee),
                              style: TextStyle(
                                fontSize: 12.5.sp,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline_rounded, size: 18, color: AppColors.primary),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            'ສົ່ງຟຣີເມື່ອຊື້ຄົບ 500,000 ₭ ຂຶ້ນໄປ',
                            style: TextStyle(fontSize: 11.5.sp, color: AppColors.primaryDark),
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
                child: AppButton(label: 'ຕໍ່ໄປ', onPressed: controller.next),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
