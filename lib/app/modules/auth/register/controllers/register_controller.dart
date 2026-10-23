import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/base/base_controller.dart';
import '../../../../core/routes/app_navigator.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../core/utils/app_snackbar.dart';
import '../../../../core/utils/validators.dart';

/// Registration is a small wizard:
/// 0. pick a phone number
/// 1. confirm the OTP that was sent to it
/// 2. create the password (and profile details)
/// 3. success
class RegisterController extends BaseController {
  final AuthService _auth = Get.find<AuthService>();

  final formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  final step = 0.obs;
  final phone = ''.obs;
  final phoneDisplay = ''.obs;
  final isoCode = 'LA'.obs;
  final otp = ''.obs;
  final otpError = ''.obs;
  final devCode = ''.obs;
  final secondsLeft = 60.obs;
  final accepted = false.obs;
  final passwordStrength = 0.obs;

  Timer? _timer;

  bool get canResend => secondsLeft.value <= 0;

  /// Called by [InternationalPhoneNumberInput].
  /// The API stores Lao numbers in the local `020...` format.
  void setPhone(String e164, String countryIso) {
    isoCode.value = countryIso.toUpperCase();
    final digits = e164.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) {
      phone.value = '';
      phoneDisplay.value = '';
      return;
    }
    if (countryIso.toUpperCase() == 'LA') {
      var national = digits;
      if (national.startsWith('856')) national = national.substring(3);
      national = national.replaceFirst(RegExp(r'^0+'), '');
      phone.value = national.isEmpty ? '' : '0$national';
    } else {
      phone.value = e164;
    }
    phoneDisplay.value = _prettyPhone(e164);
  }

  String _prettyPhone(String e164) {
    final digits = e164.replaceAll(RegExp(r'\D'), '');
    if (digits.startsWith('856') && digits.length >= 10) {
      final rest = digits.substring(3);
      final prefix = rest.substring(0, 2);
      final middle = rest.substring(2, rest.length - 4);
      final tail = rest.substring(rest.length - 4);
      return '+856 $prefix $middle $tail';
    }
    return e164;
  }

  Future<void> sendOtp() async {
    if (loading.value) return;
    final validation = Validators.phone(phone.value);
    if (validation != null) {
      AppSnackbar.error(validation);
      return;
    }
    try {
      final dev = await guard(() => _auth.requestOtp(phone.value));
      devCode.value = dev ?? '';
      otpController.clear();
      otp.value = '';
      otpError.value = '';
      _startTimer();
      step.value = 1;
      AppSnackbar.success('ສົ່ງ OTP ໄປຍັງ ${phoneDisplay.value} ແລ້ວ');
    } catch (_) {
      AppSnackbar.error(error.value ?? 'ສົ່ງ OTP ບໍ່ສຳເລັດ');
    }
  }

  Future<void> resendOtp() async {
    if (!canResend) return;
    await sendOtp();
  }

  void onOtpChanged(String value) {
    otp.value = value;
    if (otpError.value.isNotEmpty) otpError.value = '';
  }

  Future<void> verifyOtp(String value) async {
    if (loading.value) return;
    final code = value.trim();
    if (code.length != 6) {
      otpError.value = 'ກະລຸນາປ້ອນລະຫັດ OTP 6 ໂຕ';
      return;
    }
    otpError.value = '';
    try {
      final ok =
          await guard(() => _auth.verifyOtp(phone: phone.value, code: code));
      if (ok != true) return;
      _timer?.cancel();
      otpController.clear();
      otp.value = '';
      secondsLeft.value = 0;
      step.value = 2;
      AppSnackbar.success('ຢືນຢັນເບີໂທສຳເລັດ');
    } catch (_) {
      otpError.value = error.value ?? 'ລະຫັດ OTP ບໍ່ຖືກຕ້ອງ';
      otpController.clear();
      otp.value = '';
      AppSnackbar.error(otpError.value);
    }
  }

  void onPasswordChanged(String value) {
    if (value.isEmpty) {
      passwordStrength.value = 0;
      return;
    }
    var score = 1;
    if (value.length >= 8) score++;
    if (RegExp(r'[A-Z]').hasMatch(value)) score++;
    if (RegExp(r'\d').hasMatch(value)) score++;
    passwordStrength.value = score > 4 ? 4 : score;
  }

  Future<void> completeRegistration() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!(formKey.currentState?.validate() ?? false)) return;
    if (!accepted.value) {
      AppSnackbar.error('ກະລຸນາຍອມຮັບເງື່ອນໄຂການໃຊ້ງານ');
      return;
    }

    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;

    try {
      await guard(() async {
        await _auth.updateProfile(
          name: name,
          email: email.isEmpty ? null : email,
        );
        // OTP-created accounts have no password yet, so the empty current
        // password is accepted by the API and sets the first one.
        await _auth.changePassword('', password);
      });
      step.value = 3;
      AppSnackbar.success('ສ້າງບັນຊີສຳເລັດ 🎉');
      try {
        await Get.find<NotificationService>().load();
      } catch (_) {
        // The account is already created; notifications can sync later.
      }
    } catch (_) {
      final message = error.value ?? '';
      if (message.contains('ເດີມ')) {
        AppSnackbar.info('ເບີໂທນີ້ມີລະຫັດຜ່ານແລ້ວ — ຍິນດີຕ້ອນຮັບກັບມາ');
        AppNavigator.openAccount();
        return;
      }
      AppSnackbar.error(message.isEmpty ? 'ສ້າງບັນຊີບໍ່ສຳເລັດ' : message);
    }
  }

  /// Steps back through the wizard. After the OTP is verified a new OTP is
  /// required before the phone can be changed again.
  void back() {
    switch (step.value) {
      case 0:
        Get.back();
        break;
      case 1:
        _timer?.cancel();
        otpController.clear();
        otp.value = '';
        otpError.value = '';
        step.value = 0;
        break;
      case 2:
        _timer?.cancel();
        otpController.clear();
        otp.value = '';
        otpError.value = '';
        secondsLeft.value = 0;
        step.value = 1;
        AppSnackbar.info('ກະລຸນາສົ່ງ OTP ໃໝ່ເພື່ອຢືນຢັນອີກຄັ້ງ');
        break;
      default:
        break;
    }
  }

  void editPhone() {
    _timer?.cancel();
    otpController.clear();
    otp.value = '';
    otpError.value = '';
    step.value = 0;
  }

  void finish() {
    AppNavigator.openAccount();
  }

  void _startTimer() {
    _timer?.cancel();
    secondsLeft.value = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsLeft.value <= 0) {
        timer.cancel();
      } else {
        secondsLeft.value--;
      }
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    phoneController.dispose();
    otpController.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    super.onClose();
  }
}
