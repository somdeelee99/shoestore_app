import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_bar_widget.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/loading_list.dart';
import '../../../../core/widgets/product_card.dart';
import '../../../../core/widgets/status_chip.dart';
import '../controllers/orders_controller.dart';

class OrdersView extends GetView<OrdersController> {
  const OrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBarWidget(title: 'ຄຳສັ່ງຊື້ຂອງຂ້ອຍ', showBack: false),
      body: Obx(() {
        if (!controller.isLoggedIn) {
          return EmptyState(
            icon: Icons.lock_outline_rounded,
            title: 'ກະລຸນາເຂົ້າສູ່ລະບົບ',
            description: 'ເພື່ອເບິ່ງປະຫວັດການສັ່ງຊື້',
            action: AppButton(label: 'ເຂົ້າສູ່ລະບົບ', expanded: false, onPressed: () => Get.toNamed(AppRoutes.login)),
          );
        }

        return Column(
          children: [
            Container(
              color: Colors.white,
              height: 44.h,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                children: controller.tabs.map((tab) {
                  final selected = controller.status.value == tab['id'];
                  return GestureDetector(
                    onTap: () => controller.selectTab(tab['id']!),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 14.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            tab['label']!,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                              color: selected ? AppColors.primary : AppColors.textSecondary,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Container(
                            height: 2.5.h,
                            width: selected ? 22.w : 0,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(2.r),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            Expanded(
              child: controller.loading.value && controller.orders.isEmpty
                  ? Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Column(children: const [LoadingCard(), LoadingCard(), LoadingCard()]),
                    )
                  : controller.orders.isEmpty
                      ? const EmptyState(
                          icon: Icons.receipt_long_outlined,
                          title: 'ຍັງບໍ່ມີຄຳສັ່ງຊື້',
                          description: 'ເລີ່ມສັ່ງຊື້ເກີບຄູ່ທີ່ທ່ານມັກໄດ້ເລີຍ',
                        )
                      : RefreshIndicator(
                          color: AppColors.primary,
                          onRefresh: controller.fetch,
                          child: ListView.builder(
                            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 100.h),
                            itemCount: controller.orders.length,
                            itemBuilder: (_, i) {
                              final order = controller.orders[i];
                              return GestureDetector(
                                onTap: () => controller.open(order),
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 12.h),
                                  padding: EdgeInsets.all(14.w),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(18.r),
                                    boxShadow: AppSizes.softShadow,
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            '#${order.code}',
                                            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w800),
                                          ),
                                          const Spacer(),
                                          StatusChip(status: order.status),
                                        ],
                                      ),
                                      SizedBox(height: 4.h),
                                      Row(
                                        children: [
                                          const Icon(Icons.schedule_rounded, size: 12, color: AppColors.textHint),
                                          SizedBox(width: 4.w),
                                          Text(
                                            Formatters.dateTime(order.createdAt),
                                            style: TextStyle(fontSize: 10.5.sp, color: AppColors.textHint),
                                          ),
                                        ],
                                      ),
                                      Divider(height: 18.h),
                                      ...order.items.take(2).map(
                                            (item) => Padding(
                                              padding: EdgeInsets.only(bottom: 8.h),
                                              child: ProductTile(
                                                image: item.image,
                                                title: item.name,
                                                subtitle: 'ຂະໜາດ ${item.size ?? '-'} · x${item.quantity}',
                                                price: Formatters.money(item.price),
                                                size: 48,
                                              ),
                                            ),
                                          ),
                                      if (order.items.length > 2)
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            '+ ອີກ ${order.items.length - 2} ລາຍການ',
                                            style: TextStyle(fontSize: 10.5.sp, color: AppColors.textHint),
                                          ),
                                        ),
                                      Divider(height: 18.h),
                                      Row(
                                        children: [
                                          Text(
                                            '${order.totalQuantity} ລາຍການ',
                                            style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary),
                                          ),
                                          const Spacer(),
                                          Text(
                                            'ລວມ ',
                                            style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary),
                                          ),
                                          Text(
                                            Formatters.money(order.total),
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w900,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10.h),
                                      Row(
                                        children: [
                                          if (order.canCancel)
                                            Expanded(
                                              child: AppButton(
                                                label: 'ຍົກເລີກ',
                                                outlined: true,
                                                height: 40.h,
                                                onPressed: () => controller.cancel(order),
                                              ),
                                            ),
                                          if (order.canCancel) SizedBox(width: 8.w),
                                          Expanded(
                                            child: AppButton(
                                              label: 'ຕິດຕາມ',
                                              height: 40.h,
                                              onPressed: () => controller.track(order),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
            ),
          ],
        );
      }),
    );
  }
}
