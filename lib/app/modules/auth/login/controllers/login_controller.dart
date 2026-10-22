import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/base/base_controller.dart';
import '../../../../core/routes/app_navigator.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../core/utils/app_snackbar.dart';

class LoginController extends BaseController {
  final AuthService _auth = Get.find<AuthService>();

  final formKey = GlobalKey<FormState>();
  final identifierController = TextEditingController(text: 'bounmy@gmail.com');
  final passwordController = TextEditingController(text: 'Customer@123');
  final remember = true.obs;
  final obscure = true.obs;

  void toggleObscure() => obscure.value = !obscure.value;

  Future<void> login() async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    try {
      await guard(() => _auth.login(
          identifierController.text.trim(), passwordController.text));
      await Get.find<NotificationService>().load();
      AppSnackbar.success('ຍິນດີຕ້ອນຮັບ ${_auth.user?.name ?? ''}');
      // The account location now swaps the login view for the profile view.
      AppNavigator.openAccount();
    } catch (_) {
      AppSnackbar.error(error.value ?? 'ເຂົ້າສູ່ລະບົບບໍ່ສຳເລັດ');
    }
  }

  Future<void> loginWithGoogle() async {
    // google_sign_in can be wired here: obtain idToken then POST /app/auth/register (provider GOOGLE)
    AppSnackbar.info(
        'ກະລຸນາເພີ່ມ Client ID ຂອງ Google ໃນໄຟລ໌ config ກ່ອນໃຊ້ງານ');
  }

  Future<void> loginWithFacebook() async {
    AppSnackbar.info('Facebook Login ຕ້ອງການ App ID — ເບິ່ງເອກະສານໃນ README');
  }

  @override
  void onClose() {
    identifierController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
