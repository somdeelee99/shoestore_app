import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_bar_widget.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/checkout_steps.dart';
import '../../../../core/widgets/empty_state.dart';
import '../controllers/checkout_address_controller.dart';

class CheckoutAddressView extends GetView<CheckoutAddressController> {
  const CheckoutAddressView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBarWidget(title: 'ທີ່ຢູ່ຈັດສົ່ງ', bottom: const CheckoutSteps(current: 0)),
      body: Obx(() {
        return Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(16.w),
                children: [
                  Text('ເລືອກທີ່ຢູ່ຈັດສົ່ງ', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700)),
                  SizedBox(height: 10.h),
                  if (controller.addresses.isEmpty)
                    const EmptyState(
                      icon: Icons.location_off_outlined,
                      title: 'ຍັງບໍ່ມີທີ່ຢູ່',
                      description: 'ເພີ່ມທີ່ຢູ່ຈັດສົ່ງເພື່ອດຳເນີນການຕໍ່',
                    )
                  else
                    ...controller.addresses.map(
                      (address) => Obx(
                        () => GestureDetector(
                          onTap: () => controller.select(address),
                          child: Container(
                            margin: EdgeInsets.only(bottom: 10.h),
                            padding: EdgeInsets.all(14.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(
                                color: controller.selected.value?.id == address.id
                                    ? AppColors.primary
                                    : Colors.transparent,
                                width: 1.6,
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  controller.selected.value?.id == address.id
                                      ? Icons.radio_button_checked_rounded
                                      : Icons.radio_button_off_rounded,
                                  color: controller.selected.value?.id == address.id
                                      ? AppColors.primary
                                      : AppColors.textHint,
                                  size: 20.r,
                                ),
                                SizedBox(width: 10.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            address.label,
                                            style: TextStyle(
                                              fontSize: 10.5.sp,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                          if (address.isDefault) ...[
                                            SizedBox(width: 6.w),
                                            Container(
                                              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
                                              decoration: BoxDecoration(
                                                color: AppColors.primaryLight,
                                                borderRadius: BorderRadius.circular(5.r),
                                              ),
                                              child: Text(
                                                'ຄ່າເລີ່ມຕົ້ນ',
                                                style: TextStyle(fontSize: 9.sp, color: AppColors.primary),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        '${address.recipient} · ${address.phone}',
                                        style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w700),
                                      ),
                                      SizedBox(height: 3.h),
                                      Text(
                                        address.fullAddress,
                                        style: TextStyle(fontSize: 11.5.sp, color: AppColors.textSecondary, height: 1.5),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  SizedBox(height: 8.h),
                  OutlinedButton.icon(
                    onPressed: controller.addNewAddress,
                    icon: const Icon(Icons.add_rounded, size: 18),
                    label: const Text('ເພີ່ມທີ່ຢູ່ໃໝ່'),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.divider),
                      foregroundColor: AppColors.textPrimary,
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
                child: AppButton(
                  label: 'ຕໍ່ໄປ',
                  onPressed: controller.next,
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
