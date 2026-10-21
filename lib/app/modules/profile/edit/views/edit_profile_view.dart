import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_bar_widget.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../controllers/edit_profile_controller.dart';

class EditProfileView extends GetView<EditProfileController> {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AppBarWidget(title: 'ແກ້ໄຂໂປຣໄຟລ໌'),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Stack(
                  children: [
                    Container(
                      height: 92.r,
                      width: 92.r,
                      decoration: BoxDecoration(color: AppColors.surfaceAlt, shape: BoxShape.circle),
                      child: ClipOval(
                        child: (controller.user?.avatar ?? '').isNotEmpty
                            ? AppNetworkImage(controller.user!.avatar!, fit: BoxFit.cover)
                            : Center(
                                child: Text(
                                  controller.user?.initials ?? 'U',
                                  style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.w800),
                                ),
                              ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: EdgeInsets.all(7.r),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Icon(Icons.camera_alt_outlined, size: 13.r, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 26.h),
              AppTextField(
                controller: controller.nameController,
                label: 'ຊື່ ແລະ ນາມສະກຸນ',
                hint: 'ປ້ອນຊື່ຂອງທ່ານ',
                icon: Icons.person_outline_rounded,
                validator: (v) => Validators.required(v, 'ຊື່'),
              ),
              SizedBox(height: 16.h),
              AppTextField(
                controller: controller.emailController,
                label: 'ອີເມວ',
                hint: 'you@email.com',
                icon: Icons.mail_outline_rounded,
                keyboardType: TextInputType.emailAddress,
                validator: controller.validateEmail,
              ),
              SizedBox(height: 16.h),
              AppTextField(
                controller: controller.phoneController,
                label: 'ເບີໂທ',
                hint: '020 xxxx xxxx',
                icon: Icons.phone_outlined,
                enabled: false,
              ),
              SizedBox(height: 8.h),
              Text(
                'ເບີໂທບໍ່ສາມາດປ່ຽນໄດ້ ເນື່ອງຈາກໃຊ້ສຳລັບເຂົ້າສູ່ລະບົບ',
                style: TextStyle(fontSize: 10.5.sp, color: AppColors.textHint),
              ),
              SizedBox(height: 30.h),
              Obx(
                () => AppButton(
                  label: 'ບັນທຶກ',
                  loading: controller.loading.value,
                  onPressed: controller.save,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
