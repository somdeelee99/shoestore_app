import 'package:get/get.dart';

import '../../../../core/base/base_controller.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/utils/app_snackbar.dart';
import '../../../../data/models/order_model.dart';
import '../../../../data/repositories/shop_repository.dart';

class OrderDetailController extends BaseController {
  final ShopRepository _repository = Get.find<ShopRepository>();

  final Rx<OrderModel?> order = Rx<OrderModel?>(null);

  String get orderId => Get.arguments is String ? Get.arguments as String : '';

  @override
  void onInit() {
    super.onInit();
    fetch();
  }

  Future<void> fetch() async {
    try {
      await guard(() async {
        order.value = await _repository.orderDetail(orderId);
      });
    } catch (_) {}
  }

  void openTracking() => Get.toNamed(AppRoutes.orderTracking, arguments: orderId);

  void openChat() => Get.toNamed(AppRoutes.chat);

  Future<void> cancel() async {
    try {
      await _repository.cancelOrder(orderId);
      AppSnackbar.success('ຍົກເລີກຄຳສັ່ງຊື້ແລ້ວ');
      fetch();
    } catch (_) {
      AppSnackbar.error('ຍົກເລີກບໍ່ສຳເລັດ');
    }
  }

  Future<void> confirmReceived() async {
    try {
      await _repository.confirmReceived(orderId);
      AppSnackbar.success('ຢືນຢັນຮັບສິນຄ້າແລ້ວ');
      fetch();
    } catch (_) {
      AppSnackbar.error('ດຳເນີນການບໍ່ສຳເລັດ');
    }
  }

  String paymentMethodLabel(String method) {
    switch (method) {
      case 'BANK_TRANSFER':
        return 'ໂອນທະນາຄານ';
      case 'E_WALLET':
        return 'E-Wallet';
      case 'CREDIT_CARD':
        return 'ບັດເຄຣດິດ';
      default:
        return 'ເກັບເງິນປາຍທາງ';
    }
  }

  String shippingMethodLabel(String method) {
    switch (method) {
      case 'EXPRESS':
        return 'ສົ່ງດ່ວນ (1-2 ວັນ)';
      case 'SAME_DAY':
        return 'ສົ່ງພາຍໃນວັນ';
      default:
        return 'ສົ່ງມາດຕະຖານ (3-5 ວັນ)';
    }
  }
}
