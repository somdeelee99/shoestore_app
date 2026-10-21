import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/services/asset_service.dart';
import '../../../core/widgets/app_network_image.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/product_card.dart';
import '../../../core/widgets/search_field.dart';
import '../../../core/widgets/section_header.dart';
import '../../../data/models/product_model.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../notifications/bindings/notifications_binding.dart';
import '../../notifications/views/notifications_view.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Obx(() {
          if (controller.loading.value && controller.home.value == null) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }
          if (controller.error.value != null && controller.home.value == null) {
            return ErrorState(message: controller.error.value!, onRetry: controller.fetch);
          }
          final home = controller.home.value;
          if (home == null) return const SizedBox.shrink();

          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: controller.fetch,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _header(home.storeName)),
                SliverToBoxAdapter(child: _searchBar()),
                SliverToBoxAdapter(child: _banner(home)),
                SliverToBoxAdapter(child: _categories(home)),
                SliverToBoxAdapter(
                  child: _productSection(
                    title: 'ສິນຄ້າແນະນຳ',
                    products: home.featured,
                    onSeeAll: () => controller.openAll(section: 'ສິນຄ້າແນະນຳ'),
                  ),
                ),
                SliverToBoxAdapter(
                  child: _promoStrip(),
                ),
                SliverToBoxAdapter(
                  child: _productSection(
                    title: 'ມາໃໝ່',
                    products: home.newArrivals,
                    onSeeAll: () => controller.openAll(section: 'ມາໃໝ່'),
                  ),
                ),
                SliverToBoxAdapter(
                  child: _productSection(
                    title: 'ຂາຍດີ',
                    products: home.bestSellers,
                    onSeeAll: () => controller.openAll(section: 'ຂາຍດີ'),
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: 90.h)),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _header(String storeName) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 4.h),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.location_on_rounded, size: 13.r, color: AppColors.primary),
                    SizedBox(width: 3.w),
                    Text(
                      'ນະຄອນຫຼວງວຽງຈັນ',
                      style: TextStyle(fontSize: 10.5.sp, color: AppColors.textSecondary),
                    ),
                    Icon(Icons.keyboard_arrow_down_rounded, size: 13.r, color: AppColors.textSecondary),
                  ],
                ),
                SizedBox(height: 2.h),
                Text(
                  'ສະບາຍດີ, ${controller.userName} 👋',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                ),
              ],
            ),
          ),
          _iconButton(
            icon: Icons.notifications_none_rounded,
            onTap: () {
              NotificationsBinding().dependencies();
              Get.to(() => const NotificationsView());
            },
          ),
          SizedBox(width: 8.w),
          Obx(
            () => _iconButton(
              icon: Icons.shopping_bag_outlined,
              badge: Get.find<CartController>().cart.value?.itemCount ?? 0,
              onTap: () => Get.toNamed(AppRoutes.cart),
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconButton({required IconData icon, int? badge, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 42.r,
            width: 42.r,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(13.r),
              boxShadow: AppSizes.softShadow,
            ),
            child: Icon(icon, size: 20.r, color: AppColors.textPrimary),
          ),
          if ((badge ?? 0) > 0)
            Positioned(
              right: -2,
              top: -2,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(999)),
                child: Text(
                  '$badge',
                  style: TextStyle(fontSize: 9.sp, fontWeight: FontWeight.w700, color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _searchBar() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 4.h),
      child: SearchField(
        hint: 'ຄົ້ນຫາເກີບ, ແບຣນ, ລຸ້ນ...',
        onSubmitted: controller.submitSearch,
        readOnly: true,
        onTap: () => controller.openAll(section: 'ສິນຄ້າທັງໝົດ'),
        onFilter: () => controller.openAll(section: 'ສິນຄ້າທັງໝົດ'),
      ),
    );
  }

  Widget _banner(dynamic home) {
    return SizedBox(
      height: 168.h,
      child: PageView.builder(
        itemCount: home.banners.isEmpty ? 1 : home.banners.length,
        onPageChanged: (i) => controller.bannerIndex.value = i,
        itemBuilder: (_, i) {
          final image = home.banners.isEmpty
              ? 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=1200&q=80'
              : AssetService.url(home.banners[i].image as String?);
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22.r),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(image, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: AppColors.secondary)),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.black.withValues(alpha: .65), Colors.transparent],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(18.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'NEW SEASON',
                          style: TextStyle(fontSize: 10.sp, color: Colors.white70, letterSpacing: 3),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          home.banners.isEmpty ? 'SHOE STORE' : (home.banners[i].title as String).toUpperCase(),
                          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w900, color: Colors.white),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          'ສ່ວນຫຼຸດສູງເຖິງ 30%',
                          style: TextStyle(fontSize: 11.sp, color: Colors.white.withValues(alpha: .85)),
                        ),
                        SizedBox(height: 12.h),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                          decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(9.r)),
                          child: Text(
                            'ຊື້ດຽວນີ້',
                            style: TextStyle(fontSize: 10.5.sp, fontWeight: FontWeight.w700, color: Colors.white),
                          ),
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
    );
  }

  Widget _categories(dynamic home) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: 'ໝວດໝູ່', onAction: () => Get.toNamed(AppRoutes.categories)),
          SizedBox(
            height: 84.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: home.categories.length,
              separatorBuilder: (_, __) => SizedBox(width: 10.w),
              itemBuilder: (_, i) {
                final category = home.categories[i];
                return GestureDetector(
                  onTap: () => controller.openCategory(category.id, category.name),
                  child: Column(
                    children: [
                      Container(
                        height: 56.r,
                        width: 56.r,
                        padding: EdgeInsets.all(2.r),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(18.r),
                        ),
                        child: AppNetworkImage(category.image, radius: 16, width: 56.r, height: 56.r),
                      ),
                      SizedBox(height: 6.h),
                      SizedBox(
                        width: 64.w,
                        child: Text(
                          category.name,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 10.5.sp, color: AppColors.textSecondary),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _productSection({
    required String title,
    required List<ProductModel> products,
    VoidCallback? onSeeAll,
  }) {
    if (products.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: title, onAction: onSeeAll),
          SizedBox(
            height: 232.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              separatorBuilder: (_, __) => SizedBox(width: 12.w),
              itemBuilder: (_, i) => ProductCard(
                product: products[i],
                width: 152.w,
                onTap: () => controller.openProduct(products[i]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _promoStrip() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 4.h),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ຮັບສ່ວນຫຼຸດ 10%',
                    style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w800, color: Colors.white),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'ໃຊ້ລະຫັດ WELCOME10 ສຳລັບຄຳສັ່ງຊື້ທຳອິດ',
                    style: TextStyle(fontSize: 10.5.sp, color: Colors.white.withValues(alpha: .9)),
                  ),
                ],
              ),
            ),
            Icon(Icons.local_offer_rounded, color: Colors.white.withValues(alpha: .9), size: 34.r),
          ],
        ),
      ),
    );
  }
}
