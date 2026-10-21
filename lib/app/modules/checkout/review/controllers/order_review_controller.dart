import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/base/base_controller.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/checkout_service.dart';
import '../../../../core/utils/app_snackbar.dart';
import '../../../../data/models/order_model.dart';
import '../../../../data/repositories/shop_repository.dart';
import '../../../cart/controllers/cart_controller.dart';

class OrderReviewController extends BaseController {
  final ShopRepository _repository = Get.find<ShopRepository>();
  final CheckoutService checkout = Get.find<CheckoutService>();

  final noteController = TextEditingController();
  final Rx<OrderModel?> placedOrder = Rx<OrderModel?>(null);

  String get paymentLabel {
    switch (checkout.paymentMethod.value) {
      case 'BANK_TRANSFER':
        return 'ໂອນທະນາຄານ';
      case 'E_WALLET':
        return 'E-Wallet';
      case 'CREDIT_CARD':
        return 'ບັດເຄຣດິດ';
      default:
        return 'ເກັບເງິນປາຍທາງ (COD)';
    }
  }

  String get shippingLabel {
    switch (checkout.shippingMethod.value) {
      case 'EXPRESS':
        return 'ສົ່ງດ່ວນ (1-2 ວັນ)';
      case 'SAME_DAY':
        return 'ສົ່ງພາຍໃນວັນ';
      default:
        return 'ສົ່ງມາດຕະຖານ (3-5 ວັນ)';
    }
  }

  Future<void> placeOrder() async {
    if (checkout.address.value == null) {
      Get.toNamed(AppRoutes.checkoutAddress);
      return;
    }
    try {
      final order = await guard(() => _repository.createOrder(
            items: checkout.orderItems,
            addressId: checkout.address.value!.id,
            recipient: checkout.address.value!.recipient,
            phone: checkout.address.value!.phone,
            shippingAddress: checkout.address.value!.fullAddress,
            paymentMethod: checkout.paymentMethod.value,
            shippingMethod: checkout.shippingMethod.value,
            couponCode: checkout.couponCode.value,
            note: noteController.text.trim().isEmpty ? null : noteController.text.trim(),
          ));
      if (order == null) return;
      placedOrder.value = order;
      await Get.find<CartController>().fetch();
      Get.offNamed(AppRoutes.orderSuccess, arguments: order);
    } catch (_) {
      AppSnackbar.error(error.value ?? 'ສັ່ງຊື້ບໍ່ສຳເລັດ');
    }
  }

  @override
  void onClose() {
    noteController.dispose();
    super.onClose();
  }
}
