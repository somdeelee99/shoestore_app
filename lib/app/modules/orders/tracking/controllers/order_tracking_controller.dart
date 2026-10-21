import 'package:get/get.dart';

import '../../../../core/base/base_controller.dart';
import '../../../../data/models/order_model.dart';
import '../../../../data/repositories/shop_repository.dart';

class OrderTrackingController extends BaseController {
  final ShopRepository _repository = Get.find<ShopRepository>();

  final Rx<TrackingModel?> tracking = Rx<TrackingModel?>(null);

  String get orderId => Get.arguments is String ? Get.arguments as String : '';

  @override
  void onInit() {
    super.onInit();
    fetch();
  }

  Future<void> fetch() async {
    try {
      await guard(() async {
        tracking.value = await _repository.tracking(orderId);
      });
    } catch (_) {}
  }
}
