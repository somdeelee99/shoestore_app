import 'package:get/get.dart';

import '../../../core/services/checkout_service.dart';
import '../../../data/repositories/catalog_repository.dart';
import '../../cart/controllers/cart_controller.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<CheckoutService>()) Get.put(CheckoutService(), permanent: true);
    Get.lazyPut(() => CatalogRepository(), fenix: true);
    Get.lazyPut(() => CartController(), fenix: true);
    Get.lazyPut(() => HomeController());
  }
}
