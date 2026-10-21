import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_bar_widget.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/loading_list.dart';
import '../../../../core/widgets/product_card.dart';
import '../../../../core/widgets/status_chip.dart';
import '../controllers/order_detail_controller.dart';

class OrderDetailView extends GetView<OrderDetailController> {
  const OrderDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBarWidget(title: 'ລາຍລະອຽດຄຳສັ່ງຊື້'),
      body: Obx(() {
        final order = controller.order.value;
        if (controller.loading.value && order == null) {
          return Padding(
              padding: EdgeInsets.all(16.w),
              child: const LoadingCard(height: 120));
        }
        if (order == null) {
          return const Center(child: Text('ບໍ່ພົບຄຳສັ່ງຊື້'));
        }

        return ListView(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
          children: [
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '#${order.code}',
                        style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w800,
                            color: Colors.white),
                      ),
                      const Spacer(),
                      StatusChip(
                        status: order.status,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    Formatters.dateTime(order.createdAt),
                    style: TextStyle(
                        fontSize: 11.sp,
                        color: Colors.white.withValues(alpha: .85)),
                  ),
                  SizedBox(height: 14.h),
                  Row(
                    children: [
                      _miniStat('ລວມທັງໝົດ', Formatters.money(order.total)),
                      SizedBox(width: 16.w),
                      _miniStat(
                          'ການຊຳລະ',
                          order.paymentStatus == 'PAID'
                              ? 'ຊຳລະແລ້ວ'
                              : 'ຍັງບໍ່ຊຳລະ'),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            _card(
              title: 'ສະຖານະການຈັດສົ່ງ',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.local_shipping_outlined,
                          size: 18, color: AppColors.primary),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          '${controller.shippingMethodLabel(order.shippingMethod)} · ${controller.paymentMethodLabel(order.paymentMethod)}',
                          style: TextStyle(
                              fontSize: 11.5.sp,
                              color: AppColors.textSecondary),
                        ),
                      ),
                    ],
                  ),
                  if (order.trackingNumber != null) ...[
                    SizedBox(height: 8.h),
                    Text(
                      'ເລກພັດສະດຸ: ${order.trackingNumber}',
                      style: TextStyle(
                          fontSize: 11.5.sp, fontWeight: FontWeight.w600),
                    ),
                  ],
                  SizedBox(height: 10.h),
                  AppButton(
                      label: 'ຕິດຕາມຄຳສັ່ງຊື້',
                      height: 42.h,
                      onPressed: controller.openTracking),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            _card(
              title: 'ທີ່ຢູ່ຈັດສົ່ງ',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${order.recipient} · ${order.phone}',
                    style:
                        TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    order.shippingAddress,
                    style: TextStyle(
                        fontSize: 11.5.sp,
                        color: AppColors.textSecondary,
                        height: 1.5),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            _card(
              title: 'ລາຍການສິນຄ້າ (${order.items.length})',
              child: Column(
                children: order.items
                    .map(
                      (item) => Padding(
                        padding: EdgeInsets.only(bottom: 10.h),
                        child: ProductTile(
                          image: item.image,
                          title: item.name,
                          subtitle:
                              'ຂະໜາດ ${item.size ?? '-'} · ${item.color ?? ''} · x${item.quantity}',
                          price: Formatters.money(item.price * item.quantity),
                          size: 52,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            SizedBox(height: 12.h),
            _card(
              title: 'ສະຫຼຸບລາຄາ',
              child: Column(
                children: [
                  _row('ລວມຄ່າສິນຄ້າ', Formatters.money(order.subtotal)),
                  SizedBox(height: 6.h),
                  _row('ຄ່າຂົນສົ່ງ', Formatters.money(order.shippingFee)),
                  if (order.discount > 0) ...[
                    SizedBox(height: 6.h),
                    _row('ສ່ວນຫຼຸດ', '-${Formatters.money(order.discount)}',
                        color: AppColors.success),
                  ],
                  Divider(height: 18.h),
                  Row(
                    children: [
                      Text('ລວມທັງໝົດ',
                          style: TextStyle(
                              fontSize: 13.sp, fontWeight: FontWeight.w700)),
                      const Spacer(),
                      Text(
                        Formatters.money(order.total),
                        style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (order.history.isNotEmpty) ...[
              SizedBox(height: 12.h),
              _card(
                title: 'ປະຫວັດ',
                child: Column(
                  children: order.history
                      .map(
                        (h) => Padding(
                          padding: EdgeInsets.only(bottom: 10.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 4.h),
                                height: 8.r,
                                width: 8.r,
                                decoration: const BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle),
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      h.note ?? AppColors.statusLabel(h.status),
                                      style: TextStyle(
                                          fontSize: 11.5.sp,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      Formatters.dateTime(h.createdAt),
                                      style: TextStyle(
                                          fontSize: 10.sp,
                                          color: AppColors.textHint),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
            SizedBox(height: 16.h),
            if (order.canConfirmReceived)
              AppButton(
                  label: 'ຢືນຢັນຮັບສິນຄ້າແລ້ວ',
                  icon: Icons.check_rounded,
                  onPressed: controller.confirmReceived),
            if (order.canCancel) ...[
              SizedBox(height: 8.h),
              AppButton(
                  label: 'ຍົກເລີກຄຳສັ່ງຊື້',
                  outlined: true,
                  onPressed: controller.cancel),
            ],
            SizedBox(height: 8.h),
            AppButton(
              label: 'ສອບຖາມຜ່ານແຊັດ',
              outlined: true,
              icon: Icons.chat_bubble_outline_rounded,
              onPressed: controller.openChat,
            ),
          ],
        );
      }),
    );
  }

  Widget _miniStat(String label, String value) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 9.5.sp,
                  color: Colors.white.withValues(alpha: .75))),
          SizedBox(height: 2.h),
          Text(value,
              style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w800,
                  color: Colors.white)),
        ],
      );

  Widget _card({required String title, required Widget child}) => Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(18.r)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700)),
            SizedBox(height: 10.h),
            child,
          ],
        ),
      );

  Widget _row(String label, String value, {Color? color}) => Row(
        children: [
          Text(label,
              style:
                  TextStyle(fontSize: 11.5.sp, color: AppColors.textSecondary)),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: color ?? AppColors.textPrimary),
          ),
        ],
      );
}
