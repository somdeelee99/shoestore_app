import 'package:get/get.dart';

import '../../../../data/repositories/catalog_repository.dart';
import '../../../../data/repositories/shop_repository.dart';
import '../../../../core/services/checkout_service.dart';
import '../../../cart/controllers/cart_controller.dart';
import '../controllers/product_detail_controller.dart';

class ProductDetailBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<CatalogRepository>()) Get.lazyPut(() => CatalogRepository(), fenix: true);
    if (!Get.isRegistered<CartController>()) Get.lazyPut(() => CartController(), fenix: true);
    Get.lazyPut(() => ShopRepository(), fenix: true);
    if (!Get.isRegistered<CheckoutService>()) Get.put(CheckoutService(), permanent: true);
    Get.lazyPut(() => ProductDetailController());
  }
}
