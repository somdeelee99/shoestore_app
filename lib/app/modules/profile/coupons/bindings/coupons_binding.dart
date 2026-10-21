import 'package:get/get.dart';

import '../../../../data/repositories/shop_repository.dart';
import '../controllers/coupons_controller.dart';

class CouponsBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ShopRepository>()) Get.lazyPut(() => ShopRepository(), fenix: true);
    Get.lazyPut(() => CouponsController());
  }
}
