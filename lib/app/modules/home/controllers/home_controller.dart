import 'package:get/get.dart';

import '../../../core/base/base_controller.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/services/auth_service.dart';
import '../../../data/models/product_model.dart';
import '../../../data/repositories/catalog_repository.dart';
import '../../cart/controllers/cart_controller.dart';

class HomeController extends BaseController {
  final CatalogRepository _repository = Get.find<CatalogRepository>();

  final Rx<HomeModel?> home = Rx<HomeModel?>(null);
  final RxInt bannerIndex = 0.obs;
  final RxString searchTerm = ''.obs;

  bool get loggedIn => Get.find<AuthService>().isLoggedIn;
  String get userName => Get.find<AuthService>().user?.name ?? 'ລູກຄ້າ';

  @override
  void onInit() {
    super.onInit();
    fetch();
  }

  Future<void> fetch() async {
    try {
      await guard(() async {
        home.value = await _repository.home();
      });
    } catch (_) {
      // error surfaced through [error]
    }
  }

  void openProduct(ProductModel product) => Get.toNamed(AppRoutes.productDetail, arguments: product.id);

  void openCategory(String categoryId, String title) =>
      Get.toNamed(AppRoutes.productList, arguments: {'categoryId': categoryId, 'title': title});

  void openAll({String? section}) => Get.toNamed(AppRoutes.productList, arguments: {
        'title': section ?? 'ສິນຄ້າທັງໝົດ',
        if (section == 'ສິນຄ້າແນະນຳ') 'featured': 'true',
        if (section == 'ຂາຍດີ') 'sortBy': 'best-selling',
      });

  void submitSearch(String value) {
    if (value.trim().isEmpty) return;
    Get.toNamed(AppRoutes.productList, arguments: {'search': value.trim(), 'title': 'ຜົນການຄົ້ນຫາ'});
  }

  CartController get cart => Get.find<CartController>();
}
