import 'package:get/get.dart';

import '../../../core/routes/app_routes.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    _boot();
  }

  Future<void> _boot() async {
    await Future<void>.delayed(const Duration(milliseconds: 1900));
    // Always continue into the storefront. Guests can browse freely and
    // are asked to sign in only when they try to order.
    Get.offAllNamed(AppRoutes.main);
  }
}
