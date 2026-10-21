import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_bar_widget.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/loading_list.dart';
import '../controllers/wishlist_controller.dart';

class WishlistView extends GetView<WishlistController> {
  const WishlistView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBarWidget(title: 'ສິນຄ້າທີ່ຖືກໃຈ'),
      body: Obx(() {
        if (controller.loading.value && controller.items.isEmpty) {
          return Padding(padding: EdgeInsets.all(16.w), child: const LoadingGrid(count: 4));
        }
        if (controller.items.isEmpty) {
          return const EmptyState(
            icon: Icons.favorite_border_rounded,
            title: 'ຍັງບໍ່ມີສິນຄ້າທີ່ຖືກໃຈ',
            description: 'ກົດຫົວໃຈໃສ່ສິນຄ້າທີ່ທ່ານມັກ ເພື່ອເກັບໄວ້ທີ່ນີ້',
          );
        }
        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: controller.fetch,
          child: ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: controller.items.length,
            itemBuilder: (_, i) {
              final item = controller.items[i];
              return Container(
                margin: EdgeInsets.only(bottom: 12.h),
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16.r)),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => controller.openProduct(item),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: SizedBox(
                          height: 76.r,
                          width: 76.r,
                          child: AppNetworkImage(item.thumbnail),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () => controller.openProduct(item),
                            child: Text(
                              item.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w600, height: 1.35),
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Row(
                            children: [
                              const Icon(Icons.star_rounded, size: 12, color: AppColors.accent),
                              SizedBox(width: 3.w),
                              Text(
                                item.rating.toStringAsFixed(1),
                                style: TextStyle(fontSize: 10.sp, color: AppColors.textHint),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          Row(
                            children: [
                              Text(
                                Formatters.money(item.price),
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primary,
                                ),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () => controller.remove(item),
                                child: Icon(Icons.delete_outline_rounded, size: 18.r, color: AppColors.textHint),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          AppButton(
                            label: 'ເພີ່ມໃສ່ກະຕ່າ',
                            height: 34.h,
                            icon: Icons.shopping_cart_outlined,
                            onPressed: () => controller.addToCart(item),
                          ),
                        ],
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
