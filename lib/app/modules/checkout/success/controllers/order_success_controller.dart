import 'package:get/get.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/checkout_service.dart';
import '../../../../data/models/order_model.dart';

class OrderSuccessController extends GetxController {
  final Rxn<OrderModel> order = Rxn<OrderModel>();

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is OrderModel) {
      order.value = args;
      Get.find<CheckoutService>().reset();
    }
  }

  void trackOrder() {
    if (order.value == null) return;
    Get.offAllNamed(AppRoutes.main);
    Get.toNamed(AppRoutes.orderTracking, arguments: order.value!.id);
  }

  void backHome() => Get.offAllNamed(AppRoutes.main);

  void viewOrders() => Get.offAllNamed(AppRoutes.orders);
}
