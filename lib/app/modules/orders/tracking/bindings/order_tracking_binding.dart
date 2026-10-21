import 'package:get/get.dart';

import '../../../../data/repositories/shop_repository.dart';
import '../controllers/order_tracking_controller.dart';

class OrderTrackingBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ShopRepository>()) Get.lazyPut(() => ShopRepository(), fenix: true);
    Get.lazyPut(() => OrderTrackingController());
  }
}
