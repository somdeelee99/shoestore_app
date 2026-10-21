import 'package:get/get.dart';

import '../../../../data/repositories/shop_repository.dart';
import '../controllers/checkout_address_controller.dart';

class CheckoutAddressBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ShopRepository>()) Get.lazyPut(() => ShopRepository(), fenix: true);
    Get.lazyPut(() => CheckoutAddressController());
  }
}
