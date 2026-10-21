import 'package:get/get.dart';

import '../../../../core/base/base_controller.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/utils/app_snackbar.dart';
import '../../../../data/models/cart_model.dart';
import '../../../../data/repositories/shop_repository.dart';

class WishlistController extends BaseController {
  final ShopRepository _repository = Get.find<ShopRepository>();

  final RxList<WishlistItemModel> items = <WishlistItemModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetch();
  }

  Future<void> fetch() async {
    try {
      await guard(() async {
        items.assignAll(await _repository.wishlist());
      }, showLoading: items.isEmpty);
    } catch (_) {}
  }

  void openProduct(WishlistItemModel item) =>
      Get.toNamed(AppRoutes.productDetail, arguments: item.productId);

  Future<void> remove(WishlistItemModel item) async {
    try {
      await _repository.toggleWishlist(item.productId);
      items.removeWhere((e) => e.productId == item.productId);
      AppSnackbar.success('ເອົາອອກຈາກລາຍການທີ່ຖືກໃຈແລ້ວ');
    } catch (_) {
      AppSnackbar.error('ດຳເນີນການບໍ່ສຳເລັດ');
    }
  }

  Future<void> addToCart(WishlistItemModel item) async {
    try {
      await _repository.addToCart(productId: item.productId, quantity: 1);
      AppSnackbar.success('ເພີ່ມໃສ່ກະຕ່າແລ້ວ');
    } catch (_) {
      AppSnackbar.error('ເພີ່ມໃສ່ກະຕ່າບໍ່ສຳເລັດ');
    }
  }
}
