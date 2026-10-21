import 'package:get/get.dart';

import '../../../../data/repositories/shop_repository.dart';
import '../controllers/orders_controller.dart';

class OrdersBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ShopRepository>()) Get.lazyPut(() => ShopRepository(), fenix: true);
    Get.lazyPut(() => OrdersController());
  }
}
