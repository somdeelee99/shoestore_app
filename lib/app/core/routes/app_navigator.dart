import 'package:get/get.dart';

import '../../modules/home/controllers/main_controller.dart';
import '../services/auth_service.dart';
import '../utils/app_snackbar.dart';
import 'app_routes.dart';

/// Central navigation for the guest / signed-in app flow.
///
/// The account tab is the single location for authentication:
/// guests see the login view there, signed-in users see their profile.
class AppNavigator {
  AppNavigator._();

  static MainController get _main {
    if (Get.isRegistered<MainController>()) return Get.find<MainController>();
    return Get.put(MainController(), permanent: true);
  }

  /// Opens the shared account location (login when signed out,
  /// profile when signed in).
  static void openAccount() {
    _main.openAccount();
    if (Get.currentRoute == AppRoutes.main) return;
    Get.offAllNamed(AppRoutes.main);
  }

  /// Returns true when the user may continue with an order.
  /// Guests are redirected to the login / registration location.
  static bool requireLogin() {
    if (Get.find<AuthService>().isLoggedIn) return true;
    AppSnackbar.info('ກະລຸນາເຂົ້າສູ່ລະບົບ ຫຼື ສະໝັກສະມາຊິກກ່ອນສັ່ງຊື້');
    openAccount();
    return false;
  }
}
