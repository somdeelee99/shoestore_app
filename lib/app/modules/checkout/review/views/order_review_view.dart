import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_bar_widget.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/checkout_steps.dart';
import '../../../../core/widgets/product_card.dart';
import '../controllers/order_review_controller.dart';

class OrderReviewView extends GetView<OrderReviewController> {
  const OrderReviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBarWidget(title: 'ກວດສອບຄຳສັ່ງຊື້', bottom: const CheckoutSteps(current: 3)),
      body: Obx(
        () => Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(16.w),
                children: [
                  _card(
                    title: 'ທີ່ຢູ່ຈັດສົ່ງ',
                    onEdit: () => Get.toNamed(AppRoutes.checkoutAddress),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${controller.checkout.address.value?.recipient ?? '-'} · ${controller.checkout.address.value?.phone ?? ''}',
                          style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w700),
                        ),
                        SizedBox(height: 3.h),
                        Text(
                          controller.checkout.address.value?.fullAddress ?? '-',
                          style: TextStyle(fontSize: 11.5.sp, color: AppColors.textSecondary, height: 1.5),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12.h),
                  _card(
                    title: 'ການຂົນສົ່ງ & ການຊຳລະ',
                    onEdit: () => Get.toNamed(AppRoutes.checkoutShipping),
                    child: Column(
                      children: [
                        _row('ການຂົນສົ່ງ', controller.shippingLabel),
                        SizedBox(height: 6.h),
                        _row('ການຊຳລະ', controller.paymentLabel),
                        SizedBox(height: 6.h),
                        _row('ຄ່າຂົນສົ່ງ', Formatters.money(controller.checkout.shippingFee.value)),
                      ],
                    ),
                  ),
                  SizedBox(height: 12.h),
                  _card(
                    title: 'ລາຍການສິນຄ້າ (${controller.checkout.items.length})',
                    child: Column(
                      children: controller.checkout.items
                          .map(
                            (item) => Padding(
                              padding: EdgeInsets.only(bottom: 10.h),
                              child: ProductTile(
                                image: item.image,
                                title: item.name,
                                subtitle: 'ຂະໜາດ ${item.size ?? '-'} · x${item.quantity}',
                                price: Formatters.money(item.lineTotal),
                                size: 52,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  _card(
                    title: 'ໝາຍເຫດ',
                    child: TextField(
                      controller: controller.noteController,
                      maxLines: 2,
                      decoration: const InputDecoration(hintText: 'ເຊັ່ນ: ສົ່ງຕອນແລງ, ໂທກ່ອນສົ່ງ'),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  _card(
                    title: 'ສະຫຼຸບລາຄາ',
                    child: Column(
                      children: [
                        _row('ລວມຄ່າສິນຄ້າ', Formatters.money(controller.checkout.subtotal)),
                        SizedBox(height: 6.h),
                        _row('ຄ່າຂົນສົ່ງ', Formatters.money(controller.checkout.shippingFee.value)),
                        if (controller.checkout.discount.value > 0) ...[
                          SizedBox(height: 6.h),
                          _row('ສ່ວນຫຼຸດ', '-${Formatters.money(controller.checkout.discount.value)}', color: AppColors.success),
                        ],
                        Divider(height: 18.h),
                        Row(
                          children: [
                            Text('ລວມທັງໝົດ', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700)),
                            const Spacer(),
                            Text(
                              Formatters.money(controller.checkout.total),
                              style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w900, color: AppColors.primary),
                            ),
                          ],
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
                child: AppButton(
                  label: 'ຢືນຢັນສັ່ງຊື້',
                  icon: Icons.check_rounded,
                  loading: controller.loading.value,
                  onPressed: controller.placeOrder,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _card({required String title, required Widget child, VoidCallback? onEdit}) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18.r)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(title, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700)),
              const Spacer(),
              if (onEdit != null)
                GestureDetector(
                  onTap: onEdit,
                  child: Text('ແກ້ໄຂ', style: TextStyle(fontSize: 11.5.sp, color: AppColors.primary)),
                ),
            ],
          ),
          SizedBox(height: 10.h),
          child,
        ],
      ),
    );
  }

  Widget _row(String label, String value, {Color? color}) => Row(
        children: [
          Text(label, style: TextStyle(fontSize: 11.5.sp, color: AppColors.textSecondary)),
          const Spacer(),
          Text(
            value,
            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: color ?? AppColors.textPrimary),
          ),
        ],
      );
}
