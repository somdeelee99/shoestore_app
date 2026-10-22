import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/routes/app_navigator.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_bar_widget.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/loading_list.dart';
import '../../../core/widgets/product_card.dart';
import '../../../core/widgets/quantity_stepper.dart';
import '../controllers/cart_controller.dart';

class CartView extends GetView<CartController> {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    final couponController = TextEditingController();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBarWidget(
        title: 'ກະຕ່າສິນຄ້າ',
        actions: [
          Obx(
            () => controller.items.isEmpty
                ? const SizedBox.shrink()
                : TextButton(
                    onPressed: controller.clear,
                    child: Text('ລ້າງ',
                        style: TextStyle(
                            fontSize: 12.sp, color: AppColors.textSecondary)),
                  ),
          ),
        ],
      ),
      body: Obx(() {
        if (!controller.isLoggedIn) {
          return EmptyState(
            icon: Icons.lock_outline_rounded,
            title: 'ກະລຸນາເຂົ້າສູ່ລະບົບ',
            description: 'ເຂົ້າສູ່ລະບົບເພື່ອເບິ່ງກະຕ່າສິນຄ້າຂອງທ່ານ',
            action: AppButton(
                label: 'ເຂົ້າສູ່ລະບົບ', onPressed: AppNavigator.openAccount),
          );
        }
        if (controller.loading.value && controller.cart.value == null) {
          return Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
                children: const [LoadingCard(), LoadingCard(), LoadingCard()]),
          );
        }
        if (controller.items.isEmpty) {
          return EmptyState(
            icon: Icons.shopping_bag_outlined,
            title: 'ກະຕ່າຂອງທ່ານຫວ່າງເປົ່າ',
            description: 'ເລືອກເກີບທີ່ທ່ານມັກ ແລ້ວໃສ່ໃນກະຕ່າໄດ້ເລີຍ',
            action: AppButton(
              label: 'ໄປເລືອກສິນຄ້າ',
              expanded: false,
              onPressed: () => Get.offAllNamed(AppRoutes.main),
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                color: AppColors.primary,
                onRefresh: controller.fetch,
                child: ListView(
                  padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
                  children: [
                    ...controller.items.map(
                      (item) => Container(
                        margin: EdgeInsets.only(bottom: 12.h),
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18.r)),
                        child: Column(
                          children: [
                            ProductTile(
                              image: item.image,
                              title: item.name,
                              subtitle: [
                                if (item.size != null) 'ຂະໜາດ ${item.size}',
                                if (item.color != null) item.color,
                              ].join(' · '),
                              price: Formatters.money(item.price),
                            ),
                            SizedBox(height: 10.h),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () => controller.removeItem(item),
                                  child: Row(
                                    children: [
                                      Icon(Icons.delete_outline_rounded,
                                          size: 16.r, color: AppColors.danger),
                                      SizedBox(width: 4.w),
                                      Text(
                                        'ລຶບ',
                                        style: TextStyle(
                                            fontSize: 11.sp,
                                            color: AppColors.danger),
                                      ),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                QuantityStepper(
                                  value: item.quantity,
                                  compact: true,
                                  max: item.stock == 0 ? 99 : item.stock,
                                  onChanged: (value) =>
                                      controller.updateQuantity(item, value),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Container(
                      padding: EdgeInsets.all(14.w),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18.r)),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: couponController,
                                  decoration: const InputDecoration(
                                    hintText: 'ລະຫັດຄູປອງ (WELCOME10)',
                                    prefixIcon: Icon(Icons.local_offer_outlined,
                                        size: 18),
                                  ),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              SizedBox(
                                width: 76.w,
                                child: AppButton(
                                  label: 'ໃຊ້',
                                  height: AppSizes.inputHeight,
                                  onPressed: () => controller
                                      .applyCoupon(couponController.text),
                                ),
                              ),
                            ],
                          ),
                          Obx(
                            () => controller.couponCode.value == null
                                ? const SizedBox.shrink()
                                : Padding(
                                    padding: EdgeInsets.only(top: 10.h),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.check_circle_rounded,
                                            size: 16, color: AppColors.success),
                                        SizedBox(width: 6.w),
                                        Text(
                                          'ໃຊ້ຄູປອງ ${controller.couponCode.value} ແລ້ວ',
                                          style: TextStyle(
                                              fontSize: 11.5.sp,
                                              color: AppColors.success),
                                        ),
                                        const Spacer(),
                                        GestureDetector(
                                          onTap: controller.removeCoupon,
                                          child: Text('ລຶບ',
                                              style: TextStyle(
                                                  fontSize: 11.5.sp,
                                                  color: AppColors.danger)),
                                        ),
                                      ],
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 16.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
                boxShadow: AppSizes.cardShadow,
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  children: [
                    _summaryRow(
                        'ລວມຄ່າສິນຄ້າ', Formatters.money(controller.subtotal)),
                    SizedBox(height: 6.h),
                    _summaryRow(
                        'ຄ່າຂົນສົ່ງ',
                        controller.shippingFee == 0
                            ? 'ຟຣີ'
                            : Formatters.money(controller.shippingFee)),
                    if (controller.discount.value > 0) ...[
                      SizedBox(height: 6.h),
                      _summaryRow('ສ່ວນຫຼຸດ',
                          '-${Formatters.money(controller.discount.value)}',
                          color: AppColors.success),
                    ],
                    Divider(height: 20.h),
                    Row(
                      children: [
                        Text(
                          'ລວມທັງໝົດ',
                          style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary),
                        ),
                        const Spacer(),
                        Text(
                          Formatters.money(controller.total),
                          style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w900,
                              color: AppColors.primary),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    AppButton(
                      label: 'ດຳເນີນການຕໍ່ (${controller.items.length} ລາຍການ)',
                      icon: Icons.arrow_forward_rounded,
                      onPressed: controller.checkout,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _summaryRow(String label, String value, {Color? color}) => Row(
        children: [
          Text(label,
              style:
                  TextStyle(fontSize: 12.sp, color: AppColors.textSecondary)),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
                fontSize: 12.5.sp,
                fontWeight: FontWeight.w600,
                color: color ?? AppColors.textPrimary),
          ),
        ],
      );
}
