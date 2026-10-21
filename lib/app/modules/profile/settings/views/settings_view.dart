import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_bar_widget.dart';
import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppBarWidget(title: 'ການຕັ້ງຄ່າ'),
      body: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          if (controller.isLoggedIn) ...[
            _group('ບັນຊີ', [
              _tile(Icons.person_outline_rounded, 'ແກ້ໄຂໂປຣໄຟລ໌', controller.openEditProfile),
              _tile(Icons.location_on_outlined, 'ຈັດການທີ່ຢູ່', controller.openAddresses),
              _tile(Icons.lock_outline_rounded, 'ປ່ຽນລະຫັດຜ່ານ', controller.changePassword),
            ]),
            SizedBox(height: 14.h),
          ],
          _group('ການແຈ້ງເຕືອນ', [
            Obx(
              () => _switchTile(
                Icons.notifications_none_rounded,
                'ແຈ້ງເຕືອນຄຳສັ່ງຊື້',
                controller.pushEnabled.value,
                controller.togglePush,
              ),
            ),
            Obx(
              () => _switchTile(
                Icons.campaign_outlined,
                'ໂປຣໂມຊັ່ນ ແລະ ຂ່າວສານ',
                controller.promoEnabled.value,
                controller.togglePromo,
              ),
            ),
            _tile(Icons.inbox_outlined, 'ກ່ອງແຈ້ງເຕືອນ', controller.openNotifications, last: true),
          ]),
          SizedBox(height: 14.h),
          _group('ການສະແດງຜົນ', [
            Obx(
              () => Row(
                children: [
                  SizedBox(
                    width: 110.w,
                    child: Text('ພາສາ', style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w500)),
                  ),
                  const Spacer(),
                  Obx(
                    () => Row(
                      children: [
                        _langChip('ລາວ', 'lo'),
                        SizedBox(width: 6.w),
                        _langChip('EN', 'en'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Obx(() => _switchTile(Icons.dark_mode_outlined, 'ໂໝດມືດ', controller.darkMode.value, controller.toggleDark)),
          ]),
          SizedBox(height: 14.h),
          _group('ຂໍ້ມູນເພີ່ມເຕີມ', [
            _tile(Icons.info_outline_rounded, 'ກ່ຽວກັບຮ້ານ', controller.about),
            _tile(Icons.privacy_tip_outlined, 'ນະໂຍບາຍຄວາມເປັນສ່ວນຕົວ', controller.about),
            _tile(Icons.description_outlined, 'ເງື່ອນໄຂການໃຊ້ບໍລິການ', controller.about, last: true),
          ]),
          if (controller.isLoggedIn) ...[
            SizedBox(height: 20.h),
            InkWell(
              onTap: controller.logout,
              borderRadius: BorderRadius.circular(14.r),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 14.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Center(
                  child: Text(
                    'ອອກຈາກລະບົບ',
                    style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700, color: AppColors.danger),
                  ),
                ),
              ),
            ),
          ],
          SizedBox(height: 24.h),
          Center(
            child: Text(
              'ShoeStore v1.0.0',
              style: TextStyle(fontSize: 10.5.sp, color: AppColors.textHint),
            ),
          ),
        ],
      ),
    );
  }

  Widget _group(String title, List<Widget> children) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
            child: Text(
              title,
              style: TextStyle(fontSize: 11.5.sp, fontWeight: FontWeight.w700, color: AppColors.textHint),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16.r)),
            child: Column(children: children),
          ),
        ],
      );

  Widget _tile(IconData icon, String label, VoidCallback onTap, {bool last = false}) => Column(
        children: [
          InkWell(
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 13.h),
              child: Row(
                children: [
                  Icon(icon, size: 17.r, color: AppColors.textSecondary),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(label, style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w500)),
                  ),
                  Icon(Icons.chevron_right_rounded, size: 18.r, color: AppColors.textHint),
                ],
              ),
            ),
          ),
          if (!last) Divider(height: 1, color: AppColors.divider),
        ],
      );

  Widget _switchTile(IconData icon, String label, bool value, ValueChanged<bool> onChanged) => Padding(
        padding: EdgeInsets.symmetric(vertical: 4.h),
        child: Row(
          children: [
            Icon(icon, size: 17.r, color: AppColors.textSecondary),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(label, style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w500)),
            ),
            Switch(
              value: value,
              activeThumbColor: AppColors.primary,
              onChanged: onChanged,
            ),
          ],
        ),
      );

  Widget _langChip(String label, String code) {
    final selected = controller.language.value == code;
    return GestureDetector(
      onTap: () => controller.setLanguage(code),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.surfaceAlt,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w700,
            color: selected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
