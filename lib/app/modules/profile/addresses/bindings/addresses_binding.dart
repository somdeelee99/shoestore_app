import 'package:get/get.dart';

import '../../../../data/repositories/shop_repository.dart';
import '../controllers/address_form_controller.dart';
import '../controllers/addresses_controller.dart';

class AddressesBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ShopRepository>()) Get.lazyPut(() => ShopRepository(), fenix: true);
    Get.lazyPut(() => AddressesController());
    Get.lazyPut(() => AddressFormController());
  }
}
