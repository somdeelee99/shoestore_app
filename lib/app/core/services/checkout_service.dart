import 'package:get/get.dart';

import '../../data/models/cart_model.dart';
import '../../data/models/user_model.dart';

/// Holds the in-progress checkout between the 4 steps
/// (address → shipping → payment → review) without passing objects through routes.
class CheckoutService extends GetxService {
  final Rxn<AddressModel> address = Rxn<AddressModel>();
  final RxList<CartItemModel> items = <CartItemModel>[].obs;
  final RxString couponCode = ''.obs;
  final RxDouble discount = 0.0.obs;
  final RxString note = ''.obs;

  final RxString shippingMethod = 'STANDARD'.obs;
  final RxDouble shippingFee = 30000.0.obs;
  final RxString paymentMethod = 'COD'.obs;

  double get subtotal => items.fold(0, (sum, i) => sum + i.lineTotal);

  double get total =>
      (subtotal + shippingFee.value - discount.value).clamp(0, double.infinity);

  void start(List<CartItemModel> cartItems,
      {AddressModel? defaultAddress, double fee = 30000}) {
    items.assignAll(cartItems);
    address.value = defaultAddress;
    shippingMethod.value = 'STANDARD';
    shippingFee.value = fee;
    paymentMethod.value = 'COD';
    couponCode.value = '';
    discount.value = 0;
    note.value = '';
  }

  void reset() {
    items.clear();
    address.value = null;
    couponCode.value = '';
    discount.value = 0;
    shippingMethod.value = 'STANDARD';
    shippingFee.value = 30000;
    paymentMethod.value = 'COD';
    note.value = '';
  }

  List<Map<String, dynamic>> get orderItems => items
      .map((i) => {
            'productId': i.productId,
            if (i.variantId != null) 'variantId': i.variantId,
            'quantity': i.quantity,
            if (i.size != null) 'size': i.size,
            if (i.color != null) 'color': i.color,
          })
      .toList();
}
