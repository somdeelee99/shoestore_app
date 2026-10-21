import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/base/base_controller.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/utils/app_snackbar.dart';
import '../../../../core/utils/validators.dart';
import '../../../../data/models/user_model.dart';

class EditProfileController extends BaseController {
  final AuthService _auth = Get.find<AuthService>();

  final formKey = GlobalKey<FormState>();
  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController phoneController;

  UserModel? get user => _auth.user;

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController(text: _auth.user?.name ?? '');
    emailController = TextEditingController(text: _auth.user?.email ?? '');
    phoneController = TextEditingController(text: _auth.user?.phone ?? '');
  }

  Future<void> save() async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    try {
      await guard(() async {
        await _auth.updateProfile(
          name: nameController.text.trim(),
          email: emailController.text.trim().isEmpty ? null : emailController.text.trim(),
        );
      });
      AppSnackbar.success('ບັນທຶກຂໍ້ມູນສຳເລັດ');
      Get.back();
    } catch (_) {}
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    return Validators.email(value);
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}
