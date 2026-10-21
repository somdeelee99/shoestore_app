import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/base/base_controller.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/storage/local_storage.dart';
import '../../../../core/utils/app_snackbar.dart';
import '../../../../data/models/order_model.dart';
import '../../../../data/models/user_model.dart';
import '../../../../data/repositories/shop_repository.dart';

class ProfileController extends BaseController {
  final ShopRepository _repository = Get.find<ShopRepository>();
  final AuthService _auth = Get.find<AuthService>();

  final RxList<OrderModel> recentOrders = <OrderModel>[].obs;
  final RxInt wishlistCount = 0.obs;
  final RxInt addressCount = 0.obs;

  bool get isLoggedIn => _auth.isLoggedIn;
  UserModel? get user => _auth.user;

  @override
  void onInit() {
    super.onInit();
    if (isLoggedIn) fetch();
  }

  Future<void> fetch() async {
    try {
      await guard(() async {
        recentOrders.assignAll((await _repository.myOrders()).take(3).toList());
      }, showLoading: false);
    } catch (_) {}
    _counts();
  }

  Future<void> _counts() async {
    try {
      wishlistCount.value = (await _repository.wishlist()).length;
      addressCount.value = (await _repository.addresses()).length;
    } catch (_) {}
  }

  void openOrders() => Get.toNamed(AppRoutes.orders);
  void openEdit() => Get.toNamed(AppRoutes.editProfile);
  void openAddresses() => Get.toNamed(AppRoutes.addresses);
  void openWishlist() => Get.toNamed(AppRoutes.wishlist);
  void openCoupons() => Get.toNamed(AppRoutes.coupons);
  void openSettings() => Get.toNamed(AppRoutes.settings);
  void openNotifications() => Get.toNamed(AppRoutes.notifications);
  void openChat() => Get.toNamed(AppRoutes.chat);
  void openLogin() => Get.toNamed(AppRoutes.login);
  void openRegister() => Get.toNamed(AppRoutes.register);

  Future<void> logout() async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('ອອກຈາກລະບົບ'),
        content: const Text('ທ່ານຕ້ອງການອອກຈາກລະບົບແທ້ບໍ?'),
        actions: [
          TextButton(onPressed: () => Get.back(result: false), child: const Text('ຍົກເລີກ')),
          TextButton(onPressed: () => Get.back(result: true), child: const Text('ອອກ')),
        ],
      ),
    );
    if (confirmed != true) return;
    await _auth.logout();
    await Get.find<LocalStorage>().clearSession();
    AppSnackbar.success('ອອກຈາກລະບົບແລ້ວ');
    Get.offAllNamed(AppRoutes.login);
  }
}
