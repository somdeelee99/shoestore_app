import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/app_network_image.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/search_field.dart';
import '../controllers/categories_controller.dart';

class CategoriesView extends GetView<CategoriesController> {
  const CategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Obx(() {
          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: controller.fetch,
            child: ListView(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 100.h),
              children: [
                Text('ໝວດໝູ່ສິນຄ້າ', style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w800)),
                SizedBox(height: 4.h),
                Text(
                  'ເລືອກເບິ່ງເກີບຕາມປະເພດ ຫຼື ແບຣນທີ່ທ່ານມັກ',
                  style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
                ),
                SizedBox(height: 16.h),
                SearchField(
                  readOnly: true,
                  onTap: controller.openAll,
                  hint: 'ຄົ້ນຫາສິນຄ້າ...',
                ),
                SizedBox(height: 20.h),
                if (controller.loading.value && controller.categories.isEmpty)
                  const Center(child: Padding(padding: EdgeInsets.all(40), child: CircularProgressIndicator(color: AppColors.primary)))
                else ...[
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.categories.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12.h,
                      crossAxisSpacing: 12.w,
                      childAspectRatio: 1.15,
                    ),
                    itemBuilder: (_, i) {
                      final category = controller.categories[i];
                      return GestureDetector(
                        onTap: () => controller.openCategory(category),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                child: AppNetworkImage(
                                  category.image,
                                  radius: 20,
                                  width: double.infinity,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        category.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    Text(
                                      '${category.productCount}',
                                      style: TextStyle(fontSize: 10.sp, color: AppColors.textHint),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 24.h),
                  Text('ແບຣນຍອດນິຍົມ', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700)),
                  SizedBox(height: 12.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: controller.brands
                        .map(
                          (brand) => GestureDetector(
                            onTap: () => controller.openBrand(brand),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 9.h),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(999),
                                border: Border.all(color: AppColors.divider),
                              ),
                              child: Text(brand, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600)),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  if (controller.categories.isEmpty)
                    const EmptyState(title: 'ຍັງບໍ່ມີໝວດໝູ່', description: 'ກະລຸນາລອງໃໝ່ພາຍຫຼັງ'),
                ],
              ],
            ),
          );
        }),
      ),
    );
  }
}
