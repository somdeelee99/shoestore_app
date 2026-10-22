import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/base/base_controller.dart';
import '../../../../core/routes/app_navigator.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../core/utils/app_snackbar.dart';

class RegisterController extends BaseController {
  final AuthService _auth = Get.find<AuthService>();

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();
  final accepted = false.obs;

  Future<void> register() async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    if (!accepted.value) {
      AppSnackbar.error('ກະລຸນາຍອມຮັບເງື່ອນໄຂການໃຊ້ງານ');
      return;
    }
    try {
      await guard(() => _auth.register(
            name: nameController.text.trim(),
            email: emailController.text.trim(),
            phone: phoneController.text.trim(),
            password: passwordController.text,
          ));
      await Get.find<NotificationService>().load();
      AppSnackbar.success('ສ້າງບັນຊີສຳເລັດ 🎉');
      // Registration replaces the login view with the profile view.
      AppNavigator.openAccount();
    } catch (_) {
      AppSnackbar.error(error.value ?? 'ສະໝັກບໍ່ສຳເລັດ');
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    super.onClose();
  }
}
