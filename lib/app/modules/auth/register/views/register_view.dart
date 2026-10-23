import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:pinput/pinput.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        controller.back();
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Stack(
          children: [
            _buildBackground(),
            SafeArea(
              child: Column(
                children: [
                  _buildTopBar(),
                  Expanded(
                    child: SingleChildScrollView(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      padding: EdgeInsets.fromLTRB(20.w, 6.h, 20.w, 30.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(_buildHeader),
                          SizedBox(height: 22.h),
                          Obx(_buildStepper),
                          SizedBox(height: 22.h),
                          Obx(
                            () => AnimatedSwitcher(
                              duration: 320.ms,
                              switchInCurve: Curves.easeOutCubic,
                              switchOutCurve: Curves.easeInCubic,
                              transitionBuilder: (child, animation) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: SlideTransition(
                                    position: Tween<Offset>(
                                      begin: const Offset(0.06, 0),
                                      end: Offset.zero,
                                    ).animate(animation),
                                    child: child,
                                  ),
                                );
                              },
                              child: KeyedSubtree(
                                key: ValueKey(controller.step.value),
                                child: _buildStep(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Chrome
  // ---------------------------------------------------------------------------

  Widget _buildBackground() {
    return Stack(
      children: [
        Positioned(
          top: -120.h,
          right: -80.w,
          child: _blob(270.r, AppColors.primary.withValues(alpha: .12)),
        ),
        Positioned(
          top: 150.h,
          left: -100.w,
          child: _blob(220.r, AppColors.accent.withValues(alpha: .10)),
        ),
      ],
    );
  }

  Widget _blob(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color, color.withValues(alpha: 0)],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: EdgeInsets.fromLTRB(12.w, 8.h, 14.w, 4.h),
      child: Row(
        children: [
          Obx(
            () => _roundButton(
              icon: controller.step.value < 3
                  ? Icons.arrow_back_rounded
                  : Icons.chevron_left_rounded,
              onTap: controller.step.value < 3 ? controller.back : null,
            ),
          ),
          const Spacer(),
          Obx(
            () => controller.step.value == 3
                ? const SizedBox.shrink()
                : TextButton(
                    onPressed: () => Get.offNamed(AppRoutes.login),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 8.h,
                      ),
                    ),
                    child: Text(
                      'ເຂົ້າສູ່ລະບົບ',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _roundButton({required IconData icon, VoidCallback? onTap}) {
    return Container(
      width: 42.r,
      height: 42.r,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: AppSizes.softShadow,
      ),
      child: IconButton(
        onPressed: onTap,
        padding: EdgeInsets.zero,
        icon: Icon(icon, size: 20.r, color: AppColors.textPrimary),
      ),
    );
  }

  Widget _buildHeader() {
    final step = controller.step.value;
    final icons = <IconData>[
      Icons.phone_iphone_rounded,
      Icons.shield_outlined,
      Icons.lock_outline_rounded,
      Icons.check_rounded,
    ];
    final titles = <String>[
      'ສ້າງບັນຊີໃໝ່',
      'ຢືນຢັນເບີໂທ',
      'ສ້າງລະຫັດຜ່ານ',
      'ຍິນດີຕ້ອນຮັບ!',
    ];
    final subtitles = <String>[
      'ເລືອກເບີໂທ ແລ້ວຢືນຢັນດ້ວຍ OTP ເພື່ອຄວາມປອດໄພ',
      'ປ້ອນລະຫັດ 6 ໂຕທີ່ສົ່ງໄປຍັງ ${controller.phoneDisplay.value}',
      'ຕັ້ງລະຫັດຜ່ານ ແລະ ຂໍ້ມູນບັນຊີຂອງທ່ານ',
      'ບັນຊີຂອງທ່ານຖືກສ້າງສຳເລັດແລ້ວ',
    ];

    final isSuccess = step == 3;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 64.r,
          height: 64.r,
          decoration: BoxDecoration(
            gradient: isSuccess
                ? const LinearGradient(
                    colors: [AppColors.success, Color(0xFF059669)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: (isSuccess ? AppColors.success : AppColors.primary)
                    .withValues(alpha: .28),
                blurRadius: 22,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Icon(icons[step], color: Colors.white, size: 29.r),
        ),
        SizedBox(width: 14.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: isSuccess
                      ? AppColors.success.withValues(alpha: .12)
                      : AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text(
                  isSuccess ? 'ສຳເລັດ' : 'ຂັ້ນຕອນ ${step + 1} / 3',
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                    color:
                        isSuccess ? AppColors.success : AppColors.primaryDark,
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                titles[step],
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  height: 1.2,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                subtitles[step],
                style: TextStyle(
                  fontSize: 12.5.sp,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStepper() {
    final current = controller.step.value;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _stepDot(0, 'ເບີໂທ', Icons.phone_rounded, current),
        _stepLine(0, current),
        _stepDot(1, 'OTP', Icons.password_rounded, current),
        _stepLine(1, current),
        _stepDot(2, 'ລະຫັດຜ່ານ', Icons.lock_rounded, current),
      ],
    );
  }

  Widget _stepDot(int index, String label, IconData icon, int current) {
    final completed = index < current;
    final active = index == current;
    final color = active
        ? Colors.white
        : completed
            ? AppColors.primary
            : AppColors.textHint;

    return SizedBox(
      width: 70.w,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: 250.ms,
            curve: Curves.easeOut,
            width: 38.r,
            height: 38.r,
            decoration: BoxDecoration(
              gradient: active ? AppColors.primaryGradient : null,
              color: active
                  ? null
                  : completed
                      ? AppColors.primaryLight
                      : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: active
                    ? Colors.transparent
                    : completed
                        ? AppColors.primary.withValues(alpha: .25)
                        : AppColors.divider,
              ),
              boxShadow: active
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: .3),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ]
                  : null,
            ),
            child: Icon(
              completed ? Icons.check_rounded : icon,
              color: color,
              size: 18.r,
            ),
          ),
          SizedBox(height: 7.h),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight:
                  active || completed ? FontWeight.w700 : FontWeight.w500,
              color: active || completed
                  ? AppColors.textPrimary
                  : AppColors.textHint,
            ),
          ),
        ],
      ),
    );
  }

  Widget _stepLine(int index, int current) {
    final done = index < current;
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(top: 18.h, left: 2.w, right: 2.w),
        child: AnimatedContainer(
          duration: 300.ms,
          height: 2.h,
          decoration: BoxDecoration(
            color: done ? AppColors.primary : AppColors.divider,
            borderRadius: BorderRadius.circular(99),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Steps
  // ---------------------------------------------------------------------------

  Widget _buildStep() {
    switch (controller.step.value) {
      case 0:
        return _buildPhoneStep();
      case 1:
        return _buildOtpStep();
      case 2:
        return _buildPasswordStep();
      default:
        return _buildSuccessStep();
    }
  }

  Widget _buildPhoneStep() {
    return Column(
      children: [
        _card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ເບີໂທມືຖື',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 8.h),
              InternationalPhoneNumberInput(
                textFieldController: controller.phoneController,
                initialValue: PhoneNumber(isoCode: controller.isoCode.value),
                locale: 'lo',
                selectorConfig: const SelectorConfig(
                  selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                  setSelectorButtonAsPrefixIcon: true,
                  useBottomSheetSafeArea: true,
                  useEmoji: true,
                  trailingSpace: false,
                  leadingPadding: 12,
                ),
                selectorTextStyle: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
                textStyle: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
                hintText: '20 5555 1234',
                maxLength: 15,
                inputDecoration: InputDecoration(
                  hintText: '20 5555 1234',
                  counterText: '',
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 16.h,
                  ),
                  prefixIconConstraints: BoxConstraints(minWidth: 96.w),
                ),
                searchBoxDecoration: const InputDecoration(
                  hintText: 'ຄົ້ນຫາປະເທດ ຫຼື ລະຫັດ',
                  prefixIcon: Icon(Icons.search_rounded),
                ),
                onInputChanged: (number) => controller.setPhone(
                  number.phoneNumber ?? '',
                  number.isoCode ?? 'LA',
                ),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 14.h),
              _infoNote(
                icon: Icons.shield_outlined,
                text:
                    'ລະຫັດ OTP 6 ໂຕຈະຖືກສົ່ງໄປຍັງເບີນີ້ ເພື່ອຢືນຢັນວ່າເປັນຂອງທ່ານ',
              ),
              SizedBox(height: 20.h),
              Obx(
                () => AppButton(
                  label: 'ສົ່ງລະຫັດ OTP',
                  icon: Icons.arrow_forward_rounded,
                  loading: controller.loading.value,
                  onPressed: controller.sendOtp,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20.h),
        Center(
          child: RichText(
            text: TextSpan(
              text: 'ມີບັນຊີແລ້ວ? ',
              style: TextStyle(
                fontSize: 12.5.sp,
                color: AppColors.textSecondary,
              ),
              children: [
                TextSpan(
                  text: 'ເຂົ້າສູ່ລະບົບ',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => Get.offNamed(AppRoutes.login),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOtpStep() {
    final baseTheme = PinTheme(
      width: 44.w,
      height: 56.h,
      textStyle: TextStyle(
        fontSize: 21.sp,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.divider),
      ),
    );
    final focusedTheme = baseTheme.copyWith(
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withValues(alpha: .55),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.primary, width: 1.8),
      ),
    );
    final errorTheme = baseTheme.copyWith(
      decoration: BoxDecoration(
        color: AppColors.danger.withValues(alpha: .06),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.danger, width: 1.5),
      ),
    );

    return _card(
      child: Column(
        children: [
          Text(
            'ປ້ອນລະຫັດ OTP',
            style: TextStyle(
              fontSize: 17.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'ກວດເບິ່ງຂໍ້ຄວາມ SMS ແລ້ວປ້ອນລະຫັດ 6 ໂຕ',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          SizedBox(height: 16.h),
          _phoneChip(),
          SizedBox(height: 24.h),
          Obx(
            () => Pinput(
              controller: controller.otpController,
              length: 6,
              defaultPinTheme: baseTheme,
              focusedPinTheme: focusedTheme,
              errorPinTheme: errorTheme,
              errorText: controller.otpError.value.isEmpty
                  ? null
                  : controller.otpError.value,
              forceErrorState: controller.otpError.value.isNotEmpty,
              onChanged: controller.onOtpChanged,
              onCompleted: controller.verifyOtp,
              keyboardType: TextInputType.number,
              mainAxisAlignment: MainAxisAlignment.center,
              separatorBuilder: (index) => SizedBox(width: 6.w),
              cursor: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 16.w,
                    height: 2.h,
                    margin: EdgeInsets.only(bottom: 8.h),
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10.h),
          Obx(_buildResendRow),
          Obx(() {
            if (controller.devCode.value.isEmpty)
              return const SizedBox.shrink();
            return Container(
              margin: EdgeInsets.only(top: 14.h),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: .18),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline_rounded,
                    size: 18,
                    color: AppColors.primary,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      'ໂໝດທົດລອງ: ລະຫັດ OTP ຂອງທ່ານແມ່ນ ${controller.devCode.value}',
                      style: TextStyle(
                        fontSize: 11.5.sp,
                        color: AppColors.primaryDark,
                        height: 1.45,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          SizedBox(height: 20.h),
          Obx(
            () => AppButton(
              label: 'ຢືນຢັນລະຫັດ',
              icon: Icons.check_circle_outline_rounded,
              loading: controller.loading.value,
              onPressed: () => controller.verifyOtp(controller.otp.value),
            ),
          ),
        ],
      ),
    );
  }

  Widget _phoneChip() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Container(
            width: 34.r,
            height: 34.r,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              Icons.phone_iphone_rounded,
              size: 18.r,
              color: AppColors.primary,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              controller.phoneDisplay.value,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          TextButton(
            onPressed: controller.editPhone,
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'ແກ້ໄຂ',
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResendRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.timer_outlined,
          size: 15.r,
          color: AppColors.textSecondary,
        ),
        SizedBox(width: 6.w),
        if (controller.secondsLeft.value > 0)
          Text(
            'ສົ່ງຄືນໄດ້ໃນ ${controller.secondsLeft.value} ວິນາທີ',
            style: TextStyle(
              fontSize: 11.5.sp,
              color: AppColors.textSecondary,
            ),
          )
        else
          TextButton(
            onPressed: controller.loading.value ? null : controller.resendOtp,
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'ສົ່ງລະຫັດຄືນໃໝ່',
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
            ),
          ),
      ],
    );
  }

  Widget _buildPasswordStep() {
    return _card(
      child: Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _verifiedChip(),
            SizedBox(height: 18.h),
            AppTextField(
              controller: controller.nameController,
              label: 'ຊື່ ແລະ ນາມສະກຸນ',
              hint: 'ສົມໃຈ ວັນນະສິນ',
              icon: Icons.person_outline_rounded,
              textInputAction: TextInputAction.next,
              validator: (v) => Validators.required(v, 'ຊື່'),
            ),
            SizedBox(height: 16.h),
            AppTextField(
              controller: controller.emailController,
              label: 'ອີເມວ (ບໍ່ບັງຄັບ)',
              hint: 'you@example.com',
              icon: Icons.mail_outline_rounded,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? null : Validators.email(v),
            ),
            SizedBox(height: 16.h),
            AppTextField(
              controller: controller.passwordController,
              label: 'ລະຫັດຜ່ານ',
              hint: 'ຢ່າງໜ້ອຍ 6 ໂຕອັກສອນ',
              icon: Icons.lock_outline_rounded,
              obscure: true,
              textInputAction: TextInputAction.next,
              onChanged: controller.onPasswordChanged,
              validator: Validators.password,
            ),
            Obx(_buildStrengthMeter),
            SizedBox(height: 16.h),
            AppTextField(
              controller: controller.confirmController,
              label: 'ຢືນຢັນລະຫັດຜ່ານ',
              hint: '••••••••',
              icon: Icons.lock_outline_rounded,
              obscure: true,
              textInputAction: TextInputAction.done,
              validator: (v) => Validators.confirmPassword(
                v,
                controller.passwordController.text,
              ),
            ),
            SizedBox(height: 18.h),
            _buildTerms(),
            SizedBox(height: 20.h),
            Obx(
              () => AppButton(
                label: 'ສ້າງບັນຊີ',
                icon: Icons.check_circle_outline_rounded,
                loading: controller.loading.value,
                onPressed: controller.completeRegistration,
              ),
            ),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.lock_rounded,
                  size: 13.r,
                  color: AppColors.textHint,
                ),
                SizedBox(width: 5.w),
                Flexible(
                  child: Text(
                    'ຂໍ້ມູນຂອງທ່ານຖືກປົກປ້ອງຢ່າງປອດໄພ',
                    style: TextStyle(
                      fontSize: 10.5.sp,
                      color: AppColors.textHint,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _verifiedChip() {
    return Row(
      children: [
        Container(
          width: 32.r,
          height: 32.r,
          decoration: BoxDecoration(
            color: AppColors.success.withValues(alpha: .12),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check_rounded,
            size: 17.r,
            color: AppColors.success,
          ),
        ),
        SizedBox(width: 9.w),
        Expanded(
          child: Text.rich(
            TextSpan(
              text: 'ຢືນຢັນເບີໂທ ',
              style: TextStyle(
                fontSize: 11.5.sp,
                color: AppColors.textSecondary,
              ),
              children: [
                TextSpan(
                  text: controller.phoneDisplay.value,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const TextSpan(text: ' ສຳເລັດ'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStrengthMeter() {
    final value = controller.passwordStrength.value;
    if (controller.passwordController.text.isEmpty) {
      return const SizedBox.shrink();
    }
    final color = switch (value) {
      1 => AppColors.danger,
      2 => AppColors.warning,
      3 => AppColors.info,
      _ => AppColors.success,
    };
    final label = switch (value) {
      1 => 'ອ່ອນ',
      2 => 'ປານກາງ',
      3 => 'ແຂງ',
      _ => 'ແຂງຫຼາຍ',
    };
    return Padding(
      padding: EdgeInsets.only(top: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              for (var i = 0; i < 4; i++)
                Expanded(
                  child: AnimatedContainer(
                    duration: 200.ms,
                    height: 4.h,
                    margin: EdgeInsets.only(right: i == 3 ? 0 : 5.w),
                    decoration: BoxDecoration(
                      color: i < value ? color : AppColors.divider,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 6.h),
          Text(
            'ຄວາມປອດໄພຂອງລະຫັດ: $label',
            style: TextStyle(
              fontSize: 10.5.sp,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTerms() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(
          () => SizedBox(
            height: 22.h,
            width: 22.h,
            child: Checkbox(
              value: controller.accepted.value,
              onChanged: (v) => controller.accepted.value = v ?? false,
              activeColor: AppColors.primary,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.r),
              ),
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: RichText(
            text: TextSpan(
              text: 'ຂ້ອຍຍອມຮັບ ',
              style: TextStyle(
                fontSize: 11.5.sp,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
              children: [
                TextSpan(
                  text: 'ເງື່ອນໄຂການໃຊ້ງານ',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                  recognizer: TapGestureRecognizer()..onTap = () {},
                ),
                const TextSpan(text: ' ແລະ '),
                TextSpan(
                  text: 'ນະໂຍບາຍຄວາມເປັນສ່ວນຕົວ',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                  recognizer: TapGestureRecognizer()..onTap = () {},
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessStep() {
    final name = controller.nameController.text.trim();
    return _card(
      child: Column(
        children: [
          SizedBox(height: 10.h),
          Container(
            width: 96.r,
            height: 96.r,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.success, Color(0xFF059669)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.success.withValues(alpha: .32),
                  blurRadius: 30,
                  offset: const Offset(0, 14),
                ),
              ],
            ),
            child: Icon(
              Icons.check_rounded,
              color: Colors.white,
              size: 52.r,
            ),
          )
              .animate()
              .scale(
                begin: const Offset(.55, .55),
                curve: Curves.easeOutBack,
                duration: 520.ms,
              )
              .fadeIn(duration: 260.ms),
          SizedBox(height: 22.h),
          Text(
            'ສ້າງບັນຊີສຳເລັດ',
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            name.isEmpty
                ? 'ຍິນດີຕ້ອນຮັບ! ບັນຊີຂອງທ່ານພ້ອມໃຊ້ແລ້ວ'
                : 'ຍິນດີຕ້ອນຮັບ $name! ບັນຊີຂອງທ່ານພ້ອມໃຊ້ແລ້ວ',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.5.sp,
              color: AppColors.textSecondary,
              height: 1.55,
            ),
          ),
          SizedBox(height: 18.h),
          _infoNote(
            icon: Icons.phone_iphone_rounded,
            text: controller.phoneDisplay.value,
            color: AppColors.success,
          ),
          SizedBox(height: 26.h),
          AppButton(
            label: 'ໄປທີ່ບັນຊີຂອງຂ້ອຍ',
            icon: Icons.person_outline_rounded,
            onPressed: controller.finish,
          ),
          SizedBox(height: 14.h),
          Text(
            'ທ່ານສາມາດແກ້ໄຂຂໍ້ມູນສ່ວນຕົວໄດ້ທຸກເວລາໃນໜ້າບັນຊີ',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10.5.sp,
              color: AppColors.textHint,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Shared pieces
  // ---------------------------------------------------------------------------

  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26.r),
        boxShadow: AppSizes.cardShadow,
      ),
      child: child,
    );
  }

  Widget _infoNote({
    required IconData icon,
    required String text,
    Color color = AppColors.info,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .07),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16.r, color: color),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 11.5.sp,
                color: AppColors.textSecondary,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
