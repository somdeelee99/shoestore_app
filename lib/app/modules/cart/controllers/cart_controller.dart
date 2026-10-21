import 'package:get/get.dart';

import '../../../core/base/base_controller.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/checkout_service.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../data/models/cart_model.dart';
import '../../../data/repositories/shop_repository.dart';

class CartController extends BaseController {
  final ShopRepository _repository = Get.find<ShopRepository>();

  final Rx<CartModel?> cart = Rx<CartModel?>(null);
  final RxnString couponCode = RxnString();
  final RxDouble discount = 0.0.obs;
  final RxString note = ''.obs;

  bool get isLoggedIn => Get.find<AuthService>().isLoggedIn;
  int get itemCount => cart.value?.itemCount ?? 0;
  List<CartItemModel> get items => cart.value?.items ?? [];

  double get subtotal => cart.value?.subtotal ?? 0;
  double get shippingFee => subtotal > 0 ? (subtotal >= 500000 ? 0 : 30000) : 0;
  double get total => (subtotal + shippingFee - discount.value).clamp(0, double.infinity);

  @override
  void onInit() {
    super.onInit();
    if (isLoggedIn) fetch();
  }

  Future<void> fetch() async {
    if (!isLoggedIn) return;
    try {
      await guard(() async {
        cart.value = await _repository.cart();
      }, showLoading: cart.value == null);
    } catch (_) {}
  }

  Future<void> updateQuantity(CartItemModel item, int quantity) async {
    try {
      cart.value = await _repository.updateCartItem(item.id, quantity);
    } catch (_) {
      AppSnackbar.error('ອັບເດດຈຳນວນບໍ່ສຳເລັດ');
    }
  }

  Future<void> removeItem(CartItemModel item) async {
    try {
      cart.value = await _repository.removeCartItem(item.id);
      AppSnackbar.success('ລຶບອອກຈາກກະຕ່າແລ້ວ');
    } catch (_) {
      AppSnackbar.error('ລຶບບໍ່ສຳເລັດ');
    }
  }

  Future<void> clear() async {
    await _repository.clearCart();
    cart.value = CartModel();
  }

  Future<void> applyCoupon(String code) async {
    if (code.trim().isEmpty) return;
    try {
      final value = await _repository.validateCoupon(code.trim().toUpperCase(), subtotal);
      if (value <= 0) {
        AppSnackbar.error('ຄູປອງນີ້ໃຊ້ບໍ່ໄດ້ກັບຄຳສັ່ງຊື້ນີ້');
        return;
      }
      couponCode.value = code.trim().toUpperCase();
      discount.value = value;
      AppSnackbar.success('ໃຊ້ຄູປອງສຳເລັດ ຫຼຸດ ${value.toStringAsFixed(0)} ₭');
    } catch (e) {
      AppSnackbar.error('ຄູປອງບໍ່ຖືກຕ້ອງ ຫຼື ໝົດອາຍຸ');
    }
  }

  void removeCoupon() {
    couponCode.value = null;
    discount.value = 0;
  }

  Future<void> checkout() async {
    if (items.isEmpty) return;
    if (!isLoggedIn) {
      Get.toNamed(AppRoutes.login);
      return;
    }
    final checkout = Get.find<CheckoutService>();
    checkout.start(items, fee: shippingFee);
    checkout.couponCode.value = couponCode.value ?? '';
    checkout.discount.value = discount.value;
    checkout.note.value = note.value;
    Get.toNamed(AppRoutes.checkoutAddress);
  }
}
