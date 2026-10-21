import 'package:get/get.dart';

import '../../../../core/base/base_controller.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../data/models/product_model.dart';
import '../../../../data/repositories/catalog_repository.dart';

class ProductListController extends BaseController {
  final CatalogRepository _repository = Get.find<CatalogRepository>();

  final RxList<ProductModel> products = <ProductModel>[].obs;
  final RxString title = 'ສິນຄ້າ'.obs;
  final RxString sortBy = 'newest'.obs;
  final RxList<String> selectedSizes = <String>[].obs;
  final RxString selectedBrand = ''.obs;
  final RxDouble minPrice = 0.0.obs;
  final RxDouble maxPrice = 5000000.0.obs;
  final RxBool filtersOpen = false.obs;

  String? categoryId;
  String? search;
  String? brand;
  String? featured;

  final List<String> sortOptions = const ['newest', 'price-asc', 'price-desc', 'best-selling', 'rating'];
  final List<String> sizeOptions = const ['38', '39', '40', '41', '42', '43', '44', '45'];

  String get sortLabel {
    switch (sortBy.value) {
      case 'price-asc':
        return 'ລາຄາຕ່ຳ → ສູງ';
      case 'price-desc':
        return 'ລາຄາສູງ → ຕ່ຳ';
      case 'best-selling':
        return 'ຂາຍດີ';
      case 'rating':
        return 'ຄະແນນສູງ';
      default:
        return 'ມາໃໝ່';
    }
  }

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map) {
      categoryId = args['categoryId'] as String?;
      search = args['search'] as String?;
      brand = args['brand'] as String?;
      featured = args['featured'] as String?;
      title.value = (args['title'] as String?) ?? 'ສິນຄ້າ';
      if (args['sortBy'] != null) sortBy.value = args['sortBy'] as String;
    }
    fetch();
  }

  Future<void> fetch() async {
    try {
      await guard(() async {
        final list = await _repository.products({
          'categoryId': categoryId,
          'search': search,
          'brand': selectedBrand.value.isNotEmpty ? selectedBrand.value : brand,
          'featured': featured,
          'sortBy': sortBy.value,
          'sizes': selectedSizes.isEmpty ? null : selectedSizes.join(','),
          'minPrice': minPrice.value > 0 ? minPrice.value : null,
          'maxPrice': maxPrice.value < 5000000 ? maxPrice.value : null,
          'limit': 50,
        });
        products.assignAll(list);
      });
    } catch (_) {}
  }

  void setSort(String value) {
    sortBy.value = value;
    fetch();
  }

  void toggleSize(String size) {
    selectedSizes.contains(size) ? selectedSizes.remove(size) : selectedSizes.add(size);
    fetch();
  }

  void applyPrice(double min, double max) {
    minPrice.value = min;
    maxPrice.value = max;
    fetch();
  }

  void resetFilters() {
    selectedSizes.clear();
    selectedBrand.value = '';
    minPrice.value = 0;
    maxPrice.value = 5000000;
    sortBy.value = 'newest';
    fetch();
  }

  void openProduct(ProductModel product) => Get.toNamed(AppRoutes.productDetail, arguments: product.id);
}
