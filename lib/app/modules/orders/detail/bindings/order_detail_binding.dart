import 'package:get/get.dart';

import '../../../../data/repositories/shop_repository.dart';
import '../controllers/order_detail_controller.dart';

class OrderDetailBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ShopRepository>()) Get.lazyPut(() => ShopRepository(), fenix: true);
    Get.lazyPut(() => OrderDetailController());
  }
}
