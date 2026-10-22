import '../models/cart_model.dart';
import '../models/order_model.dart';
import '../models/user_model.dart';
import '../providers/api_provider.dart';

class ShopRepository {
  ShopRepository({
    CartProvider? cartProvider,
    OrderProvider? orderProvider,
    ProfileProvider? profileProvider,
  })  : _cart = cartProvider ?? CartProvider(),
        _orders = orderProvider ?? OrderProvider(),
        _profile = profileProvider ?? ProfileProvider();

  final CartProvider _cart;
  final OrderProvider _orders;
  final ProfileProvider _profile;

  /* ---------------------------------- cart ---------------------------------- */

  Future<CartModel> cart() async {
    final res = await _cart.cart();
    return CartModel.fromJson(
        Map<String, dynamic>.from(res['data'] as Map? ?? res));
  }

  Future<CartModel> addToCart(
      {required String productId, String? variantId, int quantity = 1}) async {
    final res = await _cart.add(
        productId: productId, variantId: variantId, quantity: quantity);
    return CartModel.fromJson(
        Map<String, dynamic>.from(res['data'] as Map? ?? res));
  }

  Future<CartModel> updateCartItem(String itemId, int quantity) async {
    final res = await _cart.update(itemId, quantity);
    return CartModel.fromJson(
        Map<String, dynamic>.from(res['data'] as Map? ?? res));
  }

  Future<CartModel> removeCartItem(String itemId) async {
    final res = await _cart.remove(itemId);
    return CartModel.fromJson(
        Map<String, dynamic>.from(res['data'] as Map? ?? res));
  }

  Future<void> clearCart() => _cart.clear();

  /* -------------------------------- wishlist -------------------------------- */

  Future<List<WishlistItemModel>> wishlist() async {
    final res = await _cart.wishlist();
    return _cart.listOf(res['data'], WishlistItemModel.fromJson);
  }

  Future<bool> toggleWishlist(String productId) async {
    final res = await _cart.toggleWishlist(productId);
    final data = res['data'];
    if (data is Map) return data['added'] == true;
    return false;
  }

  /* -------------------------------- addresses ------------------------------- */

  Future<List<AddressModel>> addresses() async {
    final res = await _profile.addresses();
    return _profile.listOf(res['data'], AddressModel.fromJson);
  }

  Future<AddressModel> createAddress(Map<String, dynamic> body) async {
    final res = await _profile.createAddress(body);
    return AddressModel.fromJson(
        Map<String, dynamic>.from(res['data'] as Map? ?? res));
  }

  Future<AddressModel> updateAddress(
      String id, Map<String, dynamic> body) async {
    final res = await _profile.updateAddress(id, body);
    return AddressModel.fromJson(
        Map<String, dynamic>.from(res['data'] as Map? ?? res));
  }

  Future<void> deleteAddress(String id) => _profile.deleteAddress(id);

  /* --------------------------------- orders --------------------------------- */

  Future<OrderModel> createOrder({
    required List<Map<String, dynamic>> items,
    String? addressId,
    String? recipient,
    String? phone,
    String? shippingAddress,
    required String paymentMethod,
    required String shippingMethod,
    String? couponCode,
    String? note,
  }) async {
    final res = await _orders.create({
      'items': items,
      if (addressId != null) 'addressId': addressId,
      if (recipient != null) 'recipient': recipient,
      if (phone != null) 'phone': phone,
      if (shippingAddress != null) 'shippingAddress': shippingAddress,
      'paymentMethod': paymentMethod,
      'shippingMethod': shippingMethod,
      if (couponCode != null && couponCode.isNotEmpty) 'couponCode': couponCode,
      if (note != null && note.isNotEmpty) 'note': note,
    });
    return OrderModel.fromJson(
        Map<String, dynamic>.from(res['data'] as Map? ?? res));
  }

  Future<List<OrderModel>> myOrders({String? status, int page = 1}) async {
    final res = await _orders.myOrders(status: status, page: page);
    return _orders.listOf(res['data'], OrderModel.fromJson);
  }

  Future<OrderModel> orderDetail(String id) async {
    final res = await _orders.detail(id);
    return OrderModel.fromJson(
        Map<String, dynamic>.from(res['data'] as Map? ?? res));
  }

  Future<TrackingModel> tracking(String id) async {
    final res = await _orders.tracking(id);
    return TrackingModel.fromJson(
        Map<String, dynamic>.from(res['data'] as Map? ?? res));
  }

  Future<void> cancelOrder(String id) => _orders.cancel(id);

  Future<void> confirmReceived(String id) => _orders.confirmReceived(id);

  Future<CheckoutOptionsModel> checkoutOptions() async {
    final res = await _orders.checkoutOptions();
    return CheckoutOptionsModel.fromJson(
        Map<String, dynamic>.from(res['data'] as Map? ?? res));
  }

  Future<List<CouponModel>> coupons() async {
    final res = await _orders.coupons();
    return _orders.listOf(res['data'], CouponModel.fromJson);
  }

  Future<double> validateCoupon(String code, double subtotal) async {
    final res = await _orders.validateCoupon(code, subtotal);
    final data = res['data'];
    if (data is Map && data['discount'] != null) {
      return double.tryParse(data['discount'].toString()) ?? 0;
    }
    return 0;
  }
}
