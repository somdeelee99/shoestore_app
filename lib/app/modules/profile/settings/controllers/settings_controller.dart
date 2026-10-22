import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/base/base_controller.dart';
import '../../../../core/routes/app_navigator.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/storage/local_storage.dart';
import '../../../../core/utils/app_snackbar.dart';

class SettingsController extends BaseController {
  final LocalStorage _storage = Get.find<LocalStorage>();
  final AuthService _auth = Get.find<AuthService>();

  final RxBool pushEnabled = true.obs;
  final RxBool promoEnabled = true.obs;
  final RxBool darkMode = false.obs;
  final RxString language = 'lo'.obs;

  bool get isLoggedIn => _auth.isLoggedIn;

  @override
  void onInit() {
    super.onInit();
    pushEnabled.value = _storage.pushEnabled;
    promoEnabled.value = _storage.promoEnabled;
    darkMode.value = _storage.darkMode;
    language.value = _storage.language;
  }

  void togglePush(bool value) {
    pushEnabled.value = value;
    _storage.setPushEnabled(value);
  }

  void togglePromo(bool value) {
    promoEnabled.value = value;
    _storage.setPromoEnabled(value);
  }

  void toggleDark(bool value) {
    darkMode.value = value;
    _storage.setDarkMode(value);
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
  }

  void setLanguage(String value) {
    language.value = value;
    _storage.setLanguage(value);
    AppSnackbar.info(
        value == 'lo' ? 'ປ່ຽນເປັນພາສາລາວແລ້ວ' : 'Language switched to English');
  }

  void openEditProfile() => Get.toNamed(AppRoutes.editProfile);
  void openAddresses() => Get.toNamed(AppRoutes.addresses);
  void openNotifications() => Get.toNamed(AppRoutes.notifications);

  Future<void> changePassword() async {
    final currentCtrl = TextEditingController();
    final nextCtrl = TextEditingController();
    final result = await Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('ປ່ຽນລະຫັດຜ່ານ'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'ລະຫັດຜ່ານເກົ່າ'),
            ),
            TextField(
              controller: nextCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'ລະຫັດຜ່ານໃໝ່'),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('ຍົກເລີກ')),
          TextButton(
              onPressed: () => Get.back(result: true),
              child: const Text('ບັນທຶກ')),
        ],
      ),
    );
    if (result != true) return;
    if (nextCtrl.text.length < 6) {
      AppSnackbar.error('ລະຫັດຜ່ານໃໝ່ຕ້ອງມີຢ່າງໜ້ອຍ 6 ຕົວອັກສອນ');
      return;
    }
    try {
      await _auth.changePassword(currentCtrl.text, nextCtrl.text);
      AppSnackbar.success('ປ່ຽນລະຫັດຜ່ານສຳເລັດ');
    } catch (_) {
      AppSnackbar.error('ປ່ຽນລະຫັດຜ່ານບໍ່ສຳເລັດ');
    }
  }

  Future<void> logout() async {
    await _auth.logout();
    await _storage.clearSession();
    AppNavigator.openAccount();
  }

  void about() => Get.dialog(
        AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: const Text('ກ່ຽວກັບຮ້ານ'),
          content: const Text(
            'ShoeStore ຮ້ານຂາຍເກີບອອນລາຍ\nເວີຊັ່ນ 1.0.0\n\nໂທ: 020 5555 1234\nອີເມວ: support@shoestore.com',
          ),
          actions: [TextButton(onPressed: Get.back, child: const Text('ປິດ'))],
        ),
      );
}
