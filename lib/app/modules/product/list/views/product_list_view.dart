import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_bar_widget.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/loading_list.dart';
import '../../../../core/widgets/product_card.dart';
import '../controllers/product_list_controller.dart';

class ProductListView extends GetView<ProductListController> {
  const ProductListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBarWidget(
        title: controller.title.value,
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_rounded),
            onPressed: () => _showFilterSheet(context),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.loading.value && controller.products.isEmpty) {
          return const LoadingGrid(count: 6);
        }
        if (controller.error.value != null && controller.products.isEmpty) {
          return ErrorState(message: controller.error.value!, onRetry: controller.fetch);
        }
        if (controller.products.isEmpty) {
          return const EmptyState(
            icon: Icons.search_off_rounded,
            title: 'ບໍ່ພົບສິນຄ້າ',
            description: 'ລອງປ່ຽນຄຳຄົ້ນຫາ ຫຼື ຕົວກອງ',
          );
        }
        return Column(
          children: [
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              child: Row(
                children: [
                  Text(
                    'ພົບ ${controller.products.length} ລາຍການ',
                    style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => _showSortSheet(context),
                    child: Row(
                      children: [
                        Text(
                          controller.sortLabel,
                          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: AppColors.primary),
                        ),
                        Icon(Icons.swap_vert_rounded, size: 15.r, color: AppColors.primary),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (controller.selectedSizes.isNotEmpty)
              SizedBox(
                height: 42.h,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                  children: controller.selectedSizes
                      .map(
                        (s) => Padding(
                          padding: EdgeInsets.only(right: 6.w),
                          child: Chip(
                            label: Text('ເບີ $s', style: TextStyle(fontSize: 11.sp)),
                            onDeleted: () => controller.toggleSize(s),
                            backgroundColor: AppColors.primaryLight,
                            deleteIconColor: AppColors.primary,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            Expanded(
              child: RefreshIndicator(
                color: AppColors.primary,
                onRefresh: controller.fetch,
                child: GridView.builder(
                  padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
                  itemCount: controller.products.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12.h,
                    crossAxisSpacing: 12.w,
                    childAspectRatio: .66,
                  ),
                  itemBuilder: (_, i) => ProductCard(
                    product: controller.products[i],
                    onTap: () => controller.openProduct(controller.products[i]),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  void _showSortSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ຈັດລຳດັບຕາມ', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700)),
            SizedBox(height: 12.h),
            ...controller.sortOptions.map(
              (option) => Obx(
                () => RadioListTile<String>(
                  value: option,
                  groupValue: controller.sortBy.value,
                  onChanged: (value) {
                    controller.setSort(value!);
                    Get.back();
                  },
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  activeColor: AppColors.primary,
                  title: Text(
                    option == 'newest'
                        ? 'ມາໃໝ່'
                        : option == 'price-asc'
                            ? 'ລາຄາຕ່ຳ → ສູງ'
                            : option == 'price-desc'
                                ? 'ລາຄາສູງ → ຕ່ຳ'
                                : option == 'best-selling'
                                    ? 'ຂາຍດີ'
                                    : 'ຄະແນນສູງ',
                    style: TextStyle(fontSize: 13.sp),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24.r))),
    );
  }

  void _showFilterSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('ຕົວກອງ', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700)),
                const Spacer(),
                TextButton(onPressed: controller.resetFilters, child: const Text('ລ້າງ')),
              ],
            ),
            SizedBox(height: 8.h),
            Text('ຂະໜາດ', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
            SizedBox(height: 10.h),
            Obx(
              () => Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: controller.sizeOptions
                    .map(
                      (size) => GestureDetector(
                        onTap: () => controller.toggleSize(size),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 9.h),
                          decoration: BoxDecoration(
                            color: controller.selectedSizes.contains(size) ? AppColors.primary : AppColors.surfaceAlt,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Text(
                            size,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: controller.selectedSizes.contains(size) ? Colors.white : AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            SizedBox(height: 20.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: () => Get.back(), child: const Text('ເບິ່ງຜົນລັບ')),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24.r))),
    );
  }
}
