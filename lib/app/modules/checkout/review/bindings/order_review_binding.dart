import 'package:get/get.dart';

import '../../../../data/repositories/shop_repository.dart';
import '../../../cart/controllers/cart_controller.dart';
import '../controllers/order_review_controller.dart';

class OrderReviewBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ShopRepository>()) Get.lazyPut(() => ShopRepository(), fenix: true);
    if (!Get.isRegistered<CartController>()) Get.lazyPut(() => CartController(), fenix: true);
    Get.lazyPut(() => OrderReviewController());
  }
}
