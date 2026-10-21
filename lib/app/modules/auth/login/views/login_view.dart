import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(24.w, 30.h, 24.w, 24.h),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 22.h),
                Center(
                  child: Container(
                    height: 74.r,
                    width: 74.r,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(22.r),
                      boxShadow: [
                        BoxShadow(
                            color: AppColors.primary.withValues(alpha: .3),
                            blurRadius: 24,
                            offset: const Offset(0, 12)),
                      ],
                    ),
                    child: Icon(Icons.directions_run_rounded,
                        color: Colors.white, size: 42.r),
                  ),
                ),
                SizedBox(height: 26.h),
                Center(
                  child: Text(
                    'ເຂົ້າສູ່ລະບົບ',
                    style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary),
                  ),
                ),
                SizedBox(height: 6.h),
                Center(
                  child: Text(
                    'ຍິນດີຕ້ອນຮັບ ! ກະລຸນາເຂົ້າສູ່ລະບົບເພື່ອສືບຕໍ່',
                    style: TextStyle(
                        fontSize: 12.5.sp, color: AppColors.textSecondary),
                  ),
                ),
                SizedBox(height: 30.h),
                AppTextField(
                  controller: controller.identifierController,
                  label: 'ອີເມວ ຫຼື ເບີໂທ',
                  hint: 'you@example.com',
                  icon: Icons.mail_outline_rounded,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'ກະລຸນາປ້ອນອີເມວ ຫຼື ເບີໂທ'
                      : null,
                ),
                SizedBox(height: 16.h),
                Obx(
                  () => AppTextField(
                    controller: controller.passwordController,
                    label: 'ລະຫັດຜ່ານ',
                    hint: '••••••••',
                    icon: Icons.lock_outline_rounded,
                    obscure: controller.obscure.value,
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'ກະລຸນາປ້ອນລະຫັດຜ່ານ' : null,
                  ),
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Obx(
                      () => SizedBox(
                        height: 22.h,
                        width: 22.h,
                        child: Checkbox(
                          value: controller.remember.value,
                          onChanged: (v) =>
                              controller.remember.value = v ?? false,
                          activeColor: AppColors.primary,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.r)),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text('ຈື່ຂ້ອຍໄວ້',
                        style: TextStyle(
                            fontSize: 12.sp, color: AppColors.textSecondary)),
                    const Spacer(),
                    TextButton(
                      onPressed: () => Get.snackbar(
                          'ລືມລະຫັດຜ່ານ', 'ກະລຸນາຕິດຕໍ່ຜູ້ດູແລລະບົບ'),
                      style: TextButton.styleFrom(
                          padding: EdgeInsets.zero, minimumSize: Size.zero),
                      child: Text('ລືມລະຫັດຜ່ານ?',
                          style: TextStyle(
                              fontSize: 12.sp, color: AppColors.primary)),
                    ),
                  ],
                ),
                SizedBox(height: 22.h),
                Obx(
                  () => AppButton(
                    label: 'ເຂົ້າສູ່ລະບົບ',
                    loading: controller.loading.value,
                    onPressed: controller.login,
                  ),
                ),
                SizedBox(height: 18.h),
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Text('ຫຼື',
                          style: TextStyle(
                              fontSize: 11.sp, color: AppColors.textHint)),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Expanded(
                      child: _socialButton(
                        label: 'Google',
                        icon: Icons.g_mobiledata_rounded,
                        color: const Color(0xFFDB4437),
                        onTap: controller.loginWithGoogle,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: _socialButton(
                        label: 'Facebook',
                        icon: Icons.facebook_rounded,
                        color: const Color(0xFF1877F2),
                        onTap: controller.loginWithFacebook,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 22.h),
                Center(
                  child: TextButton(
                    onPressed: () => Get.toNamed(AppRoutes.otp),
                    child: Text(
                      'ເຂົ້າສູ່ລະບົບດ້ວຍເບີໂທ (OTP)',
                      style: TextStyle(
                          fontSize: 12.5.sp, color: AppColors.textSecondary),
                    ),
                  ),
                ),
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: 'ຍັງບໍ່ມີບັນຊີ? ',
                      style: TextStyle(
                          fontSize: 12.5.sp, color: AppColors.textSecondary),
                      children: [
                        TextSpan(
                          text: 'ສະໝັກສະມາຊິກ',
                          style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => Get.toNamed(AppRoutes.register),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _socialButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: AppColors.divider),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 22.r),
            SizedBox(width: 8.w),
            Text(label,
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
