import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/base/base_controller.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/checkout_service.dart';
import '../../../../data/models/order_model.dart';
import '../../../../data/repositories/shop_repository.dart';

class CheckoutPaymentController extends BaseController {
  final ShopRepository _repository = Get.find<ShopRepository>();
  final CheckoutService checkout = Get.find<CheckoutService>();

  final RxList<PaymentOptionModel> options = <PaymentOptionModel>[].obs;

  static const _fallback = [
    {'id': 'COD', 'name': 'ເກັບເງິນປາຍທາງ (COD)', 'icon': 'cash'},
    {'id': 'BANK_TRANSFER', 'name': 'ໂອນທະນາຄານ', 'icon': 'bank'},
    {'id': 'E_WALLET', 'name': 'E-Wallet (BCEL One, M-Money)', 'icon': 'wallet'},
    {'id': 'CREDIT_CARD', 'name': 'ບັດເຄຣດິດ / ເດບິດ (VISA)', 'icon': 'card'},
  ];

  @override
  void onInit() {
    super.onInit();
    fetch();
  }

  Future<void> fetch() async {
    try {
      await guard(() async {
        final result = await _repository.checkoutOptions();
        options.assignAll(result.payments);
      });
    } catch (_) {
      options.assignAll(_fallback.map((e) => PaymentOptionModel.fromJson(e)).toList());
    }
  }

  void select(PaymentOptionModel option) => checkout.paymentMethod.value = option.id;

  bool isSelected(String id) => checkout.paymentMethod.value == id;

  void next() => Get.toNamed(AppRoutes.orderReview);

  IconData iconFor(String? key) {
    switch (key) {
      case 'cash':
        return Icons.payments_outlined;
      case 'bank':
        return Icons.account_balance_outlined;
      case 'wallet':
        return Icons.account_balance_wallet_outlined;
      case 'card':
        return Icons.credit_card_rounded;
      default:
        return Icons.payment_rounded;
    }
  }
}
