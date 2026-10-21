import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/app_button.dart';
import '../controllers/otp_controller.dart';

class OtpView extends GetView<OtpController> {
  const OtpView({super.key});

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 54.w,
      height: 58.h,
      textStyle: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.divider),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ຢືນຢັນເບີໂທ', style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w800)),
              SizedBox(height: 6.h),
              Text(
                'ປ້ອນເບີໂທຂອງທ່ານ ເພື່ອຮັບລະຫັດ OTP 6 ຕົວເລກ',
                style: TextStyle(fontSize: 12.5.sp, color: AppColors.textSecondary, height: 1.5),
              ),
              SizedBox(height: 26.h),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.phoneController,
                      keyboardType: TextInputType.phone,
                      style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
                      decoration: const InputDecoration(
                        hintText: '020 5555 1234',
                        prefixIcon: Icon(Icons.phone_outlined),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  SizedBox(
                    width: 96.w,
                    child: Obx(
                      () => AppButton(
                        label: controller.sent.value ? 'ສົ່ງຄືນ' : 'ສົ່ງລະຫັດ',
                        height: AppSizes.inputHeight,
                        loading: controller.loading.value,
                        onPressed: controller.sendCode,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 26.h),
              Center(
                child: Pinput(
                  controller: controller.codeController,
                  length: 6,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: defaultPinTheme.copyWith(
                    decoration: defaultPinTheme.decoration!.copyWith(
                      border: Border.all(color: AppColors.primary, width: 1.6),
                    ),
                  ),
                  onChanged: (value) => controller.code.value = value,
                  onCompleted: controller.verify,
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(height: 20.h),
              Obx(
                () => Center(
                  child: controller.secondsLeft.value > 0
                      ? Text(
                          'ສົ່ງລະຫັດຄືນໄດ້ໃນ ${controller.secondsLeft.value} ວິນາທີ',
                          style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
                        )
                      : TextButton(
                          onPressed: controller.sendCode,
                          child: const Text('ສົ່ງລະຫັດຄືນໃໝ່'),
                        ),
                ),
              ),
              Obx(
                () => controller.devCode.value.isEmpty
                    ? const SizedBox.shrink()
                    : Container(
                        margin: EdgeInsets.only(top: 14.h),
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.info_outline_rounded, size: 18, color: AppColors.primary),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Text(
                                'ໂໝດທົດລອງ (dev): ລະຫັດ OTP ຂອງທ່ານແມ່ນ ${controller.devCode.value}',
                                style: TextStyle(fontSize: 11.5.sp, color: AppColors.primaryDark),
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
              SizedBox(height: 30.h),
              Obx(
                () => AppButton(
                  label: 'ຢືນຢັນ',
                  loading: controller.loading.value,
                  onPressed: () => controller.verify(controller.code.value),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
