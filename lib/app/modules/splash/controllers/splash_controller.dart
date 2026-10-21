import 'package:get/get.dart';

import '../../../core/routes/app_routes.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/storage/local_storage.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    _boot();
  }

  Future<void> _boot() async {
    await Future<void>.delayed(const Duration(milliseconds: 1900));
    final storage = Get.find<LocalStorage>();
    final auth = Get.find<AuthService>();

    if (storage.isFirstRun) {
      Get.offAllNamed(AppRoutes.onboarding);
      // Get.offAllNamed(AppRoutes.login);
      return;
    }
    Get.offAllNamed(auth.isLoggedIn ? AppRoutes.main : AppRoutes.login);
    // Get.offAllNamed(auth.isLoggedIn ? AppRoutes.main : AppRoutes.main);
  }
}
