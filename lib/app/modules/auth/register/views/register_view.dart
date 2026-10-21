import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 24.h),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ສ້າງບັນຊີໃໝ່',
                  style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w800),
                ),
                SizedBox(height: 6.h),
                Text(
                  'ສະໝັກສະມາຊິກເພື່ອຮັບສ່ວນຫຼຸດ ແລະ ຕິດຕາມຄຳສັ່ງຊື້',
                  style: TextStyle(fontSize: 12.5.sp, color: AppColors.textSecondary),
                ),
                SizedBox(height: 28.h),
                AppTextField(
                  controller: controller.nameController,
                  label: 'ຊື່ ແລະ ນາມສະກຸນ',
                  hint: 'ສົມໃຈ ວັນນະສິນ',
                  icon: Icons.person_outline_rounded,
                  validator: (v) => Validators.required(v, 'ຊື່'),
                ),
                SizedBox(height: 16.h),
                AppTextField(
                  controller: controller.emailController,
                  label: 'ອີເມວ',
                  hint: 'you@example.com',
                  icon: Icons.mail_outline_rounded,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.email,
                ),
                SizedBox(height: 16.h),
                AppTextField(
                  controller: controller.phoneController,
                  label: 'ເບີໂທ',
                  hint: '020 5555 1234',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  validator: Validators.phone,
                ),
                SizedBox(height: 16.h),
                AppTextField(
                  controller: controller.passwordController,
                  label: 'ລະຫັດຜ່ານ',
                  hint: 'ຢ່າງໜ້ອຍ 6 ໂຕອັກສອນ',
                  icon: Icons.lock_outline_rounded,
                  obscure: true,
                  validator: Validators.password,
                ),
                SizedBox(height: 16.h),
                AppTextField(
                  controller: controller.confirmController,
                  label: 'ຢືນຢັນລະຫັດຜ່ານ',
                  hint: '••••••••',
                  icon: Icons.lock_outline_rounded,
                  obscure: true,
                  validator: (v) => Validators.confirmPassword(v, controller.passwordController.text),
                ),
                SizedBox(height: 16.h),
                Obx(
                  () => Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 22.h,
                        width: 22.h,
                        child: Checkbox(
                          value: controller.accepted.value,
                          onChanged: (v) => controller.accepted.value = v ?? false,
                          activeColor: AppColors.primary,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.r)),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            text: 'ຂ້ອຍຍອມຮັບ ',
                            style: TextStyle(fontSize: 11.5.sp, color: AppColors.textSecondary, height: 1.5),
                            children: [
                              TextSpan(
                                text: 'ເງື່ອນໄຂການໃຊ້ງານ',
                                style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                                recognizer: TapGestureRecognizer()..onTap = () {},
                              ),
                              const TextSpan(text: ' ແລະ '),
                              const TextSpan(
                                text: 'ນະໂຍບາຍຄວາມເປັນສ່ວນຕົວ',
                                style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 26.h),
                Obx(
                  () => AppButton(
                    label: 'ສະໝັກສະມາຊິກ',
                    loading: controller.loading.value,
                    onPressed: controller.register,
                  ),
                ),
                SizedBox(height: 18.h),
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: 'ມີບັນຊີແລ້ວ? ',
                      style: TextStyle(fontSize: 12.5.sp, color: AppColors.textSecondary),
                      children: [
                        TextSpan(
                          text: 'ເຂົ້າສູ່ລະບົບ',
                          style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700),
                          recognizer: TapGestureRecognizer()..onTap = () => Get.offNamed(AppRoutes.login),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
