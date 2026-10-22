import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/base/base_controller.dart';
import '../../../../core/routes/app_navigator.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../core/utils/app_snackbar.dart';
import '../../../../core/utils/validators.dart';

class OtpController extends BaseController {
  final AuthService _auth = Get.find<AuthService>();

  final phoneController = TextEditingController(text: '02055551234');
  final codeController = TextEditingController();
  final code = ''.obs;
  final secondsLeft = 45.obs;
  final sent = false.obs;
  final devCode = ''.obs;

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    secondsLeft.value = 45;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsLeft.value <= 0) {
        timer.cancel();
      } else {
        secondsLeft.value--;
      }
    });
  }

  Future<void> sendCode() async {
    final error = Validators.phone(phoneController.text);
    if (error != null) {
      AppSnackbar.error(error);
      return;
    }
    try {
      final dev =
          await guard(() => _auth.requestOtp(phoneController.text.trim()));
      sent.value = true;
      devCode.value = dev ?? '';
      _startTimer();
      AppSnackbar.success('ສົ່ງ OTP ໄປຍັງ ${phoneController.text} ແລ້ວ');
    } catch (_) {
      AppSnackbar.error(error_.value ?? 'ສົ່ງ OTP ບໍ່ສຳເລັດ');
    }
  }

  RxnString get error_ => error;

  Future<void> verify(String value) async {
    if (value.length < 6) return;
    try {
      final ok = await guard(() =>
          _auth.verifyOtp(phone: phoneController.text.trim(), code: value));
      if (ok == true) {
        await Get.find<NotificationService>().load();
        AppNavigator.openAccount();
      }
    } catch (_) {
      AppSnackbar.error(error.value ?? 'ລະຫັດ OTP ບໍ່ຖືກຕ້ອງ');
      codeController.clear();
      code.value = '';
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    phoneController.dispose();
    codeController.dispose();
    super.onClose();
  }
}
