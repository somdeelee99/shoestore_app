import 'package:get/get.dart';

import '../../../../core/base/base_controller.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/checkout_service.dart';
import '../../../../data/models/user_model.dart';
import '../../../../data/repositories/shop_repository.dart';

class CheckoutAddressController extends BaseController {
  final ShopRepository _repository = Get.find<ShopRepository>();
  final CheckoutService checkout = Get.find<CheckoutService>();

  final RxList<AddressModel> addresses = <AddressModel>[].obs;
  final Rxn<AddressModel> selected = Rxn<AddressModel>();

  @override
  void onInit() {
    super.onInit();
    fetch();
  }

  Future<void> fetch() async {
    try {
      await guard(() async {
        addresses.assignAll(await _repository.addresses());
        selected.value = checkout.address.value ??
            (addresses.isNotEmpty ? addresses.firstWhere((a) => a.isDefault, orElse: () => addresses.first) : null);
      });
    } catch (_) {}
  }

  void select(AddressModel address) => selected.value = address;

  void next() {
    if (selected.value == null) {
      Get.snackbar('ຕ້ອງການທີ່ຢູ່', 'ກະລຸນາເລືອກ ຫຼື ເພີ່ມທີ່ຢູ່ຈັດສົ່ງ');
      return;
    }
    checkout.address.value = selected.value;
    Get.toNamed(AppRoutes.checkoutShipping);
  }

  Future<void> addNewAddress() async {
    await Get.toNamed(AppRoutes.addressForm);
    fetch();
  }
}
