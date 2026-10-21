import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/widgets/product_card.dart';
import '../../../../core/widgets/quantity_stepper.dart';
import '../controllers/product_detail_controller.dart';

class ProductDetailView extends GetView<ProductDetailController> {
  const ProductDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        final product = controller.product.value;
        if (controller.loading.value && product == null) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        }
        if (product == null) {
          return const Center(child: Text('ບໍ່ພົບສິນຄ້າ'));
        }

        final images = product.images.isNotEmpty ? product.images : [product.thumbnail ?? ''];

        return Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 340.h,
                    pinned: true,
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.textPrimary,
                    leading: _circleButton(Icons.arrow_back_rounded, () => Get.back()),
                    actions: [
                      _circleButton(
                        controller.favorite.value ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        controller.toggleFavorite,
                        color: controller.favorite.value ? AppColors.primary : AppColors.textPrimary,
                      ),
                      SizedBox(width: 12.w),
                    ],
                    flexibleSpace: FlexibleSpaceBar(
                      background: Stack(
                        children: [
                          PageView.builder(
                            itemCount: images.length,
                            onPageChanged: (i) => controller.imageIndex.value = i,
                            itemBuilder: (_, i) => Container(
                              color: AppColors.surfaceAlt,
                              child: AppNetworkImage(images[i], radius: 0, width: double.infinity),
                            ),
                          ),
                          Positioned(
                            bottom: 14.h,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                images.length,
                                (i) => AnimatedContainer(
                                  duration: const Duration(milliseconds: 220),
                                  margin: EdgeInsets.symmetric(horizontal: 2.5.w),
                                  height: 6.h,
                                  width: controller.imageIndex.value == i ? 18.w : 6.w,
                                  decoration: BoxDecoration(
                                    color: controller.imageIndex.value == i ? AppColors.primary : Colors.white70,
                                    borderRadius: BorderRadius.circular(3.r),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              if (product.brand != null)
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 4.h),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryLight,
                                    borderRadius: BorderRadius.circular(7.r),
                                  ),
                                  child: Text(
                                    product.brand!,
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              const Spacer(),
                              Icon(Icons.star_rounded, size: 15.r, color: AppColors.accent),
                              SizedBox(width: 3.w),
                              Text(
                                '${product.rating.toStringAsFixed(1)} (${product.reviewCount})',
                                style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            product.name,
                            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w800, height: 1.3),
                          ),
                          SizedBox(height: 8.h),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                Formatters.money(product.price),
                                style: TextStyle(fontSize: 21.sp, fontWeight: FontWeight.w900, color: AppColors.primary),
                              ),
                              if (product.hasDiscount) ...[
                                SizedBox(width: 8.w),
                                Text(
                                  Formatters.money(product.comparePrice),
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: AppColors.textHint,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                                SizedBox(width: 6.w),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(6.r),
                                  ),
                                  child: Text(
                                    '-${product.discountPercent}%',
                                    style: TextStyle(fontSize: 9.5.sp, color: Colors.white, fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          SizedBox(height: 14.h),
                          Row(
                            children: [
                              Icon(Icons.verified_rounded, size: 14.r, color: AppColors.success),
                              SizedBox(width: 4.w),
                              Text(
                                product.inStock ? 'ມີສິນຄ້າ' : 'ສິນຄ້າໝົດ',
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: product.inStock ? AppColors.success : AppColors.danger,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 14.w),
                              Text(
                                'ຂາຍແລ້ວ ${product.soldCount} ຄູ່',
                                style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                          Divider(height: 30.h),
                          if (product.sizes.isNotEmpty) ...[
                            Text('ຂະໜາດ', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700)),
                            SizedBox(height: 10.h),
                            Wrap(
                              spacing: 8.w,
                              runSpacing: 8.h,
                              children: product.sizes.map((size) {
                                final selected = controller.selectedSize.value == size;
                                final available = controller.isSizeAvailable(size);
                                return GestureDetector(
                                  onTap: available ? () => controller.selectSize(size) : null,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                                    decoration: BoxDecoration(
                                      color: selected ? AppColors.primary : AppColors.surfaceAlt,
                                      borderRadius: BorderRadius.circular(11.r),
                                      border: Border.all(
                                        color: selected ? AppColors.primary : AppColors.divider,
                                      ),
                                    ),
                                    child: Text(
                                      size,
                                      style: TextStyle(
                                        fontSize: 12.5.sp,
                                        fontWeight: FontWeight.w700,
                                        color: selected
                                            ? Colors.white
                                            : available
                                                ? AppColors.textPrimary
                                                : AppColors.textHint,
                                        decoration: available ? null : TextDecoration.lineThrough,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            SizedBox(height: 18.h),
                          ],
                          if (product.colors.isNotEmpty) ...[
                            Text('ສີ', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700)),
                            SizedBox(height: 10.h),
                            Wrap(
                              spacing: 10.w,
                              children: product.colors.map((color) {
                                final selected = controller.selectedColor.value == color.name;
                                return GestureDetector(
                                  onTap: () => controller.selectColor(color.name),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                                    decoration: BoxDecoration(
                                      color: selected ? AppColors.primaryLight : Colors.white,
                                      borderRadius: BorderRadius.circular(11.r),
                                      border: Border.all(
                                        color: selected ? AppColors.primary : AppColors.divider,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 14.r,
                                          width: 14.r,
                                          decoration: BoxDecoration(
                                            color: _parseColor(color.hex),
                                            shape: BoxShape.circle,
                                            border: Border.all(color: AppColors.divider),
                                          ),
                                        ),
                                        SizedBox(width: 6.w),
                                        Text(color.name, style: TextStyle(fontSize: 11.5.sp)),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            SizedBox(height: 18.h),
                          ],
                          Row(
                            children: [
                              Text('ຈຳນວນ', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700)),
                              const Spacer(),
                              QuantityStepper(
                                value: controller.quantity.value,
                                max: controller.maxQuantity,
                                onChanged: controller.setQuantity,
                              ),
                            ],
                          ),
                          Divider(height: 30.h),
                          Row(
                            children: [
                              _tabButton('ລາຍລະອຽດ', 0),
                              _tabButton('ຄຸນສົມບັດ', 1),
                              _tabButton('ຣີວິວ', 2),
                            ],
                          ),
                          SizedBox(height: 14.h),
                          if (controller.tabIndex.value == 0)
                            Text(
                              product.description ?? 'ບໍ່ມີລາຍລະອຽດ',
                              style: TextStyle(fontSize: 12.5.sp, height: 1.7, color: AppColors.textSecondary),
                            )
                          else if (controller.tabIndex.value == 1)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _specRow('SKU', product.sku ?? '-'),
                                _specRow('ແບຣນ', product.brand ?? '-'),
                                _specRow('ໝວດໝູ່', product.category?.name ?? '-'),
                                _specRow('ສະຕັອກ', '${product.totalStock} ຄູ່'),
                              ],
                            )
                          else
                            Column(
                              children: product.reviews.isEmpty
                                  ? [
                                      Text(
                                        'ຍັງບໍ່ມີຣີວິວ',
                                        style: TextStyle(fontSize: 12.sp, color: AppColors.textHint),
                                      ),
                                    ]
                                  : product.reviews.map((review) {
                                      return Container(
                                        margin: EdgeInsets.only(bottom: 10.h),
                                        padding: EdgeInsets.all(12.w),
                                        decoration: BoxDecoration(
                                          color: AppColors.surfaceAlt,
                                          borderRadius: BorderRadius.circular(14.r),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  review.userName ?? 'ລູກຄ້າ',
                                                  style: TextStyle(fontSize: 11.5.sp, fontWeight: FontWeight.w700),
                                                ),
                                                const Spacer(),
                                                Row(
                                                  children: List.generate(
                                                    5,
                                                    (i) => Icon(
                                                      Icons.star_rounded,
                                                      size: 12.r,
                                                      color: i < review.rating ? AppColors.accent : AppColors.divider,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            if (review.comment != null) ...[
                                              SizedBox(height: 4.h),
                                              Text(
                                                review.comment!,
                                                style: TextStyle(fontSize: 11.5.sp, color: AppColors.textSecondary),
                                              ),
                                            ],
                                          ],
                                        ),
                                      );
                                    }).toList(),
                            ),
                          SizedBox(height: 20.h),
                          if (controller.related.isNotEmpty) ...[
                            Text('ສິນຄ້າທີ່ຄ້າຍກັນ', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700)),
                            SizedBox(height: 12.h),
                            SizedBox(
                              height: 220.h,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: controller.related.length,
                                separatorBuilder: (_, __) => SizedBox(width: 12.w),
                                itemBuilder: (_, i) => ProductCard(
                                  product: controller.related[i],
                                  width: 150.w,
                                  showRating: false,
                                  onTap: () => controller.openProduct(controller.related[i]),
                                ),
                              ),
                            ),
                          ],
                          SizedBox(height: 20.h),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 16.h),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .06), blurRadius: 20, offset: const Offset(0, -4))],
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: controller.toggleFavorite,
                      child: Container(
                        height: 52.h,
                        width: 52.h,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceAlt,
                          borderRadius: BorderRadius.circular(AppSizes.radius),
                        ),
                        child: Icon(
                          controller.favorite.value ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                          color: controller.favorite.value ? AppColors.primary : AppColors.textSecondary,
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: AppButton(
                        label: 'ເພີ່ມໃນກະຕ່າ',
                        outlined: true,
                        loading: controller.loading.value,
                        onPressed: () => controller.addToCart(),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: AppButton(
                        label: 'ຊື້ທັນທີ',
                        onPressed: controller.buyNow,
                      ),
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

  Widget _tabButton(String label, int index) {
    final selected = controller.tabIndex.value == index;
    return Padding(
      padding: EdgeInsets.only(right: 18.w),
      child: GestureDetector(
        onTap: () => controller.tabIndex.value = index,
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12.5.sp,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 4.h),
            Container(
              height: 2.5.h,
              width: selected ? 24.w : 0,
              decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(2.r)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _specRow(String label, String value) => Padding(
        padding: EdgeInsets.only(bottom: 8.h),
        child: Row(
          children: [
            SizedBox(
              width: 100.w,
              child: Text(label, style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary)),
            ),
            Expanded(
              child: Text(value, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      );

  Widget _circleButton(IconData icon, VoidCallback onTap, {Color color = AppColors.textPrimary}) {
    return Padding(
      padding: EdgeInsets.all(6.r),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 38.r,
          width: 38.r,
          decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: AppSizes.softShadow),
          child: Icon(icon, size: 19.r, color: color),
        ),
      ),
    );
  }

  Color _parseColor(String? hex) {
    if (hex == null || hex.isEmpty) return AppColors.textSecondary;
    final value = hex.replaceFirst('#', '');
    return Color(int.parse('FF$value', radix: 16));
  }
}
