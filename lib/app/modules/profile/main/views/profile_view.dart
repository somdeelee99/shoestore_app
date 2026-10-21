import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/widgets/status_chip.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        final user = controller.user;
        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: controller.fetch,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(20.w, MediaQuery.of(context).padding.top + 24.h, 20.w, 26.h),
                decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
                child: controller.isLoggedIn
                    ? _loggedIn(user)
                    : _guest(),
              ),
              Transform.translate(
                offset: Offset(0, -14.h),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    children: [
                      _statsCard(),
                      SizedBox(height: 12.h),
                      if (controller.isLoggedIn && controller.recentOrders.isNotEmpty) ...[
                        _card(
                          title: 'ຄຳສັ່ງຊື້ຫຼ້າສຸດ',
                          action: 'ເບິ່ງທັງໝົດ',
                          onAction: controller.openOrders,
                          child: Column(
                            children: controller.recentOrders
                                .map(
                                  (order) => InkWell(
                                    onTap: controller.openOrders,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(vertical: 7.h),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '#${order.code}',
                                                  style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                                ),
                                                Text(
                                                  '${Formatters.dateTime(order.createdAt)} · ${Formatters.money(order.total)}',
                                                  style: TextStyle(fontSize: 10.5.sp, color: AppColors.textHint),
                                                ),
                                              ],
                                            ),
                                          ),
                                          StatusChip(status: order.status),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                        SizedBox(height: 12.h),
                      ],
                      _menu(),
                      SizedBox(height: 20.h),
                      if (controller.isLoggedIn)
                        AppButton(
                          label: 'ອອກຈາກລະບົບ',
                          outlined: true,
                          icon: Icons.logout_rounded,
                          onPressed: controller.logout,
                        ),
                      SizedBox(height: 100.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _loggedIn(dynamic user) => Row(
        children: [
          Container(
            height: 62.r,
            width: 62.r,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .2),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: .5), width: 2),
            ),
            child: ClipOval(
              child: user?.avatar != null && user!.avatar!.isNotEmpty
                  ? AppNetworkImage(user.avatar!, fit: BoxFit.cover)
                  : Center(
                      child: Text(
                        user?.initials ?? 'U',
                        style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w800, color: Colors.white),
                      ),
                    ),
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.name ?? 'ຜູ້ໃຊ້',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800, color: Colors.white),
                ),
                SizedBox(height: 2.h),
                Text(
                  user?.phone ?? user?.email ?? '-',
                  style: TextStyle(fontSize: 11.5.sp, color: Colors.white.withValues(alpha: .85)),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: controller.openEdit,
            child: Container(
              padding: EdgeInsets.all(9.r),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .18),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(Icons.edit_outlined, size: 17.r, color: Colors.white),
            ),
          ),
        ],
      );

  Widget _guest() => Column(
        children: [
          Container(
            height: 62.r,
            width: 62.r,
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: .2), shape: BoxShape.circle),
            child: Icon(Icons.person_outline_rounded, size: 30.r, color: Colors.white),
          ),
          SizedBox(height: 12.h),
          Text(
            'ຍິນດີຕ້ອນຮັບ',
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800, color: Colors.white),
          ),
          SizedBox(height: 4.h),
          Text(
            'ເຂົ້າສູ່ລະບົບເພື່ອເບິ່ງຄຳສັ່ງຊື້ ແລະ ສິດທິພິເສດ',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11.sp, color: Colors.white.withValues(alpha: .85)),
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: 'ເຂົ້າສູ່ລະບົບ',
                  height: 42.h,
                  color: Colors.white,
                  textColor: AppColors.primary,
                  onPressed: controller.openLogin,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: AppButton(
                  label: 'ສະໝັກໃຊ້',
                  height: 42.h,
                  outlined: true,
                  color: Colors.white,
                  textColor: Colors.white,
                  onPressed: controller.openRegister,
                ),
              ),
            ],
          ),
        ],
      );

  Widget _statsCard() => Container(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18.r),
          boxShadow: AppSizes.softShadow,
        ),
        child: Row(
          children: [
            _stat('ຄຳສັ່ງຊື້', '${controller.recentOrders.length}', Icons.receipt_long_outlined, controller.openOrders),
            _divider(),
            _stat('ທີ່ຖືກໃຈ', '${controller.wishlistCount.value}', Icons.favorite_border_rounded, controller.openWishlist),
            _divider(),
            _stat('ທີ່ຢູ່', '${controller.addressCount.value}', Icons.location_on_outlined, controller.openAddresses),
          ],
        ),
      );

  Widget _divider() => Container(height: 30.h, width: 1, color: AppColors.divider);

  Widget _stat(String label, String value, IconData icon, VoidCallback onTap) => Expanded(
        child: InkWell(
          onTap: onTap,
          child: Column(
            children: [
              Icon(icon, size: 19.r, color: AppColors.primary),
              SizedBox(height: 5.h),
              Text(value, style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w800)),
              Text(label, style: TextStyle(fontSize: 10.5.sp, color: AppColors.textHint)),
            ],
          ),
        ),
      );

  Widget _menu() => _card(
        title: 'ເມນູ',
        child: Column(
          children: [
            _menuTile(Icons.receipt_long_outlined, 'ຄຳສັ່ງຊື້ຂອງຂ້ອຍ', controller.openOrders),
            _menuTile(Icons.favorite_border_rounded, 'ສິນຄ້າທີ່ຖືກໃຈ', controller.openWishlist),
            _menuTile(Icons.local_offer_outlined, 'ຄູປອງຂອງຂ້ອຍ', controller.openCoupons),
            _menuTile(Icons.location_on_outlined, 'ທີ່ຢູ່ຈັດສົ່ງ', controller.openAddresses),
            _menuTile(Icons.notifications_none_rounded, 'ແຈ້ງເຕືອນ', controller.openNotifications),
            _menuTile(Icons.chat_bubble_outline_rounded, 'ສອບຖາມ / ສະໜັບສະໜູນ', controller.openChat),
            _menuTile(Icons.settings_outlined, 'ການຕັ້ງຄ່າ', controller.openSettings, last: true),
          ],
        ),
      );

  Widget _menuTile(IconData icon, String label, VoidCallback onTap, {bool last = false}) => Column(
        children: [
          InkWell(
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 11.h),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(7.r),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(9.r),
                    ),
                    child: Icon(icon, size: 16.r, color: AppColors.primary),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      label,
                      style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Icon(Icons.chevron_right_rounded, size: 18.r, color: AppColors.textHint),
                ],
              ),
            ),
          ),
          if (!last) Divider(height: 1, color: AppColors.divider),
        ],
      );

  Widget _card({
    required String title,
    String? action,
    VoidCallback? onAction,
    required Widget child,
  }) =>
      Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18.r),
          boxShadow: AppSizes.softShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(title, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700)),
                const Spacer(),
                if (action != null)
                  GestureDetector(
                    onTap: onAction,
                    child: Text(
                      action,
                      style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w600, color: AppColors.primary),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 8.h),
            child,
          ],
        ),
      );
}
