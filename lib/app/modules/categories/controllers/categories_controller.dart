import 'package:get/get.dart';

import '../../../core/base/base_controller.dart';
import '../../../core/routes/app_routes.dart';
import '../../../data/models/product_model.dart';
import '../../../data/repositories/catalog_repository.dart';

class CategoriesController extends BaseController {
  final CatalogRepository _repository = Get.find<CatalogRepository>();

  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final RxList<String> brands = <String>[].obs;
  final RxString selectedBrand = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetch();
  }

  Future<void> fetch() async {
    try {
      await guard(() async {
        final results = await Future.wait([_repository.categories(), _repository.brands()]);
        categories.assignAll(results[0] as List<CategoryModel>);
        brands.assignAll(results[1] as List<String>);
      });
    } catch (_) {}
  }

  void openCategory(CategoryModel category) =>
      Get.toNamed(AppRoutes.productList, arguments: {'categoryId': category.id, 'title': category.name});

  void openBrand(String brand) =>
      Get.toNamed(AppRoutes.productList, arguments: {'brand': brand, 'title': brand});

  void openAll() => Get.toNamed(AppRoutes.productList, arguments: {'title': 'ສິນຄ້າທັງໝົດ'});
}
