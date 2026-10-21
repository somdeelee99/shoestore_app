import 'package:get/get.dart';

import '../../../../core/base/base_controller.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/utils/app_snackbar.dart';
import '../../../../data/models/order_model.dart';
import '../../../../data/repositories/shop_repository.dart';

class OrdersController extends BaseController {
  final ShopRepository _repository = Get.find<ShopRepository>();

  final RxList<OrderModel> orders = <OrderModel>[].obs;
  final RxString status = ''.obs;

  final List<Map<String, String>> tabs = const [
    {'id': '', 'label': 'ທັງໝົດ'},
    {'id': 'PENDING', 'label': 'ລໍຖ້າຢືນຢັນ'},
    {'id': 'CONFIRMED', 'label': 'ຢືນຢັນແລ້ວ'},
    {'id': 'SHIPPING', 'label': 'ກຳລັງຂົນສົ່ງ'},
    {'id': 'DELIVERED', 'label': 'ສຳເລັດ'},
    {'id': 'CANCELLED', 'label': 'ຍົກເລີກ'},
  ];

  bool get isLoggedIn => Get.find<AuthService>().isLoggedIn;

  @override
  void onInit() {
    super.onInit();
    if (isLoggedIn) fetch();
  }

  Future<void> fetch() async {
    if (!isLoggedIn) return;
    try {
      await guard(() async {
        orders.assignAll(await _repository.myOrders(status: status.value.isEmpty ? null : status.value));
      }, showLoading: orders.isEmpty);
    } catch (_) {}
  }

  void selectTab(String value) {
    status.value = value;
    fetch();
  }

  void open(OrderModel order) => Get.toNamed(AppRoutes.orderDetail, arguments: order.id);

  void track(OrderModel order) => Get.toNamed(AppRoutes.orderTracking, arguments: order.id);

  Future<void> cancel(OrderModel order) async {
    try {
      await _repository.cancelOrder(order.id);
      AppSnackbar.success('ຍົກເລີກຄຳສັ່ງຊື້ແລ້ວ');
      fetch();
    } catch (_) {
      AppSnackbar.error('ຍົກເລີກບໍ່ສຳເລັດ');
    }
  }

  Future<void> confirmReceived(OrderModel order) async {
    try {
      await _repository.confirmReceived(order.id);
      AppSnackbar.success('ຢືນຢັນຮັບສິນຄ້າແລ້ວ ຂອບໃຈ!');
      fetch();
    } catch (_) {
      AppSnackbar.error('ດຳເນີນການບໍ່ສຳເລັດ');
    }
  }
}
