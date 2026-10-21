import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_bar_widget.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/loading_list.dart';
import '../controllers/addresses_controller.dart';

class AddressesView extends GetView<AddressesController> {
  const AddressesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBarWidget(title: controller.selectMode.value ? 'ເລືອກທີ່ຢູ່' : 'ທີ່ຢູ່ຈັດສົ່ງ'),
      body: Obx(() {
        if (controller.loading.value && controller.addresses.isEmpty) {
          return Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(children: const [LoadingCard(), LoadingCard()]),
          );
        }
        if (controller.addresses.isEmpty) {
          return Column(
            children: [
              const Expanded(
                child: EmptyState(
                  icon: Icons.location_off_outlined,
                  title: 'ຍັງບໍ່ມີທີ່ຢູ່',
                  description: 'ເພີ່ມທີ່ຢູ່ເພື່ອຄວາມສະດວກໃນການສັ່ງຊື້',
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.w),
                child: AppButton(label: 'ເພີ່ມທີ່ຢູ່ໃໝ່', icon: Icons.add_rounded, onPressed: controller.create),
              ),
            ],
          );
        }

        return Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                color: AppColors.primary,
                onRefresh: controller.fetch,
                child: ListView.builder(
                  padding: EdgeInsets.all(16.w),
                  itemCount: controller.addresses.length,
                  itemBuilder: (_, i) {
                    final address = controller.addresses[i];
                    return GestureDetector(
                      onTap: () => controller.select(address),
                      child: Container(
                        margin: EdgeInsets.only(bottom: 12.h),
                        padding: EdgeInsets.all(14.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: address.isDefault ? AppColors.primary.withValues(alpha: .5) : Colors.transparent,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryLight,
                                    borderRadius: BorderRadius.circular(6.r),
                                  ),
                                  child: Text(
                                    address.label,
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                                if (address.isDefault) ...[
                                  SizedBox(width: 6.w),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                                    decoration: BoxDecoration(
                                      color: AppColors.success.withValues(alpha: .12),
                                      borderRadius: BorderRadius.circular(6.r),
                                    ),
                                    child: Text(
                                      'ຄ່າຕັ້ງຕົ້ນ',
                                      style: TextStyle(
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.success,
                                      ),
                                    ),
                                  ),
                                ],
                                const Spacer(),
                                InkWell(
                                  onTap: () => controller.edit(address),
                                  child: Icon(Icons.edit_outlined, size: 16.r, color: AppColors.textSecondary),
                                ),
                                SizedBox(width: 14.w),
                                InkWell(
                                  onTap: () => controller.remove(address),
                                  child: Icon(Icons.delete_outline_rounded, size: 16.r, color: AppColors.danger),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              '${address.recipient}  ·  ${address.phone}',
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
                    );
                  },
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 20.h),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: .05), blurRadius: 12, offset: const Offset(0, -4)),
                ],
              ),
              child: AppButton(label: 'ເພີ່ມທີ່ຢູ່ໃໝ່', icon: Icons.add_rounded, onPressed: controller.create),
            ),
          ],
        );
      }),
    );
  }
}
