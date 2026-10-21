import 'package:get/get.dart';

import '../../../core/services/checkout_service.dart';
import '../../../data/repositories/shop_repository.dart';
import '../controllers/cart_controller.dart';

class CartBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ShopRepository>()) Get.lazyPut(() => ShopRepository(), fenix: true);
    if (!Get.isRegistered<CheckoutService>()) Get.put(CheckoutService(), permanent: true);
    Get.lazyPut(() => CartController());
  }
}
