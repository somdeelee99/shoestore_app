import 'package:get/get.dart';

import '../../../../data/repositories/catalog_repository.dart';
import '../controllers/product_list_controller.dart';

class ProductListBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<CatalogRepository>()) Get.lazyPut(() => CatalogRepository(), fenix: true);
    Get.lazyPut(() => ProductListController());
  }
}
