import 'package:get/get.dart';

import '../../../../core/base/base_controller.dart';
import '../../../../core/routes/app_navigator.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/utils/app_snackbar.dart';
import '../../../../data/models/product_model.dart';
import '../../../../data/repositories/catalog_repository.dart';
import '../../../../data/repositories/shop_repository.dart';
import '../../../cart/controllers/cart_controller.dart';

class ProductDetailController extends BaseController {
  final CatalogRepository _catalog = Get.find<CatalogRepository>();
  final ShopRepository _shop = Get.find<ShopRepository>();

  final Rx<ProductModel?> product = Rx<ProductModel?>(null);
  final RxList<ProductModel> related = <ProductModel>[].obs;
  final RxString selectedSize = ''.obs;
  final RxString selectedColor = ''.obs;
  final Rxn<ProductVariantModel> variant = Rxn<ProductVariantModel>();
  final RxInt quantity = 1.obs;
  final RxInt imageIndex = 0.obs;
  final RxBool favorite = false.obs;
  final RxInt tabIndex = 0.obs;

  String get productId => Get.arguments is String
      ? Get.arguments as String
      : (Get.arguments?['id'] as String? ?? '');

  int get maxQuantity => (variant.value?.stock ?? 0).clamp(1, 20);

  bool get canBuy =>
      product.value != null &&
      (product.value!.variants.isEmpty || variant.value != null);

  @override
  void onInit() {
    super.onInit();
    fetch();
  }

  Future<void> fetch() async {
    try {
      await guard(() async {
        final detail = await _catalog.product(productId);
        product.value = detail;
        if (detail.sizes.isNotEmpty) selectedSize.value = detail.sizes.first;
        if (detail.colors.isNotEmpty)
          selectedColor.value = detail.colors.first.name;
        _syncVariant();
        related.assignAll(await _catalog.related(productId));
        favorite.value = await _isFavorite();
      });
    } catch (_) {}
  }

  Future<bool> _isFavorite() async {
    try {
      final items = await _shop.wishlist();
      return items.any((i) => i.productId == productId);
    } catch (_) {
      return false;
    }
  }

  void selectSize(String size) {
    selectedSize.value = size;
    _syncVariant();
  }

  void selectColor(String color) {
    selectedColor.value = color;
    _syncVariant();
  }

  void _syncVariant() {
    final p = product.value;
    if (p == null) return;
    if (p.variants.isEmpty) {
      variant.value = null;
      return;
    }
    final match = p.variants.where(
      (v) =>
          v.size == selectedSize.value &&
          (selectedColor.value.isEmpty || v.color == selectedColor.value),
    );
    variant.value = match.isNotEmpty
        ? match.first
        : p.variants.firstWhereOrNull((v) => v.size == selectedSize.value);
    if (quantity.value > maxQuantity) quantity.value = maxQuantity;
  }

  bool isSizeAvailable(String size) =>
      product.value?.variants.any((v) => v.size == size && v.stock > 0) ??
      false;

  void setQuantity(int value) => quantity.value = value.clamp(1, maxQuantity);

  Future<void> toggleFavorite() async {
    if (!AppNavigator.requireLogin()) return;
    try {
      favorite.value = await _shop.toggleWishlist(productId);
      AppSnackbar.success(
          favorite.value ? 'ເພີ່ມໃນລາຍການທີ່ມັກແລ້ວ' : 'ລຶບອອກຈາກລາຍການທີ່ມັກ');
    } catch (_) {
      AppSnackbar.error('ບໍ່ສຳເລັດ ກະລຸນາລອງໃໝ່');
    }
  }

  Future<bool> addToCart({bool silent = false}) async {
    // Product details stay public. Only ordering (cart / buy now) needs auth.
    if (!AppNavigator.requireLogin()) return false;
    if (!canBuy) {
      AppSnackbar.error('ກະລຸນາເລືອກຂະໜາດ ແລະ ສີກ່ອນ');
      return false;
    }
    try {
      await guard(() => _shop.addToCart(
            productId: productId,
            variantId: variant.value?.id,
            quantity: quantity.value,
          ));
      await Get.find<CartController>().fetch();
      if (!silent) AppSnackbar.success('ເພີ່ມໃນກະຕ່າແລ້ວ 🛒');
      return true;
    } catch (_) {
      AppSnackbar.error(error.value ?? 'ເພີ່ມໃນກະຕ່າບໍ່ສຳເລັດ');
      return false;
    }
  }

  Future<void> buyNow() async {
    if (!AppNavigator.requireLogin()) return;
    final ok = await addToCart(silent: true);
    if (!ok) return;
    Get.toNamed(AppRoutes.cart);
  }

  void openProduct(ProductModel model) =>
      Get.offNamed(AppRoutes.productDetail, arguments: model.id);
}
