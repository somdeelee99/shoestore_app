import 'package:get/get.dart';

import '../../../../data/repositories/shop_repository.dart';
import '../controllers/checkout_payment_controller.dart';

class CheckoutPaymentBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ShopRepository>()) Get.lazyPut(() => ShopRepository(), fenix: true);
    Get.lazyPut(() => CheckoutPaymentController());
  }
}
