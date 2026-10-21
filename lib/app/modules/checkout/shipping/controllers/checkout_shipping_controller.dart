import 'package:get/get.dart';

import '../../../../core/base/base_controller.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/checkout_service.dart';
import '../../../../data/models/order_model.dart';
import '../../../../data/repositories/shop_repository.dart';

class CheckoutShippingController extends BaseController {
  final ShopRepository _repository = Get.find<ShopRepository>();
  final CheckoutService checkout = Get.find<CheckoutService>();

  final RxList<ShippingOptionModel> options = <ShippingOptionModel>[].obs;

  static const _fallback = [
    {'id': 'STANDARD', 'name': 'Standard Delivery', 'eta': '3-5 ວັນ', 'fee': 30000},
    {'id': 'EXPRESS', 'name': 'Express Delivery', 'eta': '1-2 ວັນ', 'fee': 60000},
    {'id': 'SAME_DAY', 'name': 'Same Day Delivery', 'eta': 'ພາຍໃນວັນ', 'fee': 120000},
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
        options.assignAll(result.shipping);
      });
    } catch (_) {
      options.assignAll(_fallback.map((e) => ShippingOptionModel.fromJson(e)).toList());
    }
  }

  void select(ShippingOptionModel option) {
    checkout.shippingMethod.value = option.id;
    checkout.shippingFee.value = option.fee;
  }

  bool isSelected(String id) => checkout.shippingMethod.value == id;

  void next() => Get.toNamed(AppRoutes.checkoutPayment);
}
