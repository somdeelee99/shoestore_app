import 'package:get/get.dart';

import '../../../../data/repositories/shop_repository.dart';
import '../controllers/checkout_shipping_controller.dart';

class CheckoutShippingBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ShopRepository>()) Get.lazyPut(() => ShopRepository(), fenix: true);
    Get.lazyPut(() => CheckoutShippingController());
  }
}
