import 'package:get/get.dart';

import '../../../data/repositories/catalog_repository.dart';
import '../controllers/categories_controller.dart';

class CategoriesBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<CatalogRepository>()) Get.lazyPut(() => CatalogRepository(), fenix: true);
    Get.lazyPut(() => CategoriesController());
  }
}
